Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.72.142
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793786888;
	b=gV2KFOulLqcHQTceayyzueOQWFqDDSUkQWgtK51XbwSMkvtIZ0slBdJv+7Tm705mtvIr
	 8wuGNBSI9yDjsLu4R73ewspJN3WBJ1DfPCK2UXRzaiqAloE/cDGL91VVG8PECbP93fwKQ
	 a5riFTSN9BF2s7mAVJXBeCp8zU65wWsg2bJUF/rZAFEplOPbXNBbNswAUY1EYPdQor+go
	 2a3/8RWWNRn3KvuwbbsL7zsyuSQWJ1zoZkj23lKHmi7+kN7i1cc8HdDHLU3r5g8zCvm4c
	 0+fErU6ipL/O23UiQGQumhm9CBDesg/rgipbgOp53CzBXRvTdlCFeYY9rGNIPsTsUFQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793786888;
	h=DMARC-Filter:DKIM-Signature:Received:Received:From:To:CC:Subject:
	 Thread-Topic:Thread-Index:Date:Message-ID:Accept-Language:
	 Content-Language:X-MS-Has-Attach:X-MS-TNEF-Correlator:msip_labels:
	 x-ms-publictraffictype:x-ms-traffictypediagnostic:
	 x-ms-office365-filtering-correlation-id:x-ms-exchange-senderadcheck:
	 x-ms-exchange-antispam-relay:x-microsoft-antispam:
	 x-microsoft-antispam-message-info:x-forefront-antispam-report:
	 x-ms-exchange-antispam-messagedata-chunkcount:
	 x-ms-exchange-antispam-messagedata-0:Content-Type:
	 Content-Transfer-Encoding:MIME-Version:X-OriginatorOrg:
	 X-MS-Exchange-CrossTenant-AuthAs:X-MS-Exchange-CrossTenant-AuthSource:
	 X-MS-Exchange-CrossTenant-Network-Message-Id:
	 X-MS-Exchange-CrossTenant-originalarrivaltime:
	 X-MS-Exchange-CrossTenant-fromentityheader:
	 X-MS-Exchange-CrossTenant-id:X-MS-Exchange-CrossTenant-mailboxtype:
	 X-MS-Exchange-CrossTenant-userprincipalname:
	 X-MS-Exchange-Transport-CrossTenantHeadersStamped;
	bh=QiDgIbzpuYMZlP/7hzf0UgbFYIHzzGIe7Y0gGz/e8CU=;
	b=0aksV9PH3zFFUGLnVpGCxkRX0NedI6W9f1NpSeBvXrXexrfz8acn2+BTxLocBV6zjOw9
	 mZ69tJuf6a+k/oy9t22IUDO+2wocJxeB1x/7fvmiEc6ZlqbJeT2gOPmWf4i/r50edsy8G
	 R2ToJFPuL5/BkCG05Q+ONGEV5jNhsSd6SlJ1Vywnf0N5q+Iu8ys9z8zNXHPVtlIxD2B9/
	 Dv+wZkXu1myDP9cW8w3gKIPersr1GMvGBLQgvFuAnoyF0jychsGrJYFNGmTSBFN15iWnx
	 V27eYSPa80YPczXz+puHj9F92dVXzP1nCD+R7fDh0cd52pegfT58iWQnQy6fgLEUd0g==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=earthlink.iq;
	spf=pass smtp.mailfrom=earthlink.iq;
	arc=pass header.oldest-pass=0 smtp.remote-ip=52.101.72.142
