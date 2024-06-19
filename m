Received: from EUR04-DB3-obe.outbound.protection.outlook.com (mail-db3eur04on2108.outbound.protection.outlook.com [40.107.6.108])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 030FC770F3
	for <netfilter-devel@vger.kernel.org>; Wed, 19 Jun 2024 07:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.6.108
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718783308; cv=fail; b=oqDBJvRxTQPfNGJotezyb+ea+PvHn4r2KIUbkjtVC93EB/eYPjAU/WbiJJK/a+QynRRk5kv3SBgbPYL/nZPFmFJkNpAiHL3c89FzcP/FNXn+UBHAWgXu79jWBdfhhmnURcOsNRYkhMaZ8CyhJ9gWBF5JUXciRq/vWgX898Yi8aM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718783308; c=relaxed/simple;
	bh=5onCAxE4OzeGwQmQtBGkRqGAfNCDcC86rdsdYDn/Ta4=;
	h=From:To:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=AOKMfKbanvril5AzEaHFDK8rpe4AM88BZByvgpMrkQZbG8Fqx8xpVOsDr5/RMDFtzHN03Awg4unuBsBH8F179aL7zGmvr0KPSci6m2SchZ3u4PvZQsoioEzsp6hkoP1T8fdp5w0Snt5ZP1V+Z+M3YSPgEijNxnV6BxNM4KU0cts=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=keba.com; spf=pass smtp.mailfrom=keba.com; dkim=pass (2048-bit key) header.d=keba.com header.i=@keba.com header.b=o03zutfO; arc=fail smtp.client-ip=40.107.6.108
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=keba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=keba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=keba.com header.i=@keba.com header.b="o03zutfO"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lYe533A0lTW7RhpchD0vAymJwb9q6IRz0Kmkhn+0X1SWbmO22Pqj0xR04ipVl8s7/zM6IvonrQL8quPvSihPRyfOyr4IeFOra4VPvnMvF/jL+ch25zpfzNrUCk4ZvMtQxJ3bSRlpQze1F9Br3iCGMl42XLjhii44ceV7VED1G8BApTfObnqWP/zzl+R1Rwyq0mJED7loV9+I9UTpFIt0UWbl2Z45Lr1lzmFbRvCkrZnakBiZ5BU2VdZY56jpvM8R+O7WkEBi2hhDpvF/w7Hn4QTfXMyFICiyUptb2BHqGacY6cqr6fmKDoc9ZNC4XGcI54mJpbiVge1yRsB9sK+sgA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=EaWjcnPuP/rJNbkAnJdA5rMJFkdeW7clF6kQl6++/2A=;
 b=ngXqqroZE+Ry26fK/Y5gaSgNQD43JmL4MJiWXss5Yw3ln5jxte1i7eXkNmsdJfhg2T8UrbwJ4DwahgvWXjXITLd2p9T4EJ/jNgAkV3/ddOpyP6ZcZ+nJyVhFAK0ERGY0M4707ANo6JzGQeTBB59Xhwm4yD0w/fzxvkStSNn55pns9KATmhuCTSgqY5vtGXExp628eJkJEy+hzvR1xLo+tw94wR6R+B2HhW2YejlqbA4CX039xvS+cNZkTUuWgtk2iqSQuCXRVHHemK9eYS1OxrxIrAWiSQS6Sf/C0ORHKE8CdDcmOwbblbrdkNCe4zLb5i9nO6CQYg32JnLwx9Gy5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=keba.com; dmarc=pass action=none header.from=keba.com;
 dkim=pass header.d=keba.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=keba.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EaWjcnPuP/rJNbkAnJdA5rMJFkdeW7clF6kQl6++/2A=;
 b=o03zutfOT/owJV+9Pyzr5poTpjCOcAeHrRsrtqpf+n7lddohfhXoPQiYseGDdJd6BsGZ11EcozfJKBUm5dYCc9NsBj0z12qhllBqL2JTMzHlSOYHgqzTH5in7QHip5IXHeWLtszsEUb+oZNgpfM+l7SKC6PBCn4TlvVCCEt16JO8gf/INZ9bqUZ5TDtDhFEtnShxCHDHxXXpI8aWUgiz8VIT+a/8S8Cm8WUoHDDKLtPAMiw4+jMf5POi4kZ08DunFYy2ql6PJZMN69UhWObVlsuLfEGwQhEWLDI2vLN82qzNSIW8A154Cja5KbKrAdEh9xnj+rnsHM0QE1Y5qWlsfw==
