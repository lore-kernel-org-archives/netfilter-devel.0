Received: from mail362.linkedin.com (mail362.linkedin.com [108.174.3.62])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 962CF346E7A
	for <netfilter-devel@vger.kernel.org>; Wed,  8 Jul 2026 23:35:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=108.174.3.62
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783553724; cv=fail; b=QDAIgBMr/eAz1DkSB4f2B1kY0rGalLyQvThF4juGdVpgVf1ekmxHAKbhqW17iPQv1rqLkXhnACtFCDCGitNJcejDAl31T/aHTCzyMy5u8C+7goAlV/YE5fcUsATj9Kbg4DsT/yhKz7uM3gEuOlcXJCDMQ0ff/ULKNXoibVArWTc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783553724; c=relaxed/simple;
	bh=48yMquSSyIuh3crrrk1YZvlQf59zf0/8QvQuGVsC4r0=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type:MIME-Version; b=YtrCmx89q4tBrkBxWbh6v5SCeRzILYlWLj8DvMi3aD0FB18GgjBuMuvYLn66NTIa1+5M5QiuRgnkuNWH+fM5aaELg8JF1vfnvEbksKSDh82iBjSOLOtdOXkNextLmn/i7nf1Cc4P+phvwcj7ucsIqtRGXGcKbiOgV3eV6eAIeCU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=linkedin.com; spf=pass smtp.mailfrom=linkedin.com; dkim=pass (2048-bit key) header.d=linkedin.com header.i=@linkedin.com header.b=bFhZIHTU; dkim=pass (1024-bit key) header.d=microsoft.onmicrosoft.com header.i=@microsoft.onmicrosoft.com header.b=vWhBnApW; arc=fail smtp.client-ip=108.174.3.62
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=linkedin.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linkedin.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linkedin.com header.i=@linkedin.com header.b="bFhZIHTU";
	dkim=pass (1024-bit key) header.d=microsoft.onmicrosoft.com header.i=@microsoft.onmicrosoft.com header.b="vWhBnApW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linkedin.com;
	s=d2048-202308-00; t=1783553721;
	bh=kG8VoaQsePxjoJfUM9yH1Yr85LghR052MybLb+FF3UU=;
	h=From:To:Subject:Date:Content-Type:MIME-Version;
	b=bFhZIHTUKFRoZTWdVqWFnXeMJ/hqBEimBvJrO/XVm6TBnDzg4rnQQ299F9ylSyAKm
	 U5Gdy/R+5mmSs5vFwl45O5byUsRcsw8kfCCd2bl1qUJb5EGAoILHYBz61OZBAXukkq
	 JQgb7mBjfu1UETdBe8ED5Wvt4dQKGjfpz2gR6cg/Hp+57FksFkS3whm34ZOFvhZYw6
	 U2+VGx+KWOeb7TVl/ANsPGh2osZcADvP9AbcGOFpa0tiTc0j/v1nK5etJnkHTsDmGa
	 y9B5zdWGs1blA+6OC8jTSUM8BXtq2yWVYWNyiIwvfVFO40o7XVKclsZ3DE4YbmEOD7
	 jBVuD2yOCiiEg==