Received: from AM0PR02CU008.outbound.protection.outlook.com (mail-westeuropeazon11023142.outbound.protection.outlook.com [52.101.72.142])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (secp384r1) server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34518606D807;
	Wed,  4 Nov 2026 10:07:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 34518606D807
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=earthlink.iq
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=earthlink.iq
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=MEPWrhwyIa8CroQwWa3sHXlhcHW/5m1pe+LrtRWpzhRg4GVoA5/bi4iuW4eMLXrVVPTojeTOmHrCFLU/e9ObIPuQowgmsWP0PEYNVQ7PXo+AzyYvs5YcFHQgFP+OUXirE9Rae8g4GPUafnSJFyehsLvrHMz1jTlr8+V0dHH5NATGiLnG6lQh8ZBBwf98lqNqN+vXu2I75Nc9wYJ14WdmOF+/HA4WOWHKJCi/SPFQ7aPUvMIpdUk68hLMa8Jjv/e7gSpz2E64jN/kZ5YlZJGF2KUWZ7RRF/Slkj9Na9k/NMp2gXSvX1vf41+gyBZpoUd9rdXUuplluVYOO1Zk4tRYHQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QiDgIbzpuYMZlP/7hzf0UgbFYIHzzGIe7Y0gGz/e8CU=;
 b=Vd5lkIVlICMOLpmgwV0brwGjnrXFK8scYZRngF8TOmF5/nZI6lQjVB+MIN5t22MUMrKD2t1uZy8ewjAhnWCnwy3H/HTZPfsQK5o18hrX9bzLuvX0kENisLpJRoP/isWvK26pfOjPzKbqnxEOuYHVSVWBwo1A42VKTVttjNz9DEviOXfUbROWewJaLDFAmocmwt9EYglBZa8oCaDZ0iR5034JKJKZ4V050jpeYj5tka5MH6MDgWPusOAUOH2pxqG3lQyrbs/ta61YgTQ/OhO7vDJwa9BoCd/0YCQ8y3vYjPKgN21hkemydHTpxCP+Fn4RZiAtI1XNrkAm6M9AGUflCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=earthlink.iq; dmarc=pass action=none header.from=earthlink.iq;
 dkim=pass header.d=earthlink.iq; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=earthlink.iq;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QiDgIbzpuYMZlP/7hzf0UgbFYIHzzGIe7Y0gGz/e8CU=;
 b=LO4bB/RMG7ivkeg7p1foWxxjz8YACrFekfqPACDnYOlyiXJwn4rW3wNfaToVNhTvxukem20ahYFL3q81PVNnbSRKstVB6PKw4uOKAkARb+/adesTj48F8Trn2gv1B/NWGLqV4zj3+tjdkYUgLamcCFxPVr1by8EWj1LMNIOdPfxiKMVCs3+BkRO7/HaOZhK16XQnNelyn3Kph2CLZs5UDt0/B+pvDS0lPMQVF7KZv39bAwxlB14NCLoppaaV4cLUZ/HG9Ze1xkf3U1FTaw3xQJ3LKvZ5cjiIHWMFWGtbSUkbvs1ZW9ogwvSMp3FIoJf/Kd2XfizMXQEZQFvY1JtWIQ==