Received: from DUZPR07MB9841.eurprd07.prod.outlook.com (2603:10a6:10:4d8::7)
 by AM8PR07MB7409.eurprd07.prod.outlook.com (2603:10a6:20b:243::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7698.18; Wed, 19 Jun
 2024 07:48:21 +0000
Received: from DUZPR07MB9841.eurprd07.prod.outlook.com
 ([fe80::281d:a24f:a337:eddb]) by DUZPR07MB9841.eurprd07.prod.outlook.com
 ([fe80::281d:a24f:a337:eddb%6]) with mapi id 15.20.7698.014; Wed, 19 Jun 2024
 07:48:21 +0000
From: pda Pfeil Daniel <pda@keba.com>
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Subject: AW: [PATCH] conntrackd: helpers/rpc: Don't add expectation table
 entry for portmap port
Thread-Topic: [PATCH] conntrackd: helpers/rpc: Don't add expectation table
 entry for portmap port
Thread-Index: AdqXCOniFtq9Dyz6TEmv+uvqfOYRYwrETl/g
Date: Wed, 19 Jun 2024 07:48:21 +0000
Message-ID:
 <DUZPR07MB9841BE28079C9AFE304C3EBFCDCF2@DUZPR07MB9841.eurprd07.prod.outlook.com>
References:
 <DUZPR07MB9841A3D8BEF10EB04F33636BCD172@DUZPR07MB9841.eurprd07.prod.outlook.com>
In-Reply-To:
 <DUZPR07MB9841A3D8BEF10EB04F33636BCD172@DUZPR07MB9841.eurprd07.prod.outlook.com>
Accept-Language: de-AT, en-US
Content-Language: de-DE
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f7ce15f3-f9cf-4fe0-be64-c49742693951_ActionId=c7a1aaa0-e124-4718-a8fb-c24e3fa1d5fd;MSIP_Label_f7ce15f3-f9cf-4fe0-be64-c49742693951_ContentBits=0;MSIP_Label_f7ce15f3-f9cf-4fe0-be64-c49742693951_Enabled=true;MSIP_Label_f7ce15f3-f9cf-4fe0-be64-c49742693951_Method=Standard;MSIP_Label_f7ce15f3-f9cf-4fe0-be64-c49742693951_Name=Confidential;MSIP_Label_f7ce15f3-f9cf-4fe0-be64-c49742693951_SetDate=2024-04-25T12:05:10Z;MSIP_Label_f7ce15f3-f9cf-4fe0-be64-c49742693951_SiteId=83e2508b-c1e1-4014-8ab1-e34a653fca88;
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=keba.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DUZPR07MB9841:EE_|AM8PR07MB7409:EE_
x-ms-office365-filtering-correlation-id: 25ab9da4-f96f-4215-0d4b-08dc9034310c
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230037|366013|1800799021|376011|38070700015;
x-microsoft-antispam-message-info:
 =?iso-8859-1?Q?sQYRYgW+3AH5wn2mnHGNKTfEHsEFvkHMtYaaNnwKxI/n2mX43zYyx6MXjr?=
 =?iso-8859-1?Q?6yYs3+oeCYy90bz8F3HMA3xvRpffXH6vK/X/qnMGxqwGD6dfPTgQSmRjMO?=
 =?iso-8859-1?Q?UZCNjqYNQibJo6Rj83EMzyDH1q8EaVy+pJVqzuxuraLaehPUccSG6IHdj3?=
 =?iso-8859-1?Q?JFnDyXFAOz/3LO8YRhOuYf9NT4ZW/QK5p5ikM2s3l3VBeCSbKO69U7BKSJ?=
 =?iso-8859-1?Q?5HtEtasoIHYcOaEtTov7JXJ9bZmwHs5XwEUYK41in1BNjqsx1ZEPj56wdg?=
 =?iso-8859-1?Q?uyx+1hHWTKuOHs8u0YGURkUA3aKJWJlOXM/0N/t4bRw691sU7cNfVReyu8?=
 =?iso-8859-1?Q?/WhHB7hJN+7rGIxg4LC94GK0FarTx1c8DE8N9W9TaIJRFAr8q7O5U3ZbRG?=
 =?iso-8859-1?Q?LEsSMHpnKZAlnK2iYIVvzbFgu7ZxgkL1z0301hXDE8iMg5qgHHNeGGH+Wb?=
 =?iso-8859-1?Q?wkox1IwrjJePyA7FejoJD/EGOFvwIxOXJrP/tgKD162UweL1+pL0AymNrW?=
 =?iso-8859-1?Q?TGldoMRnEBnvInCYJRv5jDsqSzhufsrlFjCE9Z9suC98/WjLUgTMLhdEg5?=
 =?iso-8859-1?Q?+/JnX/KuNAzCWF/kxN8D062WUunqZ2qaV9ftpusyLqq3aLcKbI2LcS+IxY?=
 =?iso-8859-1?Q?1P7yz6rNBe73WOFtal3g3kHdtxfaFf15lZSmuKmVEECKfgG5pUVKcP8W/i?=
 =?iso-8859-1?Q?7FJPNlYSfDez/TsudhZyNnqPAPeASqPlkZbieuiXImhjOCdYwXes07Zjhb?=
 =?iso-8859-1?Q?HjTiYuW0IxUKdHY7powbamEcrlrwtjAvL1nFI8SC/m2tZLQDyGT6l3JSJL?=
 =?iso-8859-1?Q?6w/bIQ+2klvd4sceWrKI6iNJFxsHc/u4DepQ7oy+wCcq2EkoYe1ZC4kB1M?=
 =?iso-8859-1?Q?rWswhtoOjG4wzIKh9e14x/2RjJVEOVU9JFiG865NiOBQt79Hy2sgWTbBd+?=
 =?iso-8859-1?Q?sXdxpEDuVozxqEHmqD1ecPsXmaF7Wr//SCr/Ox7nXEw07u1iX0YF4WT4CE?=
 =?iso-8859-1?Q?rBnTZFNXfT3Mj3aq4vdF8AYvK+xTOy0kR+b1jWqqK385ojq3Jvnzmdqee8?=
 =?iso-8859-1?Q?XdMfuv5hp+YuhMG3PSvos6v61LVPEPiHfQc6JgdAzlA28/CJYA0vdDeA/2?=
 =?iso-8859-1?Q?GMc9q8itvjAZE05nGnTbE5/kOZj9q/HGdDMa0jXW1/PQpzMF76W7u/UANy?=
 =?iso-8859-1?Q?5SBPrmA1XmOZ1rm2lgkNbsc2T69Ivv2ftm4ItSLd8njyjjPQy3/jW0wqTh?=
 =?iso-8859-1?Q?q7ZG0z8u/LUCNeQXD8OI7cwUxRvbnivQ5KG0f1PkqIKpRZoED6YsT4dP4y?=
 =?iso-8859-1?Q?SwhtJa8fNNq08CGDnASQGzJGF6euoOnXgnKUmyHSjGK3ILViuZImxFA4v0?=
 =?iso-8859-1?Q?nhC4BoCMywKXgvPzVZEtX1U24r8lEiL8+qbXXLFDMRJQPlJxdp4xM=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DUZPR07MB9841.eurprd07.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230037)(366013)(1800799021)(376011)(38070700015);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?uEN8rG5z4cUUvtPv0pymp04jA4DVSFxtEIvXtelrChDz5XEQ6Xec6JlEZd?=
 =?iso-8859-1?Q?vuV5ubN2HSMbbYVNdVFOeQ5r6KjvWW6NaqhUPDteuZxdS0pGX7eXKt5Sk5?=
 =?iso-8859-1?Q?lBj2ujKUur3NPVyzkAsmv+qZRIt/XyLRo3sMbv64mWQLtQtu7InhD1D8Oc?=
 =?iso-8859-1?Q?2dZGRwPpczkEONxLpdhFDXRA6kzhCDzuKoHzsyf09bbotkWpRzEK6VLW+5?=
 =?iso-8859-1?Q?CVpndmT4coZwZKM4+YAsV0JzfbtRjig0y6NrfGMIhP5ix2mKrMG6FcVPTU?=
 =?iso-8859-1?Q?U0cZYHD6eClIrDBj1RfcN+Ta+yJYrQC7FudYzvsLhaFrpXrh9ME5e9K23+?=
 =?iso-8859-1?Q?araCWDjodChXJibahJEMWvay+ZS4IJHaIQpkY7BQF8UNFmZ8G31ToK/LPe?=
 =?iso-8859-1?Q?w+grNvvuqY0GA8jKVMC4W7NbWptyK2CwTia9suQvbncaUw8H2k5Nbfb0hW?=
 =?iso-8859-1?Q?1E+TjSB0Z+ZMTRmtm3wu86tB2iG+7DdfWYNFudnkAPguMiNDSYMQ75sXsG?=
 =?iso-8859-1?Q?pMiUcdIx5PIYBI7e0LqazvjGleUSvUcar/JMB2lLCF//QI1wJCT/uyHdzs?=
 =?iso-8859-1?Q?opJl28lvTlTRiCL+Cy0qNw5QN1xJqa4vwjcUeoVOyYVUmNN8UAx13FLojy?=
 =?iso-8859-1?Q?VCH17Dnsnf+U2hYeNPWFjv7bWX8xMgSVd3+gNP4WuwO4DSoJJjS2T6Rd/m?=
 =?iso-8859-1?Q?9sXKoysFWP0Y8OAS4ObBraB+7w0x1IIDMorkacW9EIbm3Mu+FPh72C1XQS?=
 =?iso-8859-1?Q?3vdEit8TgYUMFXAMH5e7DwK5qsL2HpI0kxonlB/4/5LoX5ir4HuYHAtUn7?=
 =?iso-8859-1?Q?QROoaHTuGBZjfkmY6pqTj8eDoBOg9fvO0MODeOd0OzUN6RG/2C7xzlUG0j?=
 =?iso-8859-1?Q?jRQM+B6qp+VggIQ+HPkbNHhSZO1S7Cm0M4GLQX6nW1MCJAwxUZJUBhPBvY?=
 =?iso-8859-1?Q?qSBz4/nh6NEerQ5Aa/ULhQwXE9Y3gC/kHUgihygzObIXpa0rovdR/Erw8h?=
 =?iso-8859-1?Q?Y/nNgDe5PXyVQL//39Kq+a1k/xTNPv9+pKEv63WZLAvrS1gkTw1x7haLpk?=
 =?iso-8859-1?Q?AUcwj/inxvNYa8NvbmgYCXXnnfK7r8dm2YsJx8iB7/hTvxSJztiP8545pw?=
 =?iso-8859-1?Q?F9JErL/9py8CKVX8p/gAjLF7beE3ZnNUXFE+4nUzBvuhd2hsBolZNv5TMQ?=
 =?iso-8859-1?Q?p73GQCyoy2j9cs2Yx9Gcc4sFBcB0arImrRtG6izQF91n66wjrFquKhPt/X?=
 =?iso-8859-1?Q?IwtoM6RwtwJ8NMejQ2AA92G6Oze9Vahead0R94J4FJ7ZSUv10fR5FZwkWi?=
 =?iso-8859-1?Q?obamu5XlLuPiYF9x7ovN8piSrXxiDGWAHJRdAgEN0hTwFpBgRkvVxhNVDq?=
 =?iso-8859-1?Q?bL42WBW0W5riWJoENakVLvv+F//L9iyW6wn2CcTaVXUbDSWD/WMt3ItJy0?=
 =?iso-8859-1?Q?G59XPZmYk+vW7Q0YJwJKeBiIpvQjZhUfwi7rYOJfW3EH8Sfjp8EfhMuwO3?=
 =?iso-8859-1?Q?gJ5Fb1nPyD1SpIy88ieQTBoCBW7rP37edd5Lw1t6/kdPYwfQi7MWILXJIA?=
 =?iso-8859-1?Q?vKur6Z86J3KvGD/iXcKMuT79B7zhQ3SWKgh2i0m/3j4zEIz6iKpvqk2C3+?=
 =?iso-8859-1?Q?RHdZ5At/kzbGA=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: keba.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DUZPR07MB9841.eurprd07.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25ab9da4-f96f-4215-0d4b-08dc9034310c
