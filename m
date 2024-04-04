Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05on2097.outbound.protection.outlook.com [40.107.22.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C27C1101E6
	for <netfilter-devel@vger.kernel.org>; Thu,  4 Apr 2024 10:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.22.97
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712227184; cv=fail; b=AmUWpwUSd31u7pb7pyrhOj8hyKzYVYHx250NNJwsueAnmewik0nip7uM0Wiv0VGxLqPpWbbgF+7shnL3hZH1axamiO2P4pJp5dSwSTIK9mW6PzvO2tz7G3+ztGVfFPB2Bv95i4p09NrTUhL9F0sxlNXs4g/826iy4hitiznIFak=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712227184; c=relaxed/simple;
	bh=/Z3BlsBhWjarK8noFYCxDcJ6Q3wKSFdnTIEfDnQZ0gs=;
	h=From:To:Subject:Date:Message-ID:Content-Type:MIME-Version; b=dZb6VNmOekRJOxOq9WCcCKgrmIvanuNTPg1flmvYKDa2KGwg62Pr+ijaVckFCznjzMuZAxVVOvUFj1d3y3Zk9IV9AX44JHQRKmZjXa/DTnljqC2+fhOyjCY8Kh17+pgvlqPC7dZM/8bpnWofWPL8Xe9v42o2jLt934zx9kVO88E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=keba.com; spf=pass smtp.mailfrom=keba.com; dkim=pass (2048-bit key) header.d=keba.com header.i=@keba.com header.b=HqNx7A04; arc=fail smtp.client-ip=40.107.22.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=keba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=keba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=keba.com header.i=@keba.com header.b="HqNx7A04"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ATc/FjJD4yhDtSQr7GCJPhxQp0u5t2PsfcCUa4jBAYvTv65xahmvuUZdETf+a9qnQ3xEK2yw8P5QGD3xr6nvnyww12gf6nr6KTQQ7l9zIjUnpaI0Df2z10w8DUX4YYlxOvYBV6sHCo76C+a33hboawSZKPCTZMjtAwq5kR6bjGkLRsDCIRl0SQApKYvfOT5H8CGytLRPgsOQj4toUzlY5kS+fa4BY5X//iE4ZVrznrJobX+SbuZH05FkZWn9f+0mqlKKWrZM0X+O8NVO7k6F0bW3WnqegU850PZ9KFOMVuWSPy1Uv8MFLl3gR39A9+PBf7Tf/Kh5wy769gjyDGcrOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6bjxmuEaZqsYTQBXh2TjWohSMJ14JckPvTdmoKhaqZg=;
 b=EWzDrTl19vVj8QMWYtgfIKCjhywGzTepbqxchyoIB0JFhUPcXH2HCroJO5FpgxbRX/ke/lUq02CBJoQRBIU8APKkbGmZSTV2vVkE1tG8bZePCq8YupICRW7N0bGdipzywH4VvCBBZBVPU3rf9DViNMBChKXD6TiuhxQvFKjdnDbwSkVtfvHZYenD2r/TGQuduXgdfo0RVkPxcPgVFvyE0DmYal2fouagTRxpyqpffU2TvnrUL2x48mC+5cMF4/i7Z8t3ndBHFlktBY8hRDG6EU/5atg2aqdN3YG/h+ad0nP8IT5pMFubBLdzb9jTi0EJvhgFA1xkVjkSDG+IvkR/Nw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=keba.com; dmarc=pass action=none header.from=keba.com;
 dkim=pass header.d=keba.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=keba.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6bjxmuEaZqsYTQBXh2TjWohSMJ14JckPvTdmoKhaqZg=;
 b=HqNx7A04wrvlNyipPN78pbeCMBkI8kUhbVjJYQIh1XmaBrPF5R/4KnAvpPFb526T5IJKTq98fbIeYf+g0IBuuVYmDPtme1yvoP0BXXy+ujmwVz6yiRuE66A+L3LhDVj7FIUREb/WieVrqHftGgP4rn5RmJApXj2pUTgCAsLoHmr/JIEVCtjr3OdOEF8Dd86eqhc1aeSgyyyh8OoA/GaUGW6y3zIZXirc5Ou68tAwJE0vB2ApRhgBdXukaG1OEacq/hYmXNlrU+oaYCvjKbzld0sT42UOCiaCh0w9hbV6XeYBNRZ3sSUJ/b9XC7dFOLKwnypDa7mtGLTp9t2q8KnCgQ==
Received: from AS8PR07MB7176.eurprd07.prod.outlook.com (2603:10a6:20b:25e::13)
 by DB9PR07MB9955.eurprd07.prod.outlook.com (2603:10a6:10:4cc::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7409.46; Thu, 4 Apr
 2024 10:39:39 +0000
Received: from AS8PR07MB7176.eurprd07.prod.outlook.com
 ([fe80::a879:d5a6:5dc8:580c]) by AS8PR07MB7176.eurprd07.prod.outlook.com
 ([fe80::a879:d5a6:5dc8:580c%7]) with mapi id 15.20.7409.042; Thu, 4 Apr 2024
 10:39:39 +0000
From: bre Breitenberger Markus <bre@keba.com>
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: [PATCH] conntrackd: Fix signal handler race-condition
Thread-Topic: [PATCH] conntrackd: Fix signal handler race-condition
Thread-Index: AdqGfAdRv5PstWKsR9W86N3IP8kd5A==
Date: Thu, 4 Apr 2024 10:39:39 +0000
Message-ID:
 <AS8PR07MB7176A6FE25478A7C1BA4BF29CD3C2@AS8PR07MB7176.eurprd07.prod.outlook.com>
Accept-Language: de-DE, en-US
Content-Language: de-DE
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f7ce15f3-f9cf-4fe0-be64-c49742693951_ActionId=1131b6fa-ab14-45d5-ac81-db838c2b9122;MSIP_Label_f7ce15f3-f9cf-4fe0-be64-c49742693951_ContentBits=0;MSIP_Label_f7ce15f3-f9cf-4fe0-be64-c49742693951_Enabled=true;MSIP_Label_f7ce15f3-f9cf-4fe0-be64-c49742693951_Method=Standard;MSIP_Label_f7ce15f3-f9cf-4fe0-be64-c49742693951_Name=Confidential;MSIP_Label_f7ce15f3-f9cf-4fe0-be64-c49742693951_SetDate=2024-04-04T10:36:31Z;MSIP_Label_f7ce15f3-f9cf-4fe0-be64-c49742693951_SiteId=83e2508b-c1e1-4014-8ab1-e34a653fca88;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AS8PR07MB7176:EE_|DB9PR07MB9955:EE_
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 U9ZWH2/Lx5BhY3duK2jJygYTXpdlWiNpa1wuQB83xoDVZgFmWWIrujbYIderd0ggvxRS275RrFE2pIdecrbUEfvpZILfZYoXvXeQkhVGPZZOiqZ5VFejDUu1Y78CPFf9J4DG2McR3x9eftiDX+0Fr3lT7QA4DyIDpI+kYdMR2PGNxn0maNzFRzh1odzmS5NFe26+hhrp2c85upOJJJrk3Nk3GsRlJOf+E5547fcJ2IPiSQ4NOhYJDldQ2WJLxIOYyODkQ6tLGSYHL9BhvANzjwBkz9IiSiyuqnbYgMvs3s+MwcIbtzk0llWvp6Vtua6KVUZePOITFyNzYtc9PPT2U01FI2lHB0xCGBxQ1lBoaNjWIyiNBg0jM0bTXFGQdZeLb7Ys/uZtOgmSJbBtffbStv/NnMtCU+6JKGedL3/E5eH6XND9k+OZ0lBi750260DyYim7F6nuMA/cpM1Sod8Q7cib+ywXo3EHKoiNFD3AoSWG/dfOPVwl6tPsnVEJEvICIg4LRemRXgMjlgaJziFky8984Z2Hmi7UZunA6/yyrabR2RfcnxRn1pJ7sR8XVqjGoH0j2YonURwHRlY4TCxKdpZB6xPTDXwm+zgfl2rv648Mh8cEBAN9rypdXNFDmWrst4ld22Wv5Wt7PuXMDEhyI1JYYmQsoljA2hxxAohjGuw=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AS8PR07MB7176.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?lpnslolz0re5XTK2FGJ7BHR90scM132xpARsKNlNFzZDgx4mFQkRUO4iGF32?=
 =?us-ascii?Q?SPkXICdF4UaQLzrtq97cwbPi2/YXSRVxrtwddfJLZVsDOi9+M7LojNffbBFC?=
 =?us-ascii?Q?Usm7+EMeWZ8JFZtX+bn5v8m9Y189BAIww8WTlJPEW0WJQJ+FgxDvlXWzt4N1?=
 =?us-ascii?Q?J1WsQbS0dnSSi8S+D2aEQt4hvA8rK1nNb2ASVfZ1bwG/9hsPDePq7wbqsdgI?=
 =?us-ascii?Q?EI7iJM2KGmsJa5X8X8fMx0vYRv9Dgh0Y61EJo7UbZaJN16T9I7HDYU3IGcdQ?=
 =?us-ascii?Q?/gL9rvY19oIJsB3n2ve8Z+VOkLct7HgyxBJSjw5QWWZwvNu+r0JX8n316guz?=
 =?us-ascii?Q?yEpj6VL/r5Tofn3piiwMAS+5SFrLNvl/5GkH9gSay6v0E7wn7fB7JS5rHxXy?=
 =?us-ascii?Q?uDBIEtZdwY5K3EFtP0Li/YKKWFnLpbiWHGoJVTB0snbTxIHgOAm5SHrBfOrz?=
 =?us-ascii?Q?An1Mi3qfA8neIzJZFHEUvu2F3aln8qUB6eKomXae45QKDEILQrZRDlMs1lMB?=
 =?us-ascii?Q?TdFA2SIiwiut7atDi8Md9L3t9KfmxeeAC3hdh9owRqXD/ULce9V+SrdSuAH6?=
 =?us-ascii?Q?zLYfK1rwZXsNDHPbrqt1aB9WK+Z/KoaT/0hVRFlZ9xf5I+FQj3x0x9Eu2C65?=
 =?us-ascii?Q?geiC9udYdJp8EJ8FWhFNVzJsD7flGt2Ta9H5B8gQt6FhKGDWxd6LH6VztWxV?=
 =?us-ascii?Q?AMJoqL2xy8LwX5Q7PIn9uKT0QcC+wN0I0RIq4ucTZRsb6QOoFFzSuVtfp026?=
 =?us-ascii?Q?vHV4kIdXQQI6UalNaK7O3zW4KC21vO/TdNGUQEmgAZF0hE+gG5/Y+n67z/nT?=
 =?us-ascii?Q?VyWb6Jcf8TQtybK1l3+U7DuVwjX952KKD4C7FUQrpntod4D4LsNWOpZrjyhQ?=
 =?us-ascii?Q?p27oIpgLrd9LJ9qLrCW/1kh1Wu3BsuObS5wlo04IShnw8B6GkkIJ9udF4DKc?=
 =?us-ascii?Q?ADxg9Ik0d/Jgv/23JhHouAMsgDlwwgOdPSU8AXZBnOgCr3Yde0IFxx0kHFld?=
 =?us-ascii?Q?Ox5pxz+0GPZ+KZnCjfEv6cUqQKbB1vVGoZC1PxN6LdsrQsWC9wnaDPECP609?=
 =?us-ascii?Q?CGlOY5yqi2xE8T8Hj3Kz6JIoGrk+RGK/AKs4AW/M9PUApZy7CF/pR5khyhFd?=
 =?us-ascii?Q?8ABQ0gETNwFVLv/RLp1BiNH3nVQhtWA/Xi+5QH08xEHLMvZchH/Xtj4KBMtS?=
 =?us-ascii?Q?okOCFNRN8XB65QmZiaga4JGWQb0/rWWZgea3CSPvZy9ezAp+8rRqldEiBiM7?=
 =?us-ascii?Q?MChFwQnb5QXPNC+HCnkbWLiixcOtASfc+KQCmJThoiJa6Izjj4gPMDLkwQsw?=
 =?us-ascii?Q?k9Pz1/yFUPs9XQWIC6E1QAyzOt4hhvSiN6XVg0l7heqZhZ+eP5yrLAu6zwAL?=
 =?us-ascii?Q?77wXaRKaXK6UrJE32V1pXtAWVDEO8+rtFUA0bicFU9gPN1z1gBLTszDtucG2?=
 =?us-ascii?Q?9Zo9H1p3uXlmUU6NYGUwKNmpQOfVsUSjN16CXegYwP4ATUru/sR+HHAocq4z?=
 =?us-ascii?Q?bePfVjAgFFEeq1576AFEvFMT6SHEoZjrxu0/Q+gXF8nhGLa1Lirm8HxQbQKE?=
 =?us-ascii?Q?doClUJe4UMsaPO0M+Fc=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: keba.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AS8PR07MB7176.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66aff2bd-e2d4-46ea-7355-08dc549387ab
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Apr 2024 10:39:39.2315
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2508b-c1e1-4014-8ab1-e34a653fca88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: x2uU6CnYcquN/SzLsZc1tPU7HDFm8GkPHeffOVPJKPUzEky8ft6opRAWXhpGeWTJ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9PR07MB9955

Install signal handlers after everything is initialized as there is a
race condition that can happen when the process gets terminated after
the signal handler is installed but before all fields in the global
state are set up correctly, leading to a SIGSEGV as the cleanup code
dereferences uninitialized pointers.

Signed-Off-By: Markus Breitenberger <bre@keba.com>
---
 src/run.c | 23 ++++++++++++-----------
 1 file changed, 12 insertions(+), 11 deletions(-)

diff --git a/src/run.c b/src/run.c
index 37a0eb1..b31fff5 100644
--- a/src/run.c
+++ b/src/run.c
@@ -277,6 +277,18 @@ init(void)
 	}
 	register_fd(STATE(local).fd, local_cb, NULL, STATE(fds));
=20
+	/* Initialization */
+	if (CONFIG(flags) & (CTD_SYNC_MODE | CTD_STATS_MODE))
+		if (ctnl_init() < 0)
+			return -1;
+
+#ifdef BUILD_CTHELPER
+	if (CONFIG(flags) & CTD_HELPER) {
+		if (cthelper_init() < 0)
+			return -1;
+	}
+#endif
+
 	/* Signals handling */
 	sigemptyset(&STATE(block));
 	sigaddset(&STATE(block), SIGTERM);
@@ -296,17 +308,6 @@ init(void)
 	if (signal(SIGCHLD, child) =3D=3D SIG_ERR)
 		return -1;
=20
-	/* Initialization */
-	if (CONFIG(flags) & (CTD_SYNC_MODE | CTD_STATS_MODE))
-		if (ctnl_init() < 0)
-			return -1;
-
-#ifdef BUILD_CTHELPER
-	if (CONFIG(flags) & CTD_HELPER) {
-		if (cthelper_init() < 0)
-			return -1;
-	}
-#endif
 	time(&STATE(stats).daemon_start_time);
=20
 	dlog(LOG_NOTICE, "initialization completed");
--=20
2.43.0
