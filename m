Received: from EUR04-HE1-obe.outbound.protection.outlook.com (mail-he1eur04on2101.outbound.protection.outlook.com [40.107.7.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B45157E72
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Jan 2024 21:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=40.107.7.101
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706562780; cv=fail; b=msjSoXxFJDJn8deeI8kiphGlWUOEErxEc3oFej15OjTJl1x5AZVkDfqKbpXMuHWPpvWZYvklw/YDtKJAqV5M/ZVPNCBoc+2SC4XK0qrqhsQFQetn5A21nAv9yESu9HPG7v0PbZKgp4v+dXH4T77rzMY8B6hL1jU/sWqiBn2O+3E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706562780; c=relaxed/simple;
	bh=M0PSzfUN9jt3l7VYGlfmd2jd+nkVlC24COQ7zQGhnNg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=PPO00mJulJwFKHjX+Iwi6qUSayJWpMp+3uam/Fsi3w+36dXK9jCU4qjomWYJUeVdAmj7BFtJqu/AyOYGUvIgtfUBJiUrYZy7HF/PUtq5eh8AadDdi84I7bFIlAWKg3OZJ18Qv4+OsGMgTZMYR8oKvWPJcYWB7uQG1aRsIJWIrJ4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=est.tech; spf=pass smtp.mailfrom=est.tech; dkim=pass (1024-bit key) header.d=est.tech header.i=@est.tech header.b=R/BapLVr; arc=fail smtp.client-ip=40.107.7.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=est.tech
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=est.tech
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=est.tech header.i=@est.tech header.b="R/BapLVr"
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TQVsCfsR5wrP7zFTpNrD1nfMbxO9YCWZhBUluM5VBkIJvGNe06GTr6xHlk+860eyUIkhSjz9g9tcvaz/l1g4JJtnkiG+EfI7OE9VEw+UdnoTShIjpDb6GadZK8bwWjpa9L+bluQHrGULEMyrkC/MauElP+hmuEjjNXgkOcCht7XaN+my1zY+wnG7RxnqBp7dJVBhssxtQD8QYr4dU3JMWON9ivR7g3VqJstwbErtN3AOXty9Zt4ONzbRJoFMyAkVERTljm/h7bIHAbIGfDL92Q10mih15GK2KkaY3oWG6WnkZS3DOzxEZdKUOTy6aZDuImka0fHcTvsKKD35ccWd4A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kOmOHEjQFDcnG2ZHt75QZgvj5+hlzYZ53uaSwUEbrjw=;
 b=TxBziUIqjGCZp/vz0WB0eTwyTd5nXuWqdJA373LgFJR5vvO39VALgbyQA80pTDUklxuCbptyXvRYeeKPe2Wxvg8DU/fLP7qXz/OAuvuG2FpxQZsXbrRNum4PzOBD34O4DUrWbHqoB2i2ccgMRzAs9eoxUNYwYMkFxcWmEBR/XjHKio9nehl3zs2lUrU13Cyuax8sMchac4gcTQb0Kd5qMh2OFMF1XOtz/9meIPgDWGgmMDEvN0HVdHvRgNJeqbAIJNlvQGqdjmn/xbJkpXm5yDPGjcaObWjMdoS7y6mVN45yNMbBHPcy5W0qGCLNwgpAz2nvhM6vr5H5thGH/bjHuA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=est.tech; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kOmOHEjQFDcnG2ZHt75QZgvj5+hlzYZ53uaSwUEbrjw=;
 b=R/BapLVrxJQaN+4Q0yUs7OHR8am6t8Yxhob5yqBKHopWdgfra/zTNleuOU1aXGlwE7WBjzWYTWMxlTuLIZSI9nnOGNtWjgqfB5RqiB4QBIoNdf7flBN60PZAR8c0hINt0ezukX6S/8T0FgkWo7ArfT/2geBYHonNOM6pjOwfR6s=
Received: from AM7P189MB0807.EURP189.PROD.OUTLOOK.COM (2603:10a6:20b:115::19)
 by DB9P189MB1836.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:326::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.34; Mon, 29 Jan
 2024 21:12:55 +0000
Received: from AM7P189MB0807.EURP189.PROD.OUTLOOK.COM
 ([fe80::bad7:18c9:a3cd:6853]) by AM7P189MB0807.EURP189.PROD.OUTLOOK.COM
 ([fe80::bad7:18c9:a3cd:6853%3]) with mapi id 15.20.7228.029; Mon, 29 Jan 2024
 21:12:54 +0000
From: Kyle Swenson <kyle.swenson@est.tech>
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
CC: Kyle Swenson <kyle.swenson@est.tech>, "fw@strlen.de" <fw@strlen.de>
Subject: [RFC PATCH v2 1/1] netfilter: nat: restore default DNAT behavior
Thread-Topic: [RFC PATCH v2 1/1] netfilter: nat: restore default DNAT behavior
Thread-Index: AQHaUvftg+tGtMHYiUuGvcNG+Tz3NQ==
Date: Mon, 29 Jan 2024 21:12:54 +0000
Message-ID: <20240129211227.815253-2-kyle.swenson@est.tech>
References: <20240129211227.815253-1-kyle.swenson@est.tech>
In-Reply-To: <20240129211227.815253-1-kyle.swenson@est.tech>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM7P189MB0807:EE_|DB9P189MB1836:EE_
x-ms-office365-filtering-correlation-id: f8b923ec-1c55-48bf-f655-08dc210f0f97
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info:
 01uGk/GhcWoQ+KuM9McMhwihSRZmzqWYG3yAmwxqNtmKmDmm6yLThpoXaf++GKFp+C9qCQknIJITtVaNBYT17tqVf+UNrlmXJh4LrZqdhzu0OxC91oJD1xqZXmax9wIFX6m2E9eXsVUpI3XlbihzIlVfLBZk4jryBixk3EKz7mqZDQZPiszNJGUhNFJy+28y4Njl+dRVznsQvGvTGo0MFyIeznr5PvmjqhrFYYNInO8GgBb/pLgYJdel5MVMs+wZhURvO9fu0o5Q9bqQrsfFGo9w19Zxb63he/K5x1g6nWaf7dPlfe5DRE3JTCf4NxLM0Z3mlmAebeQYUuRRidzz6fQJ5ZMrQNWfyjITzlrRRdZa58BHoRDpdRR9Oi/p2jOgBLAmPyfIZMYk5AsnA8QFq6jmoBc2OhyM51AY/hu3DSZSV4CbN+CLmSet38J9BhR/gD7fjPEUIbsXfs4bueoZZnfrIEu8yIUv3QCmcRbeOeeb88FVQ+6FelcPtnxGh0bqKdL18iTsnliUP8qhJ1ty3tFy0N1Z6OLGTywZ7AR0JZ/pWnEHcvfc6VN0Vyl9gj8buIjqHaUrKkAy/FgqEtwcErNzgkYIPwri8afU9f23Dvr86S6jOFyGN4QnX75nsMdg
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM7P189MB0807.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230031)(396003)(39840400004)(366004)(136003)(346002)(376002)(230922051799003)(451199024)(186009)(64100799003)(1800799012)(38100700002)(2906002)(44832011)(5660300002)(122000001)(38070700009)(41300700001)(36756003)(86362001)(6486002)(26005)(478600001)(6512007)(6506007)(1076003)(2616005)(71200400001)(8936002)(8676002)(4326008)(83380400001)(66946007)(66556008)(66476007)(66446008)(64756008)(54906003)(6916009)(316002)(76116006)(91956017);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?w/HAI+gzGTNRmXpWZ9fe4biqssi7pcIQdeoee4vgOznIrHe0khb0zWWQma?=
 =?iso-8859-1?Q?squgO2069sbmKRyJQG9iPcI8TnhWLdgHBM8ExfRepP2CgkktGX3E3aWnhP?=
 =?iso-8859-1?Q?BWdiITTsYxJ18LQ079DGKAd8r0GLO7B+jAWQl5dPGWPD4q3e2GvUlz5Yk/?=
 =?iso-8859-1?Q?U0vo5Vp3acx4FMcAEspM6Df4pzJ9m72p9ey53smc5SAxlUXV9i5gOvroxn?=
 =?iso-8859-1?Q?hSWR0q5E114Qk5oh1fRpOH+8oT6tCkQXttmiS8dS7NmQtD4Hl5lrjOu/Vs?=
 =?iso-8859-1?Q?c5OQRb41dMC60awrNIgclA3LbxDlAx6NU0YGCLQ+KwQJ4fsDXS+GJ0/Tdg?=
 =?iso-8859-1?Q?kZnq0Sra847q96BrPeSkYu4YehSfhmnWxLeA10PTKDAUTzeo3WjAukh1DC?=
 =?iso-8859-1?Q?gPeqBj0Fnv76kaSwr+Py8n2sVNid592sSYbPidlvwG3n+FPne9501C2cbt?=
 =?iso-8859-1?Q?RBPIS4UM1ACckehDEO9OuyknYiPe+/O1nMz5xK4oQppGLIhboCWZ4BgF1g?=
 =?iso-8859-1?Q?rZPEFOwPoluMJC2gUN3SqHSQj3v9wYBk7fa2flwkzN2nYGorA8I+os22M/?=
 =?iso-8859-1?Q?3AQfcjFkBIQWCtqAPnPa3YnkSpw5renRbKklLYYM5mDCpw3NXgBZwiZL4t?=
 =?iso-8859-1?Q?dzmOJGST7GWcAEG0jdreB/oRgdKWg5vSRhih4eY6nCqvGXurjiwDa0szXR?=
 =?iso-8859-1?Q?WGUY8QheEJZq9VCYM2m+I3fW0uObWWLKetb450nKF08EG4J1Z/RgGtyXhT?=
 =?iso-8859-1?Q?xAZx9PCzU6xSHqS3m7N0ehTQ4bII716J1A5sz4SmMIwDKi2VNN/5C6GSAR?=
 =?iso-8859-1?Q?kQ/G9XaxLAkTSuHGl7KpPQC2uumVHSaxYi6rQdF/3OujzHjEonliok8g03?=
 =?iso-8859-1?Q?98scF0c99IIh+vHPUuCURi1vC7Qug9Raz1Ko1sohVLY8gVRBQJrBcU+FA4?=
 =?iso-8859-1?Q?GvkjVpbsvbvBCPgSCz2te4mm6o/NJdWa7Mz6brwoEnr+Z7dQtwVHqkpjgZ?=
 =?iso-8859-1?Q?i5M4u4duRX34UYCBrcIH7kKMVyAJTF91RPM6ZL3aqHKQ2mlu4zaPe9dpG2?=
 =?iso-8859-1?Q?0OekgjhySoDFFv5NIPuULhFPDglZHm59yRb8WYsf27ZFjhhfLI6djLc01Y?=
 =?iso-8859-1?Q?r8veARkVDqTD9wU0bCCIPC1CouhBiCrlvg3wN/H8U5a/tBUEITyZICp1Ft?=
 =?iso-8859-1?Q?sElknX+/mWVQqq8ydbs/ND+UQNq0yTSctDcIIYJMfcJPHiC7jS+7y9nnIB?=
 =?iso-8859-1?Q?ZNrP+B9fBX0RIXBHX3hOvbWuGkV0mSbKEL4xYaxQtxbOszRTuC/GzF8mTt?=
 =?iso-8859-1?Q?zGXO9Igl0652TqqsVpS2HmpwtD+qCbYjwf0x1Lznf8yOAuze85e+FTSDBn?=
 =?iso-8859-1?Q?qW65XkpBMjD1myWVWBPZrxYRCAwSBXKb3Y65cRPohnNgfadLF0KfYrTwCs?=
 =?iso-8859-1?Q?EgMy6yEDW9ovCLslvnDvsLU45D7NWan6NMm4i/xq2o4l5xJSyUtyy11ZGn?=
 =?iso-8859-1?Q?WQMNpFBx3060dLGCQ97DSNTr6kZvRnrTQ3ylkULvthQVjwrikKzNujswTZ?=
 =?iso-8859-1?Q?ibv9B/xcIRjhUVcMxCNXSvlnExjlN6wevpMu8h3Ix7kP454ueN6G30jiRj?=
 =?iso-8859-1?Q?YwYd5ewRyAj7JvXxFd82h4cBJuwfC6kR4DC+ZD+Qouh0bHbbzdx8W2iQ?=
 =?iso-8859-1?Q?=3D=3D?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM7P189MB0807.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: f8b923ec-1c55-48bf-f655-08dc210f0f97
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jan 2024 21:12:54.9437
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: bvNAZ5feMKDf2mWeaDmhzDRutT5n4EBKcTAlg+L9HvZRkeiNHfUizjbn55K5hyswcEwIg03JImdX9tkvrBFzPA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB9P189MB1836

When a DNAT rule is configured via iptables with different port ranges,

iptables -t nat -A PREROUTING -p tcp -d 10.0.0.2 -m tcp --dport 32000:32010
-j DNAT --to-destination 192.168.0.10:21000-21010

we seem to be DNATing to some random port on the LAN side. While this is
expected if --random is passed to the iptables command, it is not
expected without passing --random.  The expected behavior (and the
observed behavior in v4.4) is the traffic will be DNAT'd to
192.168.0.10:21000 unless there is a tuple collision with that
destination.  In that case, we expect the traffic to be instead DNAT'd
to 192.168.0.10:21001, so on so forth until the end of the range.

This patch is a naive attempt to restore the behavior seen in v4.4.  I'm
hopeful folks will point out problems and regressions this could cause
elsewhere, since I've little experience in the net tree.

Signed-off-by: Kyle Swenson <kyle.swenson@est.tech>
---
 net/netfilter/nf_nat_core.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/netfilter/nf_nat_core.c b/net/netfilter/nf_nat_core.c
index c3d7ecbc777c..016c816d91cb 100644
--- a/net/netfilter/nf_nat_core.c
+++ b/net/netfilter/nf_nat_core.c
@@ -549,12 +549,15 @@ static void nf_nat_l4proto_unique_tuple(struct nf_con=
ntrack_tuple *tuple,
 	}
=20
 find_free_id:
 	if (range->flags & NF_NAT_RANGE_PROTO_OFFSET)
 		off =3D (ntohs(*keyptr) - ntohs(range->base_proto.all));
-	else
+	else if ((range->flags & NF_NAT_RANGE_PROTO_RANDOM_ALL) ||
+		 maniptype !=3D NF_NAT_MANIP_DST)
 		off =3D get_random_u16();
+	else
+		off =3D 0;
=20
 	attempts =3D range_size;
 	if (attempts > NF_NAT_MAX_ATTEMPTS)
 		attempts =3D NF_NAT_MAX_ATTEMPTS;
=20
--=20
2.43.0