X-MS-Exchange-CrossTenant-originalarrivaltime: 19 Jun 2024 07:48:21.5121
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 83e2508b-c1e1-4014-8ab1-e34a653fca88
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 17qZQQZIOiX73hL6WR+qnbGz0QD6ofvHUHLgxFf6Y4MJJFsb+G4Zv5VWl3iaJ6kL
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM8PR07MB7409

Dear Netfilter Development Team,

I am following up on the patch I submitted almost two months ago (see below=
).
I would appreciate any updates on its review process or if any further acti=
on is required on my part to facilitate the review.

Best regards,

Daniel Pfeil
pda@keba.com

-----Urspr=FCngliche Nachricht-----
Von: pda Pfeil Daniel=20
Gesendet: Donnerstag, 25. April 2024 14:13
An: netfilter-devel@vger.kernel.org
Betreff: [PATCH] conntrackd: helpers/rpc: Don't add expectation table entry=
 for portmap port

After an RPC call to portmap using the portmap program number (100000), sub=
sequent RPC calls are not handled correctly by connection tracking.
This results in client connections to ports specified in RPC replies failin=
g to operate.

This issue arises because after an RPC call to portmap using the program nu=
mber 100000, conntrackd adds an expectation table entry for the portmap por=
t (typically 111). Due to this expectation table entry, subsequent RPC call=
 connections are treated as sibling connections. Due to kernel restrictions=