Received: from AM0PR02MB4307.eurprd02.prod.outlook.com (2603:10a6:208:d9::10)
 by DU7PPFFB10D2437.eurprd02.prod.outlook.com (2603:10a6:18:3::ce6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.569.12; Wed, 4 Nov
 2026 10:07:51 +0000
Received: from AM0PR02MB4307.eurprd02.prod.outlook.com
 ([fe80::c392:dbc8:75f1:ef9c]) by AM0PR02MB4307.eurprd02.prod.outlook.com
 ([fe80::c392:dbc8:75f1:ef9c%6]) with mapi id 15.21.0592.007; Wed, 4 Nov 2026
 10:07:51 +0000
From: Muhammad Zuhayr al-Tayyar <mzuhayr@earthlink.iq>
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
CC: Pablo Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>,
	Phil Sutter <phil@nwl.cc>, "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: [BUG] netfilter: nf_tables: hw-offloaded flowtable entries leak when
 the flowtable is deleted (UNBIND at commit, DESTROY at release)
Thread-Topic: [BUG] netfilter: nf_tables: hw-offloaded flowtable entries leak
 when the flowtable is deleted (UNBIND at commit, DESTROY at release)
Thread-Index: AQHdbEFdgTlNXliYIkuhn85U9AZXpw==
Date: Wed, 4 Nov 2026 10:07:51 +0000
Message-ID:
 <AM0PR02MB4307BD45EE715C8B94EE3E6AC6682@AM0PR02MB4307.eurprd02.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
authentication-results: mx.microsoft.com 1; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=earthlink.iq;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: AM0PR02MB4307:EE_|DU7PPFFB10D2437:EE_
x-ms-office365-filtering-correlation-id: 60f230f3-8523-4a91-06ea-08df3a5b7c59
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|376014|23010399003|1800799024|366016|261009223027099003|38070700021|261021123027099003|261021121427099003|260925022911599003|260925021911599003|260925021311599003|261021135927099003|56012099006|261028144727099003|261022105027099003|261022075727099003|261026121527099003|261026140227099003|10067099003|18002099003|261102123227099003|6133799003|3023799007;
x-microsoft-antispam-message-info:
 kAK/48VSR5tiCnM0XQY4mIgly+qs9kboJL+q56Y5SXymogdKoAYWXtOxESVIgiXqLW3DaW7PRJkXaazX57FvMXtzvWZF/4VtSVVdSGEgNWD4hpwyPPnTzioVWLL08qOXRUg4aCuJfs7WI6Ij6BkOAkr9gkztWDUFgh3T9sKk+ewAcHMKq5Ifzu5Nc/SIe/Q8nR+T40Wveij9HdJxVvPmsIxD9atvRkGqX96+89vLupTeNn2D96tPPl4Q/qYAEWB1snSrHKUyPvE9XENROBFs7upPG+t859OQyrEty2eWDWbRnEOuS7rOj6gs29lLBtwNEk0IXAaRqca7kDdJC6IlAoloZQYns5mBcgIiGpt3rcCUgHLajmNrOt10TpIxL3HkJ6jPcNk7/eBMsBtbrI2453sQtmTUn5cFhKzsAOmFdrnzzFCBOX5Rlaa0PX9sD8h/AQDIprgpMJAzeikc6nzL6HyDq+Mh0/PugwV9WW72c6m7cm6s7Soux30v+fHZglQsAgldvEMEaT50tsV68BDwY+0t3xk9EpaMUsX0wYGyRXMC3oNarn8BMoLzlyHZFWzoXTu044MaEnNwRzmdgMKSZ2GMhP2IxrFMxB3D4BI09wuo0HaAGYKqVzR5DHq4ney8jmtFbmjmSDMFS6MaeTxCOm/8Lj4i+EWEBNBDqBuw6RiAg5yQzJi6kE+kt2LxZW8AY5b3WarY58p3Fux79p9x7m57thOmD7wlbAVLmNAe/nE=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR02MB4307.eurprd02.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(23010399003)(1800799024)(366016)(261009223027099003)(38070700021)(261021123027099003)(261021121427099003)(260925022911599003)(260925021911599003)(260925021311599003)(261021135927099003)(56012099006)(261028144727099003)(261022105027099003)(261022075727099003)(261026121527099003)(261026140227099003)(10067099003)(18002099003)(261102123227099003)(6133799003)(3023799007);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?iso-8859-1?Q?niUqBba0LSpeq/2Zncj5V3LRgHuEIC1mb0pVTphXKQB2jmTacQczXki18V?=
 =?iso-8859-1?Q?69Sja50t1XOIt8NQI6jXaUQN/LiWJ1620+y01MNMhCsjItGoKMXKi+ZtMB?=
 =?iso-8859-1?Q?+r6u96ELzzHVsLZFhWu6dvuC20m2BTziBNc2S3NYI3fOUi/9glJeHn+lEB?=
 =?iso-8859-1?Q?fJyMF+do/S+DkTpe6Vm7/fy1z+2tk9SuQbxCL+TBKBTdXh3bvX+4Q6FmZh?=
 =?iso-8859-1?Q?cYffwsfoRXXH0eHiUFAvpLD/sLkL9hWO9k+KlNTIlh52Xxg4CPhOvyjZhB?=
 =?iso-8859-1?Q?bnr4lWpmnl6ygSU7RMNXlNdIL6OpYgqpLny0/Oof8Bh1/NqM+QfVBLJKKH?=
 =?iso-8859-1?Q?98L0QBJtUlJc/fxrHQUbEcLJ8i05Ar69fAMTWh9vVJJbUgNtmC5KGbthBn?=
 =?iso-8859-1?Q?CGfvhmSq4+0efkKBuRFD5oEfEQmiu1cpfiIi8eyioTU468Q5SAaiRYH/Gb?=
 =?iso-8859-1?Q?mDNdxgIFLu3dSEmaCzIYYuElJOTyMAtewKlZTfwPcoVlOqWnBJXKeHelCb?=
 =?iso-8859-1?Q?xcD83xyP4ZTF7kJ4VLRjm13LK4Droyq+wK19gmrUi6oKDvkks5KD7GTTnZ?=
 =?iso-8859-1?Q?D7PLrdadYd6hmY/rCxXuml64am+8XZGpZxy3Wxu0Kg0yibMZZsMqjKXfzM?=
 =?iso-8859-1?Q?IXdPE065Si0oT9aiTbLzaoXpr8FG3aghjrFNfi2//jMHzNfWRce3To6Y0C?=
 =?iso-8859-1?Q?ilEhv7VYzS4b/j/PrLHJVNWfKjh/B3DztaoRuuQBa2VX/o2VI1qtXborHX?=
 =?iso-8859-1?Q?FonMchwmzUlI5EJ28yOjuf6kTdZJHDa8tg/QSJY9nplsuubbIXPeXhZIcb?=
 =?iso-8859-1?Q?5DgObKjsw8KfztT+vA+FF6x3bkEfLs1E3Rga+YfXjPSk+ym5vWcgyGHnOy?=
 =?iso-8859-1?Q?Md8aXhatSNgIQ+yKnuG6Tl9At9F3kiD6oPAw+mNSb/XeHjSdE3S5jCUKBm?=
 =?iso-8859-1?Q?4ladh9iKvVUD4Z5EKq6jsBmRrXDkksLuk7NgLwVHWTYf0kTG7MfJWC8+M+?=
 =?iso-8859-1?Q?OUrA71xgyV+YZz80fqEl9RGViv9I/NlrSg7xwlVHFg9WpRjcFstv04ytpu?=
 =?iso-8859-1?Q?uyFiVq3NRgm1pzMi2RKZCKBG1LbbIGngf9K+zB5phFNmS8pMYCFv0VhaFY?=
 =?iso-8859-1?Q?pMfzZ4V45zgUr7XpJSSuVWR6xebigh4zgwLK/H/3okjU+dOi6NANKHIfxr?=
 =?iso-8859-1?Q?JweJhWlPdwtnkPfqCWc84efMSl3ysgb/Yt9EPZSg7gZsOVaqNEhNauP10J?=
 =?iso-8859-1?Q?UbPq3kW0LDLYNnAwsePfIyQG/ofDBKI0czYnTuweI7nkNESWzh7QYGid7M?=
 =?iso-8859-1?Q?C/F9OStcs0GrfKcLDjoiaXoZnLQH0kWrPbiFIqjdAerax1LR6lMYyHbRJw?=
 =?iso-8859-1?Q?7TLNDcCDbpigk2bXBp6tZSL+shk3oo72ETW9DJrI4ybpQSFx1CRDoMFTds?=
 =?iso-8859-1?Q?PilmmTzK6AWAoG2CgC2co1TG4rf8M0ck5BNpGltwU0WGItrdc81ZR3QZXJ?=
 =?iso-8859-1?Q?vfy2MosmbVOkPzjw1bAj2TC+DEEhdfcii79eIyqp/gnEm24X+73UYzmYtt?=
 =?iso-8859-1?Q?JnLzk3rFxtCh5CaawZTHsIGV2+jq74sHDWSW2XuSSQnOmB4bSIxAN6fHcZ?=
 =?iso-8859-1?Q?geCJMYlyIfihu4VVf7OzVrg9cjzcZFQywTM10cWAXMC5+dTH+n5i5YKhar?=
 =?iso-8859-1?Q?yDJkyzPn5km/yrhRgwHqJ3NVKSc2DYIjN0TMpzlCczDJ7cuxf9C7hwR1JK?=
 =?iso-8859-1?Q?RyV64lwMrGPiIkGDt7dY97as4om8TqdyB2DLfl5XN4z3aQ?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Post: <mailto:netfilter-devel@vger.kernel.org>
List-Help: <mailto:netfilter-devel+help@vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
List-Owner: <mailto:netfilter-devel+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
X-OriginatorOrg: earthlink.iq
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: AM0PR02MB4307.eurprd02.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 60f230f3-8523-4a91-06ea-08df3a5b7c59
X-MS-Exchange-CrossTenant-originalarrivaltime: 04 Nov 2026 10:07:51.2468
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 89d949e4-9c48-4c58-9092-cf9b53301a04
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: +PS/GPZMBusJJMULJDpTGN7GbVcaGgKcIkC2h8lF0gIYypzdlQ2A9/DFc4c/6NqIoy5Puv6G0r42es3aNun0Yg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU7PPFFB10D2437

Hi,=0A=
 =0A=
When a flowtable with "flags offload" is deleted (nft flush ruleset,=0A=
deleting the table/flowtable, or loading a ruleset that starts with=0A=
"flush ruleset"), the hardware entries of connections that are offloaded=0A=
at that moment are never removed from the NIC. The NIC keeps forwarding=0A=
those connections with no ruleset loaded. For a firewall this means that=0A=
replacing or removing the ruleset does not stop already offloaded=0A=
connections.=0A=
=0A=
Environment=0A=
-----------=0A=
- NIC:     NVIDIA ConnectX-6 Dx, in-tree mlx5_core, firmware 22.36.1010=0A=
           (DEL0000000027), eswitch switchdev, flow_steering_mode smfs=0A=
- Kernel:  AlmaLinux 10.2, 6.12.0-211.69.1.el10_2.x86_64 (distribution=0A=
           kernel with backports; behaves like current mainline here)=0A=
- nft:     flowtable "flags offload" on two VLAN subinterfaces of the=0A=
           uplink (indirect block, mlx5e_rep_indr_setup_ft_cb); traffic=0A=
           routed between the two VLANs=0A=
- Note:    on mlx5 a separate driver bug keeps flowtable rules from being=
=0A=
           hit until a chain-0 tc rule with prio >=3D 2 exists (reported=0A=
           separately to netdev). For this test I added and removed such a=
=0A=
           rule first:=0A=
             tc qdisc add dev <uplink> ingress=0A=
             tc filter add dev <uplink> ingress protocol ip prio 2 flower \=
=0A=
                 skip_sw dst_ip 192.0.2.254 action drop=0A=
             tc qdisc del dev <uplink> ingress=0A=
=0A=
Symptom=0A=
-------=0A=
With a TCP transfer offloaded ([HW_OFFLOAD], uplink rx_packets ~20 pps vs=
=0A=
rx_packets_phy ~19k pps), I ran "nft flush ruleset". Afterwards:=0A=
- the transfer continues and is still hardware-forwarded (rx_packets=0A=
  ~20 pps, rx_packets_phy ~19k pps), with NO ruleset loaded;=0A=
- the conntrack entry shows [ASSURED] (no longer offloaded), its counters=
=0A=
  are frozen and its timeout only counts down, because no packet of the=0A=
  connection reaches the kernel;=0A=
- "devlink dev eswitch set pci/<BDF> mode legacy" fails with=0A=
  "Can't change mode, E-Switch is busy" (mlx5 still counts the leaked=0A=
  rules in esw->user_count);=0A=
- the entries stay until reboot. After "devlink dev reload ... action=0A=
  driver_reinit" the rules are gone from the NIC, but the eswitch still=0A=
  refuses mode changes ("busy") until a reboot;=0A=
- the mlx5 SW steering dump (/sys/kernel/debug/mlx5/<BDF>/steering/fdb/)=0A=
  still shows the two flow rules of the connection after the flush.=0A=
=0A=
  Dump taken after "nft flush ruleset" (nft list ruleset is empty),=0A=
  decoded with a small local script:=0A=
    192.168.1.10:22 -> 192.168.2.10:41234 tcp  pop-vlan, set-dmac,=0A=
        set-smac, counter, -> FW table 0xf (VLAN push + out)=0A=
    192.168.2.10:41234 -> 192.168.1.10:22 tcp  pop-vlan, set-dmac,=0A=
        set-smac, counter, -> FW table 0x10 (VLAN push + out)=0A=
  Raw rule entries (match on 192.168.1.10/192.168.2.10, ports 22/41234,=0A=
  tcp):=0A=
    3303,0xf000004c,0x6ac5e1e0,...c0a8010ac0a8020a0016a11200000006=0A=
    3303,0xf000004f,0x6ac5e660,...c0a8020ac0a8010aa112001600000006=0A=
=0A=
Trace=0A=
-----=0A=
From an earlier run of the same setup: function_graph on=0A=
nf_tables_flowtable_destroy, nf_flow_table_free,=0A=
nf_flow_table_offload_setup and flow_offload_work_handler=0A=
(funcgraph-retval, funcgraph-abstime), plus the mlx5:mlx5e_delete_flower=0A=
event.=0A=
=0A=
At load, BIND succeeds for both devices, and FLOW_CLS_REPLACE reaches the=
=0A=
driver callbacks:=0A=
  841.635738 | 15)  nf_flow_table_offload_setup [nf_flow_table]() {=0A=
  841.635751 | 15)    } /* flow_indr_dev_setup_offload =3D 0x1 */=0A=
  841.636970 |  3)      nf_flow_offload_tuple [nf_flow_table]() {=0A=
  841.636972 |  3)        mlx5e_rep_indr_setup_ft_cb [mlx5_core]() {=0A=
  841.637029 |  3)        } /* mlx5e_rep_indr_setup_ft_cb =3D -95 */  (othe=
r device)=0A=
  841.637030 |  3)        mlx5e_rep_indr_setup_ft_cb [mlx5_core]() {=0A=
  841.637729 |  3)        } /* mlx5e_rep_indr_setup_ft_cb =3D 0x0 */=0A=
  841.637730 |  3)      } /* nf_flow_offload_tuple [nf_flow_table] =3D 0x1 =
*/=0A=
=0A=
At "nft flush ruleset", the release path runs and the DESTROY work finds=0A=
no callbacks:=0A=
  847.435723 | 23)  nf_tables_flowtable_destroy [nf_tables]() {=0A=
  847.435724 | 23)    nf_flow_table_free [nf_flow_table]() {=0A=
  847.435852 | 16)  flow_offload_work_handler [nf_flow_table]() {=0A=
  847.435853 | 16)    nf_flow_offload_tuple [nf_flow_table]() {=0A=
  847.435855 | 16)    } /* nf_flow_offload_tuple =3D 0x0 */  <- no driver c=
