Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F730C4332F
	for <netfilter-devel@archiver.kernel.org>; Thu,  3 Nov 2022 20:02:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229733AbiKCUCS (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Nov 2022 16:02:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229699AbiKCUCN (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Nov 2022 16:02:13 -0400
Received: from EUR02-AM0-obe.outbound.protection.outlook.com (mail-am0eur02on2127.outbound.protection.outlook.com [40.107.247.127])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9698610E
        for <netfilter-devel@vger.kernel.org>; Thu,  3 Nov 2022 13:02:11 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LeNfBOKEM/JGCE3B2M2JULylBT3jxycCHXJl2psg2trrmfMRLqIa4xKmQo+v6HA6Qf/7jYMBKcU95pQ69Y3hMP9ENw/48M2lhYXnD2dQqjEzddNkodYYNFj7EEyedN71OCrQGgcxOUCLMK9UMZA/Tfecp98TjNScFazeemo/BrvYBqgb4NQKlhruwaqIxl5FVTdM2i1BmghYynsxr01Epxyek4sShoxyHQT1Dk0efse9n8za63PjkczUg71d62CVejzzL5BGXL3ZzlKko6DW/R9getnvE+MP8EgLN/rstOS3m3gqrDpu1pWfWbMLnWRLsPhy7/WGvUqtZgBSjqdM2Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Vcdhy+7I5sMz1Q8ADgIsXsN5mcMsKot6Tcq5HD+ywvM=;
 b=ZhMYGQGhrCVUVruArOAvAPgvP8jsejNTpcWnaxSlDq4ets7NlF3yfaVcMa6PGC7zTaBxPvZqAOkrMsFF+JrrawXpa+ZhBGAqqffTUPoKMHIdomPp1ojuTdpyCH2xH1SgIA8MckiV7jIXbAtZiB8ix1VHXZY8W/FkJ+sY5FZZsa5RO3b7vp1U2oM9Wotgc9Vak3wVSByfXWyWngjAa4VDdohTMmw8rJTGEoXoEe6awbzNh8CvcuanhdpKfM3Qw1yPPBMr0DT/ZiDMfsIM/tZoWhnBFphDURCepM7REiFF6XAWY8pFysJn9nhEw3PAEmrVMoKh1tBJq6uiw3UiMj+qIQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=est.tech; dmarc=pass action=none header.from=est.tech;
 dkim=pass header.d=est.tech; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=estab.onmicrosoft.com;
 s=selector2-estab-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Vcdhy+7I5sMz1Q8ADgIsXsN5mcMsKot6Tcq5HD+ywvM=;
 b=G0UCpvyORGOt5OZJ2q9RTiG5iEpqRPtuOrvEwWTwaZUZBrvE+bYNF7klCiyHCRIWcXsmhlXmBgL+/g3KgHqkGRn7cUBT63ol9cP/gNYEuV9evcRMZ+v/V6QICiEP1S/Fy5OSBedQvixplq79YsyDIOt8vWWqligF9jFPuuBHkWA=
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:1e7::15)
 by DB8P189MB1079.EURP189.PROD.OUTLOOK.COM (2603:10a6:10:160::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.20; Thu, 3 Nov
 2022 20:02:08 +0000
Received: from DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::9a8b:297a:91d9:67c8]) by DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
 ([fe80::9a8b:297a:91d9:67c8%9]) with mapi id 15.20.5813.008; Thu, 3 Nov 2022
 20:02:08 +0000
From:   Sriram Yagnaraman <sriram.yagnaraman@est.tech>
To:     Florian Westphal <fw@strlen.de>
CC:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        kernel test robot <lkp@intel.com>,
        "claudio.porfiri@ericsson.com" <claudio.porfiri@ericsson.com>
Subject: Re: [PATCH v2 1/2] netfilter: conntrack: introduce no_random_port
 proc entry
