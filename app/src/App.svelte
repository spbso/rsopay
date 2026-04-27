<svelte:head>
	<script src="https://code.jquery.com/jquery-3.7.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
	<script src="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/js/bootstrap.bundle.min.js" integrity="sha384-ho+j7jyWK8fNQe+A12Hb8AhRq26LrZ/JpcUGGOn+Y7RsweNrtN/tE3MoK7ZeZDyx" crossorigin="anonymous"></script>
	<link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@4.6.2/dist/css/bootstrap.min.css" integrity="sha384-xOolHFLEh07PJGoPkLv1IbcEPTNtaed2xpHsD9ESMhqIYd0nLMwNLD69Npy4HI+N" crossorigin="anonymous">
</svelte:head>

<script>
	import { ButtonGroup, Form, FormGroup, Input, Label, Button, Col, Row} from 'sveltestrap';
	export let code;

	const defaultQrCodeData = "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVQYV2NgYAAAAAMAAWgmWQ0AAAAASUVORK5CYII=";
	const perPersonAmount = 50000;

	let fio = "", group = "", peopleCount = 5, payeeIsGroup = false, selection = "person";
	let qrCodeData = defaultQrCodeData;
	let validData = false;
	
	function showQr(e) {
		e.preventDefault();
		let paymentCount;
		let purpose;
		if (payeeIsGroup) {
			purpose = `Членский взнос ${group} ${peopleCount} чел.`;
			paymentCount = peopleCount;
		} else {
			purpose = `Членский взнос за текущий отчетный год ${fio} ${group}`;
			paymentCount = 1;
		}
		const sum = paymentCount * perPersonAmount;
		let encodedValue = `ST00012|Name=Санкт-Петербургское региональное отделение Молодёжной общероссийской общественной организации "Российские Студенческие Отряды"|PersonalAcc=40703810720000001316|BankName=ООО \"Банк Точка\"|BIC=044525104|CorrespAcc=30101810745374525104|KPP=784201001|PayeeINN=7841290484|Purpose=${purpose}|Sum=${sum}`;
		code.toDataURL(encodedValue, { errorCorrectionLevel: 'L', width: 300})
			.then(url => {
				qrCodeData = url;
			})
			.catch(err => {
				console.error(err)
			});
	}
	
	function hideQr() {
		qrCodeData = defaultQrCodeData;
	}
	
	function changePayee(e) {
		payeeIsGroup = selection === "group";
		hideQr();
		validateInput();
	}

	function validateInput() {
		validData = group != "";
		if (!payeeIsGroup) {
			validData = validData && (fio != "");
		}
		hideQr();
	}
</script>

<main>
	<div class="container-fluid">
		<Row>
			<Col class="col-md-4 offset-md-4">
				<h1>Я люблю РСО</h1>
			</Col>
		</Row>
		<Row>
			<Col class="offset-md-4 col-md-4">
				<Form>
					<div style="text-align:center">
						<!--					<ButtonGroup class="btn-group-toggle" data-toggle="buttons">-->
						<!--						<label class="btn btn-primary" class:active={!payeeIsGroup}>-->
						<!--							<input bind:group={selection} type="radio" value="person" on:change="{changePayee}" checked="{!payeeIsGroup}"/>Оплата за человека-->
						<!--						</label>-->
						<!--						<label class="btn btn-primary" class:active={payeeIsGroup}>-->
						<!--							<input bind:group={selection} type="radio" value="group" on:change="{changePayee}" checked="{payeeIsGroup}"/>Оплата за отряд-->
						<!--						</label>-->
						<!--					</ButtonGroup>-->
					</div>
					{#if payeeIsGroup }
					<FormGroup>
						<Label>Название отряда</Label>
						<Input bind:value={group} placeholder="ССервО Делюкс" on:change="{validateInput}"/>
					</FormGroup>
					<FormGroup>
						<Label>Количество человек: {peopleCount}</Label>
						<Input type="range" class="form-control-range" min="2" max="100" step="1" bind:value={peopleCount}/>
					</FormGroup>
					{:else}
					<FormGroup>
						<FormGroup>
							<Label>Название отряда</Label>
							<Input bind:value={group} placeholder="ССервО Делюкс" on:change="{validateInput}"/>
						</FormGroup>
						<Label>ФИО</Label>
						<Input bind:value={fio} placeholder="Иванов Иван Иванович" on:change="{validateInput}"/>
					</FormGroup>
					{/if}
					<div class="mb-3" style="text-align: center">
						<Button on:click="{showQr}" disabled={!validData}>Показать код</Button>
					</div>
				</Form>
			</Col>
		</Row>
		<Row>
			<Col class="offset-md-4 col-md-4">
				<div style="text-align:center">
					<img src={qrCodeData} alt="QR код"/>
				</div>
			</Col>
		</Row>
	</div>
</main>