allback=0A=
  847.435855 | 16)    nf_flow_offload_tuple [nf_flow_table]() {=0A=
  847.435857 | 16)    } /* nf_flow_offload_tuple =3D 0x0 */=0A=
  847.435859 | 16)  } /* flow_offload_work_handler [nf_flow_table] =3D 0x0 =
*/=0A=
  847.435926 | 23)    } /* nf_flow_table_free [nf_flow_table] =3D ... */=0A=
  847.435938 | 23)  } /* nf_tables_flowtable_destroy [nf_tables] =3D 0x0 */=
=0A=
- No nf_flow_table_offload_setup(UNBIND) call inside=0A=
  nf_tables_flowtable_destroy(); the unbind had already happened at commit.=
=0A=
- mlx5e_delete_flower events: 0.=0A=
=0A=
Control experiment: with the flowtable left in place, "conntrack -D" on the=
=0A=
offloaded connection makes mlx5e_delete_flower fire twice (original +=0A=
reply), and the hardware entries are removed correctly.=0A=
=0A=
Analysis (mainline)=0A=
-------------------=0A=
- When NFT_MSG_DELFLOWTABLE is committed, the kernel calls=0A=
  nft_unregister_flowtable_net_hooks() -> nft_unregister_flowtable_ops(),=
=0A=
  which does nf_unregister_net_hook() and then=0A=
  data.type->setup(..., FLOW_BLOCK_UNBIND).=0A=