Thread-Topic: [PATCH v2 1/2] netfilter: conntrack: introduce no_random_port
 proc entry
Thread-Index: AQHY7FrDQrsWkPaZuU67OW2UiNVkVq4oL7oAgACoXwCAAtYagIAB92UA
Date:   Thu, 3 Nov 2022 20:02:08 +0000
Message-ID: <4ed54d0a-0e5e-0e58-7877-752b3b4ce3ab@est.tech>
References: <20221030122541.31354-1-sriram.yagnaraman@est.tech>
 <20221030122541.31354-2-sriram.yagnaraman@est.tech>
 <20221031083858.GB5040@breakpoint.cc>
 <7c24bfe4-94be-6eab-d30a-6dc0500652da@est.tech>
 <20221102140025.GF5040@breakpoint.cc>
In-Reply-To: <20221102140025.GF5040@breakpoint.cc>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=est.tech;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DBBP189MB1433:EE_|DB8P189MB1079:EE_
x-ms-office365-filtering-correlation-id: 4d1ab021-7096-4127-8dd6-08dabdd649aa
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: iXpQjCxcZn9y+/2O86NV6v7NxtP8diUtunKPm2T/z09KyPEkeJPnjBgB48Kk6VN6FsSsO8pLdoJ3k7T2nj6epjgbk143VZ23CoY3U7yjGNeRAdlqJ3jAubQl01rB/7c8UcNzPvILMEXolJ6r6gSK2rAb9TEuyOO5fjj0vKEMinhF7w9TMCjiN0rmAv2zzI9uOmfAlUhYpres2j4hYiggQCoqWlGmdeHYKbYvllpca+XDsiHn/CjFF7RJWg3vCXjW3ReZeMHNRHYSkZodjW44VYK8fKQKeXqGXOhA4DK1HTQKBSJ9w4EdBpbt2AN6fchyCKaFhSqSr2QN93f5i+U4jxR+Rt7DO9Pmlj7Bk9Wy6VftmMFfKBdPEznhSNj6vDPpvZP9+fYzBWAXd3OreHjYAZc+m/4mA2RMFq/dcVhjCcm40+TzxgGtySbOpOwInhwvwLsUGR5gQIuQZtK1qTu2FothY/AXEgB68/kiMwFsZd01R2dblJgxSCHZk9ugDIcHz6mEe1gHcUgXm9SHZ24WXDtaQJcsdxjslI50YaS8IB05nIGwHVYkLwomI0ccFycwlAnCQML8Rfg2P8PFG0jJTitWak9Y3IoVvs20AxblJxPSUA6x+x/fPxT74BP5/KZ6ns97L5DrhmPlFuWZ2ThV+43x3Oam0DaKi+dX2YVHDC3kV5zR60rzHN6/29ToQ0ioPHn/mwLcA1h6ZoyiOQ4AUYCwB7td0r19SJM2iqHbv2u16SoId9BrMq/nkmVI97PxKPh7vtNg3xTill8NJzulVGu24H62z7cb0Z+j7Pi0jiM=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DBBP189MB1433.EURP189.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230022)(346002)(396003)(376002)(136003)(39840400004)(366004)(451199015)(316002)(26005)(38100700002)(4326008)(41300700001)(91956017)(36756003)(54906003)(53546011)(66556008)(66946007)(83380400001)(66446008)(8676002)(122000001)(6916009)(8936002)(64756008)(86362001)(6512007)(5660300002)(31696002)(66476007)(76116006)(2616005)(44832011)(186003)(2906002)(4001150100001)(6486002)(38070700005)(71200400001)(6506007)(31686004)(478600001)(45980500001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?WWc3bFM2VjJ5ZjZFbUJtQTQ5WlJ4Wk9GSkR4WEVXVzk1RVY0K2NPNytpeWVM?=
 =?utf-8?B?a3ZzdEZnZlFjOGVPMmVwNXlzRURNMUFYT2NlQU1kdXJMektzZnc3SXRjazN2?=
 =?utf-8?B?Mng2RVcybEh0QlVHdloxTzM5MkgrSGJpZEoxd0szbUxYaFN3ZnAvL1hqZ2Q4?=
 =?utf-8?B?dGk0ZlNVWTNQcHlLaUUza1R1Y2dmVGlqN0VzZ1h5anRTLzV3U05tQkFacHUv?=
 =?utf-8?B?RER4OTBhQmF0alF2UWs2MmNVVTBwTmlPRG9PVTVXSmFLL2xIT1BSVi9hMDRx?=
 =?utf-8?B?WGwwMnRiR1JhRW4veVIzL3R0RWZ4YVc0blY5VDl5WDlpOWFMNk9neE9HNElC?=
 =?utf-8?B?enhoN01EajFPUnBic0lzMEVhOFNUTm03eFA3dy83WXNxaDBmR0FqOUwwN1c1?=
 =?utf-8?B?K0FPUzRVUmFueXRzMVR6U3JEZ205eTYyL29ubXN2ZVkvbnNsUmR5Uk13ekZQ?=
 =?utf-8?B?dDVBa2ROQkJ2NnZtclZlN2N6cXFHNXRKYm5zdUlpeEpLODhaYk53WnJPTGo5?=
 =?utf-8?B?akJJU21uc1E3WjBTMlNvNFEzVnczSDlXRFJ6MzA1Q0ZKWENRRTVxdjJoVXZZ?=
 =?utf-8?B?S0tGalhrMmZodUVoNnpaTFBTYWpyeFV0ZzBLak8xdGhGbTZ4LytRWGc0U2ZE?=
 =?utf-8?B?OW9DcUZrZ0wwL09UbVVXeUpzVnB5OHJUcmIwbTlNRU1zRENmT0g4ZXRmWURF?=
 =?utf-8?B?d04xZGRabTY5NmovWHhXWEUzQTZjaHIwK2Qzb0w3UGxjQi9KY21JNWxWQmdS?=
 =?utf-8?B?RXVXNWxzOVQzVHJzWkZJbDhhYTFXNy9FaUdGSDR0TWNKU0lHQzNxcENVN3BJ?=
 =?utf-8?B?c0ozek9tbm9kVHlvV25yK3VyV1dnSk9wNWFWbWVTeUxjZlN3cnBaeUkyUEtU?=
 =?utf-8?B?OCtVaksreWhEdkNLMzN2QS82YWxad0NPSnVNNVB0blRQYUZKQmFnYldXOVI1?=
 =?utf-8?B?UG02cTFwL01MQzdCMFREMFBjOXN0ck5HUit1d2FtY09zbE9MTTBlMGp2anRU?=
 =?utf-8?B?Y1ZTQmowMXRmYm9zaXdrRURCbzY0Z285RWZnSFhHWlBuRWF1Tkp6aVBvSXp4?=
 =?utf-8?B?R0NkbVhnL3RDNTRaOHVGUmNnaUU2ZEx3V0x4alVrbzdhQitQa2E4WktOc2R0?=
 =?utf-8?B?N0NjeWkrSXBoaU9FbkxZRVNBSmpiVjdQOXhqQ0N1K1V5S0hDc1FiU3dQTVJK?=
 =?utf-8?B?c1FsbHRJRHVlZDZzVWoyazhmaEZhMFJiOENIUFd6ZkVFUi8vY2t4Ym9iN0ZW?=
 =?utf-8?B?S3JUb3hjR1Z6ak9kY3pSa2JOamljaHVheGQzaDFEVTdDUFl5OWxINnovaFNH?=
 =?utf-8?B?SjF3RTlZSU16SjIxdGZKZ2t2Sy9OWDdvWmV4dGpYOFlpTFlpdXVVZlI3aFA5?=
 =?utf-8?B?czFtNFc0aUpIbkU5VlBIQm1HZTBRTFJTUmRFOElSTXVrMEovVm9tOXhNczh5?=
 =?utf-8?B?dGJCaGgrMzdXaG05RFFHM2F3SjVWZXo0R25OdU9LSnA3cDBpRnRvZU9rTjJU?=
 =?utf-8?B?d1NKUHAvdXY3cndld3VvRC9GbnBUSURKNytUajRDVWx5dWVXY3d3L2d1WjFE?=
 =?utf-8?B?ZmFHMkJ6dXJsR2NWQ1JDbUVva2VGS0hCOUxTamE0ZnJYV2tXOTh6eGhuTi90?=
 =?utf-8?B?cnBWK1ViLzdCZ2xNcUR6OXpTSGVWcW54Ym9WRjA5S1dVb2svMTNGYW8wWm1r?=
 =?utf-8?B?VUlIYytFL1VHSkdGMHFnQWpJZkZkbzZnTW80R2J0Nm5KcG1MWlArdzJ0SURU?=
 =?utf-8?B?UjZLdzNBdVo2WTR3NmFyWGo3NFJVZVpiYzRFQ2h3NnZ6S2FUT1ZKVVJRTUNm?=
 =?utf-8?B?cnU1VnNlamRsRjl5cUIxUldHbzNYSXZmbDE4VnlncURVczFIM2NHdWxFV1BV?=
 =?utf-8?B?c0tFaUszUXUwYWxPd2p1WUFKZFovNy9sbktjUC9BN3B1UGRSNXpFOWM1RzVr?=
 =?utf-8?B?NWduVVNVOHd1UHhPZk4waDBlMFl3c3hjU1J1SWV0b055UldINkhJY29uclhF?=
 =?utf-8?B?Y1owRlRlV1NNbndVdC93Tjc5Z3YwVGRZbVpLNHREY3JMU1VCWTFOcGEvYlFq?=
 =?utf-8?B?aTlyVTIyRHY1SDNsdUZDdm9EeGQwVUg0NGZMQVMyUVB5MVFHbVFoU1ZVYVhw?=
 =?utf-8?Q?+LGj8lwPvyo8Fb7vZSlEu6HLN?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <FE59020824E462499FF546A5AAE25A40@EURP189.PROD.OUTLOOK.COM>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: est.tech
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DBBP189MB1433.EURP189.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 4d1ab021-7096-4127-8dd6-08dabdd649aa
X-MS-Exchange-CrossTenant-originalarrivaltime: 03 Nov 2022 20:02:08.2599
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: d2585e63-66b9-44b6-a76e-4f4b217d97fd
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qvgyiPpHfeVgk5sQJSyGHflELPgDsLwwACzCEiF7h/Mt9Pda8Eud5Nj0vCEhUsdkE054XkSfsg0wfJF4kwburoIN35QTNxitIYFrwTo8R8k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DB8P189MB1079
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

T24gMjAyMi0xMS0wMiAxNTowMCwgRmxvcmlhbiBXZXN0cGhhbCB3cm90ZToNCg0KPiBTcmlyYW0g
WWFnbmFyYW1hbiA8c3JpcmFtLnlhZ25hcmFtYW5AZXN0LnRlY2g+IHdyb3RlOg0KPj4gT24gMjAy
Mi0xMC0zMSAwOTozOCwgRmxvcmlhbiBXZXN0cGhhbCB3cm90ZToNCj4+DQo+Pj4gc3JpcmFtLnlh
Z25hcmFtYW5AZXN0LnRlY2ggPHNyaXJhbS55YWduYXJhbWFuQGVzdC50ZWNoPiB3cm90ZToNCj4+
Pj4gRnJvbTogU3JpcmFtIFlhZ25hcmFtYW4gPHNyaXJhbS55YWduYXJhbWFuQGVzdC50ZWNoPg0K
Pj4+Pg0KPj4+PiBUaGlzIHBhdGNoIGludHJvZHVjZXMgYSBuZXcgcHJvYyBlbnRyeSB0byBkaXNh
YmxlIHNvdXJjZSBwb3J0DQo+Pj4+IHJhbmRvbWl6YXRpb24gZm9yIFNDVFAgY29ubmVjdGlvbnMu
DQo+Pj4gSG1tLiAgQ2FuIHlvdSBlbGFib3JhdGU/ICBUaGUgc3BvcnQgaXMgbmV2ZXIgcmFuZG9t
aXplZCwgdW5sZXNzIGVpdGhlcg0KPj4+IDEuIFVzZXIgZXhwbGljaXRseSByZXF1ZXN0ZWQgaXQg
dmlhICJyYW5kb20iIGZsYWcgcGFzc2VkIHRvIHNuYXQgcnVsZSwgb3INCj4+PiAyLiB0aGUgaXMg
YW4gZXhpc3RpbmcgY29ubmVjdGlvbiwgdXNpbmcgdGhlICpzYW1lKiBzcG9ydDpzYWRkciAtPiBk
YWRkcjpkcG9ydA0KPj4+ICAgIHF1YWRydXBsZSBhcyB0aGUgbmV3IHJlcXVlc3QuDQo+Pj4NCj4+
PiBJbiAyKSwgdGhpcyBuZXcgdG9nZ2xlIHByZXZlbnRzIGNvbW11bmljYXRpb24uICBTbyBJIHdv
bmRlciB3aHkgLi4uDQo+PiBUaGFuayB5b3Ugc28gbXVjaCBmb3IgdGhlIGRldGFpbGVkIHJldmll
dyBjb21tZW50cy4NCj4+DQo+PiBNeSB1c2UgY2FzZSBmb3IgdGhpcyBmbGFnIG9yaWdpbmF0ZXMg
ZnJvbSBhIGRlcGxveW1lbnQgb2YgU0NUUCBjbGllbnQNCj4+IGVuZHBvaW50cyBvbiBkb2NrZXIv
a3ViZXJuZXRlcyBlbnZpcm9ubWVudHMsIHdoZXJlIHR5cGljYWxseSB0aGVyZSBleGlzdHMNCj4+
IFNOQVQgcnVsZXMgZm9yIHRoZSBlbmRwb2ludHMgb24gZWdyZXNzLiBUaGUgKnVzZXIqIGluIHRo
aXMgY2FzZSBhcmUgdGhlDQo+PiBDTkkgcGx1Z2lucyB0aGF0IGNvbmZpZ3VyZSB0aGUgU05BVCBy
dWxlcywgYW5kIHNvbWUgb2YgdGhlIG1vc3QgY29tbW9uDQo+PiBwbHVnaW5zIHVzZSAtLXJhbmRv
bS1mdWxseSByZWdhcmRsZXNzIG9mIHRoZSBwcm90b2NvbC4NCj4+DQo+PiBDb25zaWRlciBhbiBT
Q1RQIGFzc29jaWF0aW9uIEEgLT4gQiwgd2hpY2ggaGFzIHR3byBwYXRocyB2aWEgTkFUIEEgYW5k
IEINCj4+IEE6IDEuMi4zLjQ6MTIzNDUNCj4+IEI6IDUuNi43LjgvOTo0Mg0KPj4gTkFUIEE6IDEu
Mi4zMS40ICh1c2VkIGZvciBwYXRoIHRvd2FyZHMgNS42LjcuOCkNCj4+IE5BVCBCOiAxLjIuMzIu
NCAodXNlZCBmb3IgcGF0aCB0b3dhcmRzIDUuNi43LjkpDQo+Pg0KPj4gICAgICAgICAgICAgICDi
lIzilIDilIDilIDilIDilIDilIDilIDilJAgICDilIzilIDilIDilIDilJANCj4+ICAgICAgICAg
ICAg4pSM4pSA4pSA4pa6IE5BVCBBIOKUnOKUgOKUgOKUgOKWuiAgIOKUgg0KPj4gIOKUjOKUgOKU
gOKUgOKUgOKUgOKUkCAgIOKUgiAg4pSU4pSA4pSA4pSA4pSA4pSA4pSA4pSA4pSYICAg4pSCICAg
4pSCDQo+PiAg4pSCICBBICDilJzilIDilIDilIDilKQgICAgICAgICAgICAgIOKUgiBCIOKUgg0K
Pj4gIOKUlOKUgOKUgOKUgOKUgOKUgOKUmCAgIOKUgiAg4pSM4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSQICAg4pSCICAg4pSCDQo+PiAgICAgICAgICAgIOKUlOKUgOKUgOKWuiBOQVQgQiDilJzilIDi
lIDilIDilrogICDilIINCj4+ICAgICAgICAgICAgICAg4pSU4pSA4pSA4pSA4pSA4pSA4pSA4pSA
4pSYICAg4pSU4pSA4pSA4pSA4pSYDQo+Pg0KPj4gTGV0IHVzIGFzc3VtZSBpbiBOQVQgQSAoMS4y
LjMxLjQpLCB0aGUgY29ubmVjdGlvbnMgaXMgc2V0dXAgYXMNCj4+IAlPUklHSU5BTCBUVVBMRQkJ
ICAgIFJFUExZIFRVUExFDQo+PiAxLjIuMy40OjEyMzQ1IC0+IDUuNi43Ljg6NDIsIDUuNi43Ljgu
NDIgLT4gMS4yLjMxLjQ6MzMzMzMNCj4+DQo+PiBMZXQgdXMgYXNzdW1lIGluIE5BVCBCICgxLjIu
MzIuNCksIHRoZSBjb25uZWN0aW9ucyBpcyBzZXR1cCBhcw0KPj4gCU9SSUdJTkFMIFRVUExFCQkg
ICAgUkVQTFkgVFVQTEUNCj4+IDEuMi4zLjQ6MTIzNDUgLT4gNS42LjcuOTo0MiwgNS42LjcuOC40
MiAtPiAxLjIuMzIuNDo0NDQ0NA0KPj4NCj4+IFNpbmNlIHRoZSBwb3J0IG51bWJlcnMgYXJlIGRp
ZmZlcmVudCB3aGVuIHZpZXdlZCBmcm9tIEIsIHRoZSBhc3NvY2lhdGlvbg0KPj4gd2lsbCBub3Qg
YmVjb21lIG11bHRpaG9tZWQsIHdpdGggb25seSB0aGUgcHJpbWFyeSBwYXRoIGJlaW5nIGFjdGl2
ZS4NCj4+IE1vcmVvdmVyLCBvbiBhIE5BVC9taWRkbGVib3ggcmVzdGFydCwgd2Ugd2lsbCBlbmQg
dXAgZ2V0dGluZyBuZXcgcG9ydHMuDQo+Pg0KPj4gSSB1bmRlcnN0YW5kIHRoaXMgaXMgYSBwcm9i
bGVtIGluIHRoZSB3YXkgU05BVCBydWxlcyBhcmUgY29uZmlndXJlZCwgbXkNCj4+IHByb3Bvc2Fs
IHdhcyB0byBoYXZlIHRoaXMgZmxhZyBhcyBhIG1lYW5zIG9mIHByZXZlbnRpbmcgc3VjaCBhIHBy
b2JsZW0NCj4+IGV2ZW4gaWYgdGhlIHVzZXIgd2FudGVkIHRvLg0KPiBVZ2gsIHNvcnJ5LCBidXQg
dGhhdCBzb3VuZHMganVzdCB3cm9uZy4NCg0KT2ssIEkgaGVhciB0aGF0LiA6KQ0KDQo+DQo+Pj4+
IEFzIHNwZWNpZmllZCBpbiBSRkM5MjYwIGFsbCB0cmFuc3BvcnQgYWRkcmVzc2VzIHVzZWQgYnkg
YW4gU0NUUCBlbmRwb2ludA0KPj4+PiBNVVNUIHVzZSB0aGUgc2FtZSBwb3J0IG51bWJlciBidXQg
Y2FuIHVzZSBtdWx0aXBsZSBJUCBhZGRyZXNzZXMuIFRoYXQNCj4+Pj4gbWVhbnMgdGhhdCBhbGwg
cGF0aHMgdGFrZW4gd2l0aGluIGFuIFNDVFAgYXNzb2NpYXRpb24gc2hvdWxkIGhhdmUgdGhlDQo+
Pj4+IHNhbWUgcG9ydCBldmVuIGlmIHRoZXkgcGFzcyB0aHJvdWdoIGRpZmZlcmVudCBOQVQvbWlk
ZGxlYm94ZXMgaW4gdGhlDQo+Pj4+IG5ldHdvcmsuDQo+IEhtbSwgSSBkb24ndCB1bmRlcnN0YW5k
IFdIWSB0aGlzIHJlcXVpcmVtZW50IGV4aXN0cywgc2luY2UgZW5kcG9pbnRzDQo+IGNhbm5vdCBj
b250cm9sIHNvdXJjZSBwb3J0IChvciBzb3VyY2UgYWRkcmVzcykgc2VlbiBieSB0aGUgcGVlcjsN
Cj4gTkFUIHdvbid0IGdvIGF3YXkuDQo+DQo+IEkgcmVhZCB0aGF0IHNuaXBwZXQgc2V2ZXJhbCB0
aW1lcyBhbmQgaXRzIG5vdCBjbGVhciB0byBtZSBpZg0KPiAicG9ydCBudW1iZXIiIHJlZmVycyB0
byBzcG9ydCBvciBkcG9ydC4gIERwb3J0IHdvdWxkIG1ha2Ugc2Vuc2UgdG8gbWUsDQo+IGJ1dCBz
cG9ydC4uLj8gIE5vLCBub3QgcmVhbGx5Lg0KDQpJIGFtIGp1c3QgYW4gaW50ZXJwcmV0ZXIgb2Yg
dGhlIHN0YW5kYXJkIGJ1dCBBRkFJVSwgcG9ydCBtZWFucyBib3RoIHNvdXJjZQ0KYW5kIGRlc3Rp
bmF0aW9uIHBvcnQuIFNlY3Rpb24gMS4zIG9mIFJGQyA5MjYwIGRlZmluaW5nIGFuIFNDVFAgZW5k
cG9pbnQuDQpJbiBhbnkgY2FzZSwgcnVubmluZyBTQ1RQIG9uIFVEUCBpcyBwcm9iYWJseSB0aGUg
YmVzdCB3YXkgdG8gd29ya2Fyb3VuZA0KdGhlIFNDVFAgTkFUIHByb2JsZW0uDQoNCj4NCj4gV29u
J3QgdGhlIGVuZHBvaW50cyBub3RpY2UgdGhhdCB0aGUgcGF0aCBpcyBkb3duIGFuZCByZS1jcmVh
dGUgdGhlIGZsb3c/DQo+DQo+IEFGQUlVIHRoZSByb290IGNhdXNlIG9mIHlvdXIgcHJvYmxlbSBp
cyB0aGF0Og0KPiAxLiBOQVQgbWlkZGxlYm94ZXMgcmVtYXAgc291cmNlIHBvcnQgQU5EDQo+IDIu
IE5BVCBtaWRkbGVib3hlcyByZXN0YXJ0IGZyZXF1ZW50bHkNCj4NCj4gLi4uIHNvIGZpeGluZyBl
aXRoZXIgMSBvciAyIHdvdWxkIGF2b2lkIHRoZSBwcm9ibGVtLg0KPg0KPiBJIGRvbid0IHRoaW5r
IGFkZGluZyBzeXNjdGxzIHRvIG92ZXJyaWRlIDEpIGlzIGEgc2FuZSBvcHRpb24uDQoNClllYWgg
dGhlIGVuZHBvaW50cyBkb2VzIHRyeSB0byByZS1jcmVhdGUgdGhlIGZsb3dzLCBidXQgaWYgd2Ug
aGF2ZQ0KbXVsdGlwbGUgbWlkZGxlIGJveGVzIHJlbWFwcGluZyB0aGUgc291cmNlIHBvcnQsIHRo
ZXJlIGlzIG5vIGd1YXJhbnRlZQ0KdGhhdCB0aGV5IHdpbGwgcmVtYXAgdG8gdGhlIHNhbWUgc291
cmNlIHBvcnQuDQoxKSBpcyB0aGUgbWFpbiBwcm9ibGVtIHRoYXQgSSB3YXMgdHJ5aW5nIHRvIGFk
ZHJlc3Mgd2l0aCB0aGlzIHBhdGNoLg0KDQo+PiBTaW5jZSB0aGUgZmxhZyBpcyBvcHRpb25hbCwg
dGhlIGlkZWEgaXMgdG8gZW5hYmxlIGl0IG9ubHkgb24gaG9zdHMgdGhhdA0KPj4gYXJlIHBhcnQg
b2YgZG9ja2VyL2t1YmVybmV0ZXMgZW52aXJvbm1lbnRzIGFuZCB1c2UgTkFUIGluIHRoZWlyIGRh
dGFwYXRoLg0KPiBXZSBjYW4ndCBmaXggdGhlIHJ1bGVzZXQgYnV0IHdlIGNhbiBzb21laG93IGN1
cmUgaXQgdmlhIHN5c2N0bCBpbiBlYWNoIG5ldG5zPw0KPiBJIGRvbid0IGxpa2UgdGhpcy4NCj4N
Cj4gTkFUIG1pZGRsZWJveCByZXN0YXJ0IHdpdGggLS1yYW5kb20gaXMgYSBwcm9ibGVtIGluIGFu
eSBjYXNlLCBub3QganVzdA0KPiBmb3IgU0NUUCwgYmVjYXVzZSB0aGUgY2hvc2VuICJyYW5kb20g
cG9ydCIgaXMgbG9zdC4NCj4NCj4gSSBkb24ndCBzZWUgYSB3YXkgdG8gZml4IHRoaXMsIHVubGVz
cyBOT1QgdXNpbmcgLS1yYW5kb20gbW9kZS4NCj4gSWYgY29ubmVjdGlvbiBpcyBzdWJqZWN0IHRv
IHNlcXVlbmNlIG51bWJlciByZXdyaXRlIChmb3IgdGNwKQ0KPiB0aGUgY29ubmVjdGlvbiB3b24n
dCBzdXJ2aXZlIGVpdGhlciBhcyB0aGUgc2VqYWRqIHN0YXRlIGlzIGxvc3QuDQoNCk9rLCBJIHVu
ZGVyc3RhbmQgeW91ciBwb2ludC4gSSBhZ3JlZSBpdCBkb2Vzbid0IG1ha2Ugc2Vuc2UgdG8gaGF2
ZSBhbg0KYWx0ZXJuYXRpdmUgY29uZmlndXJhdGlvbiBvcHRpb24gdG8gYXZvaWQgdGhpcyBwcm9i
bGVtLiBJIHdpbGwgdHJ5IHRvDQpjb252aW5jZSB0aGUgInVzZXJzIiBpZiAtLXJhbmRvbS1mdWxs
eSBpcyBub3QgdXNlZCBmb3IgU0NUUC4NCg0KDQo=