, the connection helper for sibling connections cannot be changed. This is =
enforced in the kernel's handling in "net/netfilter/nf_conntrack_netlink.c"=
, within the "ctnetlink_change_helper" function, after the comment:
/* don't change helper of sibling connections */.
Due to this kernel restriction, the private RPC data (struct rpc_info) sent=
 from conntrackd to kernel-space is discarded by the kernel.

To resolve this, the proposed change is to eliminate the creation of an exp=
ectation table entry for the portmap port. The portmap port has to be opene=
d via an iptables/nftables rule anyway, so adding an expectation table entr=
y for the portmap port is unnecessary.

Why do our existing clients make RPC calls using the portmap program number=
? They use these calls for cyclic keepalive messages to verify that the lin=
k between the client and server is operational.

Signed-Off-By: Daniel Pfeil <pda@keba.com>
---
 src/helpers/rpc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/src/helpers/rpc.c b/src/helpers/rpc.c index 732e9ba..d8e4903 1=
00644
--- a/src/helpers/rpc.c
+++ b/src/helpers/rpc.c
@@ -399,6 +399,11 @@ rpc_helper_cb(struct pkt_buff *pkt, uint32_t protoff,
 				 xid, rpc_info->xid);
 			goto out;
 		}
+		/* Ignore portmap program number */
+		if (rpc_info->pm_prog =3D=3D PMAPPROG) {
+			pr_debug("RPC REPL: ignore portmap program number %lu\n", PMAPPROG);
+			goto out;
+		}
 		if (rpc_reply(data, offset, datalen, rpc_info, &port_ptr) < 0)
 			goto out;
=20
--
2.30.2