- FLOW_BLOCK_UNBIND only frees the flow_block_cb entries=0A=
  (nf_flow_table_block_setup()). It does not remove offloaded flows.=0A=
- Later the release path calls nf_tables_flowtable_destroy() ->=0A=
  data.type->free() =3D nf_flow_table_free(). That tears the flows down and=
=0A=
  queues FLOW_CLS_DESTROY through nf_flow_offload_tuple() over=0A=
  flowtable->flow_block.cb_list, which is empty by then. The hardware=0A=
  entries leak.=0A=
=0A=
Before 13210fc63f35 ("netfilter: nf_tables: imbalance in flowtable=0A=
binding", v6.13), nf_tables_flowtable_destroy() called free() first and=0A=
only then FLOW_BLOCK_UNBIND for each hook, so the DESTROYs were delivered=
=0A=
while the callbacks were still registered. That commit moved the UNBIND=0A=
into __nft_unregister_flowtable_net_hooks() to fix BIND/UNBIND imbalances,=
=0A=
but the hardware flows are now deleted only after the callbacks are gone.=
=0A=
=0A=
The commit was backported to the stable branches. In the stable trees,=0A=
6.12.10+ (6.12.9 is the last without it), 6.6.y, 6.1.y, 5.15.y and 5.10.y=
=0A=
all have the UNBIND in the commit path and none in=0A=
nf_tables_flowtable_destroy(). So every maintained kernel appears to be=0A=
affected, including the distribution kernel I tested. The code is=0A=
unchanged as of v7.3 and v7.4-rc1.=0A=
=0A=
The same leak has been reported independently on a different driver:=0A=
Qualcomm IPQ9570 PPE, kernel 6.18.55 (ImmortalWrt/OpenWrt,=0A=
https://github.com/perceival/openwrt-flint3/issues/115, 2026-10-22). The=0A=
reporter's PPE flow table filled up after a few firewall reloads and gave=
=0A=
the same root cause (hooks unbound at commit before nf_flow_table_free()=0A=
sends the DESTROYs). Their fix is local to that driver.=0A=
=0A=
Proposed tag:=0A=
  Fixes: 13210fc63f35 ("netfilter: nf_tables: imbalance in flowtable bindin=
g")=0A=
The fix should keep that commit's balancing and only make sure the=0A=
hardware entries are deleted before FLOW_BLOCK_UNBIND.=0A=
=0A=
Possible directions:=0A=
 (a) tear down and flush the flowtable's hardware entries before=0A=
     FLOW_BLOCK_UNBIND in the commit path, or=0A=
 (b) for a full flowtable deletion, keep the UNBIND in=0A=
     nf_tables_flowtable_destroy() after free(), as in v6.12.=0A=
=0A=
One way to do (a) that covers every UNBIND caller (flowtable deletion,=0A=
removing a device from a flowtable, the NETDEV_UNREGISTER event): in=0A=
nf_flow_table_offload_setup(), before unbinding, tear down the flows that=
=0A=
use the device and wait for their DESTROY work. This is UNTESTED:=0A=
=0A=
	if (!nf_flowtable_hw_offload(flowtable))=0A=
		return nf_flow_offload_xdp_setup(flowtable, dev, cmd);=0A=
=0A=
+	/* Remove this device's hardware entries while the driver=0A=
+	 * callbacks are still registered.=0A=
+	 */=0A=
+	if (cmd =3D=3D FLOW_BLOCK_UNBIND)=0A=
+		nf_flow_table_gc_cleanup(flowtable, dev);=0A=
+=0A=
	if (dev->netdev_ops->ndo_setup_tc)=0A=
=0A=
nf_flow_table_gc_cleanup() already does teardown -> flush_delayed_work(gc)=
=0A=
-> nf_flow_table_offload_flush(), the order established by 91bfaa15a379=0A=
("netfilter: flowtable: Fix hardware flush order on nf_flow_table_cleanup")=
=0A=
for the netdev-down case. This only works if no caller unbinds after=0A=
nf_flow_table_free() has destroyed the hashtable, which is true for the=0A=
current mainline destroy path. Removing one device from an existing=0A=
flowtable needs the same care; I have not tested that case.=0A=
=0A=
Reproduction (control vs. bug, same setup, only the teardown order differs)=
=0A=
--------------------------------------------------------------------------=
=0A=
Minimal ruleset:=0A=
=0A=
  table inet leak {=0A=
      flowtable ft {=0A=
          hook ingress priority 0=0A=
          devices =3D { "<uplink>.2", "<uplink>.3" }=0A=
          flags offload=0A=
          counter=0A=
      }=0A=
      chain forward {=0A=
          type filter hook forward priority 0; policy accept;=0A=
          meta l4proto tcp ct state established flow add @ft=0A=
      }=0A=
  }=0A=
=0A=
Control: "nft flush chain inet leak forward" (stop new offloads),=0A=
"conntrack -D" for the offloaded connection, wait 4 s, then=0A=
"nft flush ruleset": mlx5e_delete_flower =3D 2, the kernel forwards again=
=0A=
(rx_packets =3D=3D rx_packets_phy), eswitch mode change works.=0A=
=0A=
Bug: "nft flush ruleset" directly: mlx5e_delete_flower =3D 0, the NIC keeps=
=0A=
forwarding, eswitch busy.=0A=
=0A=
Steps for the bug case:=0A=
1. Load the ruleset above; start a TCP transfer between the two VLANs and=
=0A=
   wait until it is [HW_OFFLOAD] with rx_packets << rx_packets_phy.=0A=
2. nft flush ruleset=0A=
3. The transfer keeps running with rx_packets << rx_packets_phy. The=0A=
   conntrack entry is [ASSURED] with frozen counters. The flow rules are=0A=
   still in the mlx5 steering dump. devlink eswitch mode change -> EBUSY.=
=0A=
=0A=
=0A=
Thanks,=0A=
Mohammed Zuhair, Earthlink Telecommunications=0A=