Authentication-Results:  mail362.prod.linkedin.com x-tls.subject="/C=US/ST=Washington/L=Redmond/O=Microsoft Corporation/CN=mail.protection.outlook.com"; auth=pass (cipher=TLS_AES_256_GCM_SHA384)
Authentication-Results: mail362.prod.linkedin.com; iprev=pass policy.iprev="40.93.10.77"; spf=softfail smtp.mailfrom="omkhar@linkedin.com" smtp.helo="co1pr03cu002.outbound.protection.outlook.com"; dkim=pass header.d=microsoft.onmicrosoft.com; tls=pass (verified) key.ciphersuite="nil" key.length="256" tls.v="tlsv1.3" cert.client="C=US,ST=Washington,L=Redmond,O=Microsoft Corporation,CN=mail.protection.outlook.com" cert.clientissuer="C=US,O=DigiCert Inc,CN=DigiCert Cloud Services CA-1"
Received: from [40.93.10.77] ([40.93.10.77:13496] helo=CO1PR03CU002.outbound.protection.outlook.com)
	by mail362.prod.linkedin.com (envelope-from <omkhar@linkedin.com>)
	(ecelerity 4.7.0.20111 r(msys-ecelerity:tags/4.7.0-ga^0)) with ESMTPS (cipher=TLS_AES_256_GCM_SHA384
	subject="/C=US/ST=Washington/L=Redmond/O=Microsoft Corporation/CN=mail.protection.outlook.com") 
	id 4D/CF-24903-9BEDE4A6; Wed, 08 Jul 2026 23:35:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=NAGCLWTbKIgptoOhaDzePwtXezk5sl6Q52JdQHmXhUb4n6lEmsMguOnPy+mSRd2eTehYimh2l3wdk7De+pvJpXFG1Fb4ymkddGVaWCuGhKGePoK/kFRPyfkNVfu4yIhlFsheY7ucGQqeWF3eJbOjVfriJu8kEWv2Z+p36U4IW46CcMMjZ2kW5NEr0UcijygCqYzWXlsQrVwkqMXs7IdQ1Dn2FZ4W3AWOR6Ds/PJDl45E6IU4NFfP1TX6FtIzsJz6pMCYRird3ohmbGAoyo9pDbXtrzNrNL12fQSQdptW9WX+qxn2mu5piu2r6o59+d+jbkTv6Sz6jIYsSlh3XoutTQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kG8VoaQsePxjoJfUM9yH1Yr85LghR052MybLb+FF3UU=;
 b=q9JaA5ggTWeIl9bL9xAaSZ8Id10qENzvQM7b+f4YDmkKUQv4KiDsF5HIzhNZ5omNDDi2o8+TfCNhC8NTANrhOarwxCmpOHXxQu13BFdvXxakS1JN3VCjfURTb6CfirabeAffZdAgkPUCGMS5LK62Fwu+lVybD30nEtTJaSyDVBFQw4WHr5nZWbBdHw4LwezZ68T7TVcNNtMqW1wMK+mOWiVF1XraHL3vz+R96JsMpBH2GiMpbz5MSn+MWZDD2zG0yxhGVP++Exoe7AsM9aHMSZavk6ZhgIVa+EzuZiadI8471ufk6eeDcng0a6SdBQ0Bmu7guGP5vUOEoBugaCGy0A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=linkedin.com; dmarc=pass action=none header.from=linkedin.com;
 dkim=pass header.d=linkedin.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=microsoft.onmicrosoft.com; s=selector2-microsoft-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kG8VoaQsePxjoJfUM9yH1Yr85LghR052MybLb+FF3UU=;
 b=vWhBnApWGXIG4DkeNzeOTVXkNlbFV+DQOV34zC/Farwz3edtoEWgfS+gZDCfreh3scyeiAhLvdtFyVWe+VFvdX56uewwfQkbSqnNehHqugjkrh2759mS/Toj93ZQ1CZXRrfFJKh+64Fy2wpOvdhtulmgdmgM0bCT2D3CekbyeJU=
Received: from LV0SPRMB0026.namprd21.prod.outlook.com (2603:10b6:408:340::11)
 by LV2PR21MB5994.namprd21.prod.outlook.com (2603:10b6:408:34a::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.202.8; Wed, 8 Jul 2026
 23:35:18 +0000
Received: from LV0SPRMB0026.namprd21.prod.outlook.com
 ([fe80::cc6a:8bdb:554:a0bf]) by LV0SPRMB0026.namprd21.prod.outlook.com
 ([fe80::cc6a:8bdb:554:a0bf%6]) with mapi id 15.21.0202.006; Wed, 8 Jul 2026
 23:35:18 +0000
From: Omkhar Arasaratnam <omkhar@linkedin.com>
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
CC: "pablo@netfilter.org" <pablo@netfilter.org>, "fw@strlen.de"
	<fw@strlen.de>, "fmancera@suse.de" <fmancera@suse.de>
Subject: [PATCH nft] parser_json: initialize geneve options list for empty
 tunnel array
Thread-Topic: [PATCH nft] parser_json: initialize geneve options list for
 empty tunnel array
Thread-Index: AQHdDzIGn1S62Xg1wkaLU2d8bAYFog==
Date: Wed, 8 Jul 2026 23:35:18 +0000
Message-ID:
 <LV0SPRMB0026D6A74A8E3E8504609CB0A1FF2@LV0SPRMB0026.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator:
msip_labels:
 MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=True;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2026-07-08T23:32:21.5030602Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard
x-ms-reactions: allow
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=linkedin.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: LV0SPRMB0026:EE_|LV2PR21MB5994:EE_
x-ms-office365-filtering-correlation-id: 38bcd5a7-f390-4ccd-3b3e-08dedd4991c9
x-o365ent-eop-header: Message Processed By - CBR_LInkedIn_Mail_To_External
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam:
 BCL:0;ARA:13230040|1800799024|376014|10070799003|366016|6049299003|23010399003|18002099003|56012099006|11063799006|8096899003|38070700021|4053099003;
x-microsoft-antispam-message-info:
 rsep+y1igj8WEowrO38NKtcAaRoecbWLqw89ltHehpjeQHfnUfCABpY/Fn7gFzAIJrz2q9vLXatZI8Fs6pm/ZhP4G7e6EoXdyOoTkM/hKHqDwXFntxLtvG94zpYcvPT1+mU+Z9NKY4andHY04VBbBbO1dv/TAugOV/U2/LWkRMFNywLfGTuWpqqLBu19dxdRNnVxp8AG/0zepWaWrWEUCNq3rFzGNcRc7IFD4zQQnOZ0SBUxhtgkTGmtgAz1KP3vFx+IkxQjheZd4PbemZfIB/Hdvuf+yhg8H5Iqphquj5FNUS7pg2axF4Cz3WdPth4R4XX2gxXW/Ved99YmoAbjkutKlWEjsXr3O8UTbyildc75H2g2CgPGsW2kwoWidv8/qrnJka3ciCvD9mjaj7QQYe8BfSXDJSj0hh6zOYTrrFI20FyQ0vaIFCPSF+E4JrJlMwCuCA78z/zWlgD1vHV9U5SoQIF4Ij9KfyL1Bvtf08BfOtQIMOLhvIGc8pdwvTPR0E2FaneJXbK/c9Oeoayp69A2SA+MgKuZgjgjiAPDThCoQU9KaHfC/bJSccAwaXljETI1pJjxo4ZMzdM0isH7/mPBd8THgxAdHZKfPqq/MLlLFwdz90+l0mmRx5+fDdjfXtebQ2htFzPSBiR/TfFtQygtq07LYuaylqw1vCfyrOw/Y+UJGGsJ+1wWMOIbIDlw+bguHMbYmWyEpL+HnEcJI/OxpWKE4pYO/zduwInqm2U=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:LV0SPRMB0026.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(10070799003)(366016)(6049299003)(23010399003)(18002099003)(56012099006)(11063799006)(8096899003)(38070700021)(4053099003);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0:
 =?Windows-1252?Q?VMK9QVROJOdwle30d0rEtM4iUHR34ClH0tmm7bTRCD92lHyrNxRGf1sC?=
 =?Windows-1252?Q?UUlaqi3uHVbs7HCJwgft0QAbf19SUn3rK4QoK6q1HB/XQCyBnKtjWcy+?=
 =?Windows-1252?Q?OwYprnKUH52+iVSS+d+3X9n0JzQDveWDeE0DkmllRGCp3hXBuMgBHcZk?=
 =?Windows-1252?Q?UbK8IvbB4/YTmKNGLWrorxFmij1ly42Ggh0XfCzl7q51reVXHQnWEn6C?=
 =?Windows-1252?Q?RfDpyt8UcxW3dC33YIzMzbTdTuOHI1El+w3AHDU2g9cefC3f3sJ0dmkH?=
 =?Windows-1252?Q?Ifj3Q89NjirNg35FM3YK3Gl0Tb4iOlzIVVckqNpon5Y+67DXp+jZNLcA?=
 =?Windows-1252?Q?zGJKaVNsjVfRE5XwseUksVrJpSfW6u1DhniX/z6Us/cNqspOyQtpMJkt?=
 =?Windows-1252?Q?JLtdQA6Gn3HL/Gev/hs8GIHxYuIAS7Gm5gg5zeyjp/4nV+qu+6yP8VcW?=
 =?Windows-1252?Q?3gLb9cFneqGKRE7UZNMixx+DiB1ppqvLa/amekLCC2witVcIy7fhBQjo?=
 =?Windows-1252?Q?8rLtl9xRf6H94cG+S3RtwgdmSIrhTWPMFue2jS71PUvlKY5Q4usPQz3i?=
 =?Windows-1252?Q?XLFYzLlwGGRg0iulXOaN+MfobdittcxomB1aWdIAWwtOwypUtkCLTfol?=
 =?Windows-1252?Q?vQf6wOKqgyTtYfoVmxS2o0rqgSoj9Q7pdSooe8NwHl/kcStXCMtzhMMm?=
 =?Windows-1252?Q?2BDj7s5Z24Uu3Q7Mg7IQ4ooAyx3GY10RHuHk+z9VFrbr3TYjI3V2aI+w?=
 =?Windows-1252?Q?UUA5QTrXxuMohhNSFDL+Q/jZqSYR7s1OxTbqZlnWaqMk1SdlIPjdsTzC?=
 =?Windows-1252?Q?0rgeqd1JWIBFZMerNR/G5143xdxuNNiYsp8MuC6wGFRwlBUzSNFeUh3c?=
 =?Windows-1252?Q?glqse+dCV3bYJ95O83v7DiBysRNbpTPPcke2jY9Fbi6SkA/C0uk/3vBH?=
 =?Windows-1252?Q?0QyISpGRAfxU6w29iI5XlZX44HD2DNSav1+B2Y0tn7vwtQs7iQcu5Zur?=
 =?Windows-1252?Q?XkNUQSZfQVq8qUq6ljo03T5Ba+FFFkDx5ckst0e+DQy6XInKH1d71CEV?=
 =?Windows-1252?Q?6FDRNeGj1aCvOr014kk8amCNvBTfhHLGZe7oMaTD4RaT+ZeLs/vLPpY5?=
 =?Windows-1252?Q?SHD2NAuM2hohXCae8DhNpo/W3EjQFl2iFqeY50euYC4LpbAYV/JMv7fj?=
 =?Windows-1252?Q?zuT85jaMf7bxYnN7eKNTxiFredCnmyQEdy34abN5vqgIbnaq+zM69am0?=
 =?Windows-1252?Q?yFaaKx+MOXJjn0ZgmVWkrJF70AOsFlmd3r3RRVfS29zYZXI/hjbepQyH?=
 =?Windows-1252?Q?AALJhvPyPCtYFqEH1yjOb/5SmOmIRV/nZ/p+qkCBHjfB/cHyXmX7jxEt?=
 =?Windows-1252?Q?s0sLq0GbE0A9prazoV6IMyY6co3PMQmpaChleu1/RYY+OgHgPQ+lEBtF?=
 =?Windows-1252?Q?Ya4L0DCbplL0/OidkY3v02Iy+RuhKB9Dzvj9+dEMFzIxzsSxgbchQ7L1?=
 =?Windows-1252?Q?HuSwL9ERoMt7U8nEA7Gu63E7jBojqTByiaapbFHG0y9J2nxUFwpqMHRp?=
 =?Windows-1252?Q?TiwMOrvjQvUE4AfEa2J1dGTGsuTruaKLiotlDTWLsypPh4xXwgskp6QF?=
 =?Windows-1252?Q?/pByZGpwkIb3hKFNM3nhzCn+UQbwwumkVmygrk2OBIBdskZMAYr73g0d?=
 =?Windows-1252?Q?LrRL4EH/UJ+/1THYpnNz1fFRc2blD+i5WaiZ3011RSP7rpqZT6i9eOzQ?=
 =?Windows-1252?Q?a8Afxs1+a0qPdiVzSBWPoJ3/IUtNjnO+HHnSUpxPRDHWKw1I8zPVZYHZ?=
 =?Windows-1252?Q?B7BRWDDtR6PbdM4la/By4C0rvmXHQMIZUwLDL8wNQeeLX1emAh/qL4It?=
 =?Windows-1252?Q?Oi8cPDl1E/WdZm7lqDGpksBCn7wNVkcOEA7BMtLAIjHfKL/S/+Haoj+A?=
 =?Windows-1252?Q?TONZo8u+?=
x-ms-exchange-antispam-messagedata-1: rLXZr59IkmOWX7P1vHzytPng4Qsj3AlpxeU=
Content-Type: multipart/mixed;
	boundary="_004_LV0SPRMB0026D6A74A8E3E8504609CB0A1FF2LV0SPRMB0026namprd_"
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Exchange-RoutingPolicyChecked:
	TV4NVAycrW+0XCTBM+qrej4uDeIRdYRPwrCH1rM/GDtPQBg2YgTIzWvtvpYwhEC0+ZPMukyOos819UExmioWFaZcWn6Jm0+K410sx3hnJp2KqHvoWBSO8YojqONqp/2yKXL58k0Wqe5XSjoDC2l2PwCSs3Fao9AoY/hdLHWZAYsQB0lk8ccnF0MV1T9bMZuqPngnd+ZX84mjUz632e/NvHVfl6N+/XfkdupVgtocxg1jNTyH/Evk+85aW7bhyzXsB8YYtfqfTYzHWMBIVRn08X+eQKwn7IUUT/jGiB0rNj4FCWBd/vkbx6iU+7cEcxtt0VO8ayBJMS4BG+B5RaZf2Q==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	9dYz9XPxyMUhoiP30ZRrDBZDrsubxhR85EQvu4BcuhQVbCV4z74TNTAyauGs/Z0ofwMy8o9TY3oLQpFgn2mlzd2hWqP7St2GgNPmLP9XLLZldWfSAfZ4nX6HEfMz0B6Dl5KdEPwyTO/Jpyn7/ILTtwQnAvOfui+wuSiC66Z9sScVFgA52QLapHDKc42TSJzIo/rHfD73f+WKK4AQH1E06BstU9ihvc2ga1375QT9P25l+naBUKOtwMtLQeMxt12jZBFAWBeYAq8xBIJpPxZTgEXytZsKshZDB2QWZA9ZA6uMJlELNl9EL3ucumJh6T3Sbyk/3wyR56iRnYeCY7r66m7H1+1SufqbiekDvx8kIgscjidqFjeliue03XOwHTdssgREh7DjwU+uU6/Oay+bH/5AfZs5o45cGlq43Odl/CcHKtz/NzZc0Y/VtBB/jWfTMpKLNPzprzXQsr2ETeBVxs3dRjSD0A4qwmtwohof+BKSC06YeL5bJId1p01QfouKx21F6lj0kR35vAtsuVzN0gGGQ3mmbvQvRA6hx47YwVbED6LS775LvEIbiH4nJDajUJ8fj9/27dpi9tiqzj3/XCM9UG1FHAkyU8pd4nbbAdEwQNDBqJeT980DqOJz/7FnSXOTvNE7NAqMIiLXfO9d1kdn+V/LbgMjFW5tD6NKusk=
X-OriginatorOrg: linkedin.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: LV0SPRMB0026.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38bcd5a7-f390-4ccd-3b3e-08dedd4991c9
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Jul 2026 23:35:18.0931
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: DIdAUctMuQeCc5Sf+n95M0QUAW/ZgDp9QzlHg/U9tiRLdHbMNjZ136qOvMs8WhC4uhysE2J4DVPgerdXhZFPjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: LV2PR21MB5994

--_004_LV0SPRMB0026D6A74A8E3E8504609CB0A1FF2LV0SPRMB0026namprd_
Content-Type: multipart/alternative;
	boundary="_000_LV0SPRMB0026D6A74A8E3E8504609CB0A1FF2LV0SPRMB0026namprd_"

--_000_LV0SPRMB0026D6A74A8E3E8504609CB0A1FF2LV0SPRMB0026namprd_
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable

Hi,

The attached patch fixes a crash in the JSON parser. A geneve tunnel object=
 with an empty options array ("tunnel": []) leaves obj->tunnel.geneve_opts =
uninitialized; obj_tunnel_add_opts() then walks the uninitialized list head=
 and nft -j crashes (SEGV in nftnl_tunnel_opt_geneve_set via near-NULL dere=
f).

The equivalent native-syntax empty definition was already handled in f9047c=
1f ("evaluate: tunnel: don't assume src is set"); this covers the JSON pars=
er path, which that fix did not reach. It is independent of Phil Sutter's p=
ending "parser_json: Introduce json_parse_tunnel()" refactor, which relocat=
es this block but carries the "if (index =3D=3D 0)" guard forward unchanged=
 -- happy to rebase onto or fold into that series if you prefer.

I'm sending the patch as an attachment because my mail client mangles inlin=
e patches; it applies cleanly with git am. The full commit message, crash t=
race, reproducer, and diff are in the attachment.

=97 oa



--_000_LV0SPRMB0026D6A74A8E3E8504609CB0A1FF2LV0SPRMB0026namprd_
Content-Type: text/html; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable

<html>
<head>
<meta http-equiv=3D"Content-Type" content=3D"text/html; charset=3DWindows-1=
252">
</head>
<body>
<div style=3D"font-family: Aptos, Arial, Helvetica, sans-serif; font-size: =
12pt;">Hi,</div>
<div style=3D"font-family: Aptos, Arial, Helvetica, sans-serif; font-size: =
12pt;"><br>
</div>
<div style=3D"font-family: Aptos, Arial, Helvetica, sans-serif; font-size: =
12pt;">The attached patch fixes a crash in the JSON parser. A geneve tunnel=
 object with an empty options array (&quot;tunnel&quot;: []) leaves obj-&gt=
;tunnel.geneve_opts uninitialized; obj_tunnel_add_opts()
 then walks the uninitialized list head and nft -j crashes (SEGV in nftnl_t=
unnel_opt_geneve_set via near-NULL deref).</div>
<div style=3D"font-family: Aptos, Arial, Helvetica, sans-serif; font-size: =
12pt;"><br>
</div>
<div style=3D"font-family: Aptos, Arial, Helvetica, sans-serif; font-size: =
12pt;">The equivalent native-syntax empty definition was already handled in=
 f9047c1f (&quot;evaluate: tunnel: don't assume src is set&quot;); this cov=
ers the JSON parser path, which that fix did
 not reach. It is independent of Phil Sutter's pending &quot;parser_json: I=
ntroduce json_parse_tunnel()&quot; refactor, which relocates this block but=
 carries the &quot;if (index =3D=3D 0)&quot; guard forward unchanged -- hap=
py to rebase onto or fold into that series if you prefer.</div>
<div style=3D"font-family: Aptos, Arial, Helvetica, sans-serif; font-size: =
12pt;"><br>
</div>
<div style=3D"font-family: Aptos, Arial, Helvetica, sans-serif; font-size: =
12pt;">I'm sending the patch as an attachment because my mail client mangle=
s inline patches; it applies cleanly with git am. The full commit message, =
crash trace, reproducer, and diff
 are in the attachment.</div>
<div style=3D"font-family: Aptos, Arial, Helvetica, sans-serif; font-size: =
12pt;"><br>
</div>
<div style=3D"font-family: Aptos, Arial, Helvetica, sans-serif; font-size: =
12pt;">=97 oa</div>
<div id=3D"ms-outlook-mobile-signature" dir=3D"ltr">
<div style=3D"direction: ltr; font-family: Aptos, Arial, Helvetica, sans-se=
rif; font-size: 12pt; color: rgb(0, 0, 0);">
<br>
</div>
<div style=3D"direction: ltr;"><br>
</div>
</div>
</body>
</html>

--_000_LV0SPRMB0026D6A74A8E3E8504609CB0A1FF2LV0SPRMB0026namprd_--

--_004_LV0SPRMB0026D6A74A8E3E8504609CB0A1FF2LV0SPRMB0026namprd_
Content-Type: application/octet-stream; name="nftables-parse-0001.patch"
Content-Description: nftables-parse-0001.patch
Content-Disposition: attachment; filename="nftables-parse-0001.patch";
	size=3136; creation-date="Wed, 08 Jul 2026 23:34:27 GMT";
	modification-date="Wed, 08 Jul 2026 23:34:27 GMT"
Content-Transfer-Encoding: base64

RnJvbSBkZTgxN2VjMTgwYTM3Y2M5YWY1NzA4MDliNjMyZGY5ODQzNzRmYmE0IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBPbWtoYXIgQXJhc2FyYXRuYW0gPG9ta2hhckBsaW5rZWRpbi5j
b20+CkRhdGU6IFdlZCwgOCBKdWwgMjAyNiAyMzowOTo1MiArMDAwMApTdWJqZWN0OiBbUEFUQ0gg
bmZ0XSBwYXJzZXJfanNvbjogaW5pdGlhbGl6ZSBnZW5ldmUgb3B0aW9ucyBsaXN0IGZvciBlbXB0
eQogdHVubmVsIGFycmF5Cgpqc29uX3BhcnNlX2NtZF9hZGRfb2JqZWN0KCkgb25seSBpbml0aWFs
aXplcyBvYmotPnR1bm5lbC5nZW5ldmVfb3B0cyBvbgp0aGUgZmlyc3QgaXRlcmF0aW9uIG9mIHRo
ZSBqc29uX2FycmF5X2ZvcmVhY2goKSBsb29wLCBndWFyZGVkIGJ5CiJpZiAoaW5kZXggPT0gMCki
LiBBIGdlbmV2ZSB0dW5uZWwgb2JqZWN0IHdob3NlIG9wdGlvbnMgYXJyYXkgaXMgZW1wdHkKKCJ0
dW5uZWwiOiBbXSkgbmV2ZXIgZW50ZXJzIHRoZSBsb29wLCBzbyB0aGUgbGlzdCBoZWFkIGlzIGxl
ZnQKdW5pbml0aWFsaXplZC4gb2JqX3R1bm5lbF9hZGRfb3B0cygpIChzcmMvbW5sLmMpIGxhdGVy
IHdhbGtzIGl0IHdpdGgKbGlzdF9mb3JfZWFjaF9lbnRyeSgpIGFuZCBwYXNzZXMgdGhlIGJvZ3Vz
IGVsZW1lbnQgdG8gbGlibmZ0bmwsIHdoaWNoCmRlcmVmZXJlbmNlcyB0aGUgbmVhci1OVUxMIHBv
aW50ZXIgYW5kIGNyYXNoZXMgbmZ0OgoKICAjIG5mdCAtaiAtZiBlbXB0eV9nZW5ldmUuanNvbgog
IEFkZHJlc3NTYW5pdGl6ZXI6IFNFR1Ygb24gdW5rbm93biBhZGRyZXNzIDB4MDAwMDAwMDAwMDEy
CiAgICAjMSBuZnRubF90dW5uZWxfb3B0X2dlbmV2ZV9zZXQgIG9iai90dW5uZWwuYzo4ODAKICAg
ICMyIG5mdG5sX3R1bm5lbF9vcHRfc2V0ICAgICAgICAgb2JqL3R1bm5lbC5jOjkxMAogICAgIzMg
b2JqX3R1bm5lbF9hZGRfb3B0cyAgICAgICAgICBzcmMvbW5sLmM6MTYwOAogICAgIzQgbW5sX25m
dF9vYmpfYWRkICAgICAgICAgICAgICBzcmMvbW5sLmM6MTc1NwogICAgIzUgZG9fY29tbWFuZF9h
ZGQgICAgICAgICAgICAgICBzcmMvcnVsZS5jOjE1NDIKICAgICM2IGRvX2NvbW1hbmQgICAgICAg
ICAgICAgICAgICAgc3JjL3J1bGUuYzoyODAyCiAgICAjMTAgbWFpbiAgICAgICAgICAgICAgICAg
ICAgICAgIHNyYy9tYWluLmM6NTM5Cgp3aGVyZSBlbXB0eV9nZW5ldmUuanNvbiBpczoKCiAgeyAi
bmZ0YWJsZXMiOiBbCiAgICB7ICJhZGQiOiB7ICJ0YWJsZSI6IHsgImZhbWlseSI6ICJuZXRkZXYi
LCAibmFtZSI6ICJ4IiB9IH0gfSwKICAgIHsgImFkZCI6IHsgInR1bm5lbCI6IHsgImZhbWlseSI6
ICJuZXRkZXYiLCAibmFtZSI6ICJ0IiwgInRhYmxlIjogIngiLAogICAgICAgICJzcmMtaXB2NCI6
ICIxOTIuMTY4LjIuMTAiLCAiZHN0LWlwdjQiOiAiMTkyLjE2OC4yLjExIiwKICAgICAgICAidHlw
ZSI6ICJnZW5ldmUiLCAidHVubmVsIjogW10gfSB9IH0gXSB9CgpJbml0aWFsaXplIHRoZSBsaXN0
IGhlYWQgdW5jb25kaXRpb25hbGx5IGJlZm9yZSB0aGUgbG9vcCBhbmQgZHJvcCB0aGUKcGVyLWl0
ZXJhdGlvbiBndWFyZCwgc28gYW4gZW1wdHkgYXJyYXkgbGVhdmVzIGEgdmFsaWQgZW1wdHkgbGlz
dC4gVGhlCmVxdWl2YWxlbnQgbmF0aXZlLXN5bnRheCBlbXB0eSBkZWZpbml0aW9uIHdhcyBhbHJl
YWR5IGhhbmRsZWQgaW4gY29tbWl0CmY5MDQ3YzFmICgiZXZhbHVhdGU6IHR1bm5lbDogZG9uJ3Qg
YXNzdW1lIHNyYyBpcyBzZXQiKTsgdGhpcyBjb3ZlcnMgdGhlCkpTT04gcGFyc2VyIHBhdGgsIHdo
aWNoIHRoYXQgZml4IGRpZCBub3QgcmVhY2guCgpGaXhlczogM2E5NTdmOGYxZmYxICgidHVubmVs
OiBhZGQgdHVubmVsIG9iamVjdCBhbmQgc3RhdGVtZW50IGpzb24gc3VwcG9ydCIpClNpZ25lZC1v
ZmYtYnk6IE9ta2hhciBBcmFzYXJhdG5hbSA8b21raGFyQGxpbmtlZGluLmNvbT4KLS0tCk5vdGU6
IGluZGVwZW5kZW50IG9mIFBoaWwgU3V0dGVyJ3MgcGVuZGluZyBzZXJpZXMgIkVsaW1pbmF0ZSB2
YXJpYWJsZQpkZWNsYXJhdGlvbnMgaW4gc3dpdGNoIGNhc2VzIiAobmZ0IFBBVENIIDAvNiwgMjAy
Ni0wNi0wMyksIHdob3NlIDIvNgoicGFyc2VyX2pzb246IEludHJvZHVjZSBqc29uX3BhcnNlX3R1
bm5lbCgpIiByZWxvY2F0ZXMgdGhpcyBibG9jayBidXQgY2Fycmllcwp0aGUgImlmIChpbmRleCA9
PSAwKSIgZ3VhcmQgZm9yd2FyZCB1bmNoYW5nZWQuIFRoaXMgaXMgYSBzdGFuZGFsb25lLApiYWNr
cG9ydGFibGUgY3Jhc2ggZml4OyBoYXBweSB0byByZWJhc2Ugb24gdG9wIG9mIHRoYXQgc2VyaWVz
IG9yIGZvbGQgaXQgaW4uCiBzcmMvcGFyc2VyX2pzb24uYyB8IDUgKystLS0KIDEgZmlsZSBjaGFu
Z2VkLCAyIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvc3JjL3Bh
cnNlcl9qc29uLmMgYi9zcmMvcGFyc2VyX2pzb24uYwppbmRleCBmMDQ3NzJhMC4uNmEwYzE3NDUg
MTAwNjQ0Ci0tLSBhL3NyYy9wYXJzZXJfanNvbi5jCisrKyBiL3NyYy9wYXJzZXJfanNvbi5jCkBA
IC0zOTQxLDYgKzM5NDEsOCBAQCBzdGF0aWMgc3RydWN0IGNtZCAqanNvbl9wYXJzZV9jbWRfYWRk
X29iamVjdChzdHJ1Y3QganNvbl9jdHggKmN0eCwKIAkJCQkJICAgICJ7czpvfSIsICJ0dW5uZWwi
LCAmdG1wX2pzb24pKQogCQkJCWdvdG8gZXJyX2ZyZWVfb2JqOwogCisJCQlpbml0X2xpc3RfaGVh
ZCgmb2JqLT50dW5uZWwuZ2VuZXZlX29wdHMpOworCiAJCQlqc29uX2FycmF5X2ZvcmVhY2godG1w
X2pzb24sIGluZGV4LCB2YWx1ZSkgewogCQkJCXN0cnVjdCB0dW5uZWxfZ2VuZXZlICpnZW5ldmUg
PSB4bWFsbG9jKHNpemVvZihzdHJ1Y3QgdHVubmVsX2dlbmV2ZSkpOwogCQkJCWlmICghZ2VuZXZl
KQpAQCAtMzk2Myw5ICszOTY1LDYgQEAgc3RhdGljIHN0cnVjdCBjbWQgKmpzb25fcGFyc2VfY21k
X2FkZF9vYmplY3Qoc3RydWN0IGpzb25fY3R4ICpjdHgsCiAJCQkJCWdvdG8gZXJyX2ZyZWVfb2Jq
OwogCQkJCX0KIAotCQkJCWlmIChpbmRleCA9PSAwKQotCQkJCQlpbml0X2xpc3RfaGVhZCgmb2Jq
LT50dW5uZWwuZ2VuZXZlX29wdHMpOwotCiAJCQkJbGlzdF9hZGRfdGFpbCgmZ2VuZXZlLT5saXN0
LCAmb2JqLT50dW5uZWwuZ2VuZXZlX29wdHMpOwogCQkJfQogCQkJYnJlYWs7Ci0tIAoyLjQzLjAK
Cg==

--_004_LV0SPRMB0026D6A74A8E3E8504609CB0A1FF2LV0SPRMB0026namprd_--
