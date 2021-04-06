Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7DA6C433ED
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Apr 2021 11:56:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64A23613B8
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Apr 2021 11:56:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343608AbhDFL5C (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 6 Apr 2021 07:57:02 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:38589 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1343537AbhDFL5B (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Apr 2021 07:57:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617710212;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=rLVC5OmO5p8HHTMdW2AomKqg0TGsQoT1kWiYm4rR1dQ=;
        b=OfJyoKgfA3jTBVhZhRB8OHaJZ/C542dMRBN1HGbHj/GgflVV/l4jK7p8BY9Z9R5a0qBG5E
        bvlFBwekVI0KiQ8IiBFBAc/JA/wLHRwrKh0vMbZxYIRKF+RVZTmlJ5CA+wNknRiYFXrutl
        0MpY/33hK2QQ2ZdskV9EzVmjsdCSVYU=
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05lp2108.outbound.protection.outlook.com [104.47.17.108])
 (Using TLS) by relay.mimecast.com with ESMTP id
 de-mta-39-jPQ3-AjBO_aoORc0pX6MBg-1; Tue, 06 Apr 2021 13:56:41 +0200
X-MC-Unique: jPQ3-AjBO_aoORc0pX6MBg-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jECLL6rQ2OnZeOkStcKwuzMItt/Ox510V5SqyMcZZxRFHw4uj96sLTY2NtDqY8RA8NL1hv1oty0S9benSG5JmDUJHmeb0cOYSXtXItgjdF9CuJB7ifKTZujadUoYfqmoShF+blgHIX/lgHPK48U6ME+K+8ogXkxR2ucKzguQHs2x1p2Qr2kes4snLSaFlCPGc3kZggXpPKurc2+W239GmV+0v1YJZVu38nEy06YkrsPOktXWvHNuyx99iV5SbTGPIrlamIc0GixcR7iQ6+sk0oNCWzmfOlwglNJaeRFHfW+XPSy1u3DnbskxaUJxnHyPTvDdBFla5YpAxjn34N6PCg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rLVC5OmO5p8HHTMdW2AomKqg0TGsQoT1kWiYm4rR1dQ=;
 b=WqCEQWrd0GMv8iuCayKk4ytuPgjnW1v8Qg+2wxb9kSVrH3EwA0OtwTeXK97LxDhQ7jgRXajR5Q8fVlDmZJsSpcTm+I+gsKzxdaBVb4MIRWgm3/xOfL4kjh62JKVn0/ynEbAkn6MgW1zHJROsSx5oUIPJcKxtNaBPB+tB/L5sWL2pOammcUQYf/wqq9W9zPQnzoqdZiI7lQU5W1i6WKlSOinhbviavz5/kaO50DBUYLEYyzCkqEAGTgdqsJpCea8mthXXwPJuOxZwB5Ca+tcLWb5NQwJo5VVTd4VjjnYJzTP7wy8GcbaXYYPMGboVPrHoOkRqnaDTK74GnikUMTT4PA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: netfilter.org; dkim=none (message not signed)
 header.d=none;netfilter.org; dmarc=none action=none header.from=suse.com;
Received: from AM0PR04MB5569.eurprd04.prod.outlook.com (2603:10a6:208:115::28)
 by AM0PR04MB5892.eurprd04.prod.outlook.com (2603:10a6:208:133::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Tue, 6 Apr
 2021 11:56:40 +0000
Received: from AM0PR04MB5569.eurprd04.prod.outlook.com
 ([fe80::c080:3bf5:620:c0f6]) by AM0PR04MB5569.eurprd04.prod.outlook.com
 ([fe80::c080:3bf5:620:c0f6%5]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 11:56:40 +0000
Date:   Tue, 6 Apr 2021 19:56:29 +0800
From:   Firo Yang <firo.yang@suse.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Simon Lees <sflees@suse.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        Simon Lees <SimonF.Lees@suse.com>
Subject: Re: [PATCH 1/2] ebtables: processing '--concurrent' beofore other
 arguments
Message-ID: <20210406115629.b3wh25k2ulptuifa@suse.com>
References: <20210401040741.15672-1-firo.yang@suse.com>
 <20210401040741.15672-2-firo.yang@suse.com>
 <20210403181517.GA4624@salvia>
 <20210403182204.GA5182@salvia>
 <6cc20464d5814fe899d7fb1e21d5488c@DB8PR04MB5881.eurprd04.prod.outlook.com>
 <f5efb453-0197-658c-1886-a4d88fc3b193@suse.de>
 <64466cd69b054f5d803722dfbcf8c4be@DB8PR04MB5881.eurprd04.prod.outlook.com>
 <d135ba6e-aa30-9a1d-136c-56a96aa10da6@suse.de>
 <20210406113111.GA17543@salvia>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210406113111.GA17543@salvia>
X-Originating-IP: [36.130.191.126]
X-ClientProxiedBy: HK2PR02CA0174.apcprd02.prod.outlook.com
 (2603:1096:201:1f::34) To AM0PR04MB5569.eurprd04.prod.outlook.com
 (2603:10a6:208:115::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from suse.com (36.130.191.126) by HK2PR02CA0174.apcprd02.prod.outlook.com (2603:1096:201:1f::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28 via Frontend Transport; Tue, 6 Apr 2021 11:56:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d0d1eaf3-866a-4f83-119d-08d8f8f309c9
X-MS-TrafficTypeDiagnostic: AM0PR04MB5892:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <AM0PR04MB5892C7B08FB990708D59C86288769@AM0PR04MB5892.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3L5Eh4SveUJthcdCf1HpIA9uit2zsdACi7O4Q7XrYpRRnHweE6h3KPp0muzfuBK6ofQCU5w++vcv9MKRWHaba/MYNqF6OrioH83L38/CpBpeZ5FYcefO+hWYHqujFExD4ivQgXVDTmjO9uRdPjAi0TbyftfFntBGZNVZ9WCopQh+6k9J4ZLtIQUF2bFVNH4mVwJ4vb0VkFJOSMqvL7yUdbPn1oCLs4Pd+nCavfO/DOhJ7Fg+I7taIVRrotkwcwQ63mvH6VD3XBVao9zoUL4cYwgGkFT0zl2d/kvOKPPGkmuBTSPx7FEqqFWyvRfu2Pha7MfQfhlV/Vj3BDZHKpIHhMlQnmQ0LZ+HbHhUqgwr/7u2e448AbQayL8Kbpyv7FCFl4JX9zffmHZQG8PRUlaUnC+uVIw7xfavTBciIjEX7csYGU9j5auTjlBTSjN6Y4OiHqQ97EfNgclHz/B+9dbSv0kmERgoql7UrGPk/ER3andj7h7EaNzQsgXrEs1skpy7svRWyRSbRtizc0DP/rz1J7duJaAKCA2/X1FnBTrLVNFqL19DxcMDV0H+Xxx9Oh3hGDNGTa3ZOA9OghyB4UXqVVUp64CPh4cHobk8MedpDihecqt5YWMOMxi2pkTOZSLrO5Ws7PiKNmJOlVv8zWtN91GOdFzOkw1sK9Tuuay+sTfrvKF5sHv0kYgswm8b3ymJ
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM0PR04MB5569.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(346002)(39860400002)(136003)(376002)(55016002)(186003)(26005)(52116002)(7696005)(44832011)(6666004)(478600001)(8936002)(5660300002)(16526019)(107886003)(38350700001)(38100700001)(1076003)(83380400001)(66476007)(66556008)(956004)(2616005)(2906002)(8886007)(86362001)(66946007)(316002)(54906003)(6916009)(36756003)(53546011)(8676002)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VUp6SUtYZ1pEbkg1ZW5jRitiRTJkTXZlTUtnRGFtSHZLSWM3Z3dIYUttdEg2?=
 =?utf-8?B?cGl3NkRFek1VMENPenJRcytaR1pleTc5STVmaUhxWXltSkFpbnlIM1d0SE5B?=
 =?utf-8?B?dVA5ZFdZK1Y1cHNxT3pjZmxQUUpaYTloWnZBaHNwRHlJKzVuRFp5QzlWTDdX?=
 =?utf-8?B?WVQ2aEFaTDFIalhwSUJSdmp4K3czR1lJR1RlbC9paThZd054TmJybDNFUEJz?=
 =?utf-8?B?NGkzMW95dWpxekN5d203dGFza2U5Mkt1T21RcXg5UUdLNTIwYUtlblVYRnU3?=
 =?utf-8?B?VDZaZEI1MGkzb1pCUUVWT0tVZjl2K3VUaTR5R05tbmtYcnphUGdJY2pvb3Bp?=
 =?utf-8?B?UUFKSnRRWUw5ZHkrVmV1RFpuTE9uS1djZzc1YndwUllLRzJ2NTY3V0VmMUdN?=
 =?utf-8?B?ajZxN1dqd054ZEorTmtMeEdqSFVxemJLN2NRbGxQNjFpMExYVXpoVG4xMnRZ?=
 =?utf-8?B?Qmh2QlJoaDZUL1JiRnpWQVlYZmdZalFLYktpNzhEK0g5d1NIUkl6UWdsbk9p?=
 =?utf-8?B?RGp1VFhaczZ6ZHBudHhJMlRqQ2t6QzdBdDlaL0g3eStTeGVvbXRmbUp0Q1NP?=
 =?utf-8?B?Y2VzK1RzVnJBemtlRDI5QnV4S2RXcElhcFVCeUZrajV4a2tISWdCbUpBV2Fw?=
 =?utf-8?B?RHdNdjh4R0hPblJCK1owNTFBUHZwbUdXTHUraVZ2Y2ZLZ0dZTFVIcFhFQWxo?=
 =?utf-8?B?ZFZIQmpxS0pzUnlkTW1uM3d5cFRCMWdFc0ZjdzBkcE9YT0RVYk9RQnoyRkRJ?=
 =?utf-8?B?WlB6aVcxM3JCaGFLS3ZBeDVyeCtaak5jeGJqV0twYnhUQ2NDSGNMQm40dTFQ?=
 =?utf-8?B?MDY3Z095eS9pUkoxZ2Z4WkNvc3B0TUNWRG1zN3dNWjNrelp0bkpHKzVpRnBm?=
 =?utf-8?B?bHV2S1VLdXovM0NXYkpYWTV2eCs2dE1Za3pEM3h4U01zUjVGRnNEQ2xoNUxY?=
 =?utf-8?B?cDFZVzN0Q0lna1p2SWdRbExNbDJ0eG5zV0h5OThxZEdJcU5CRUNwdWlTTTNr?=
 =?utf-8?B?dy8wZ29BMzZJZ2Nxdk44eTdOR1owU21RS2xKVGZjb2ZhbUlmRHNxMURjRnUr?=
 =?utf-8?B?VmV5bXN3V0xYZmZkaVF6NWlzTjlzS1BJR1krdE1oWGd0VGZtN1pOL1k2Y29D?=
 =?utf-8?B?TUtPcWNHU1hLMEZkaWxJdXBuRURtQ24zT2JESC9pOEMzdm5aYmNUbXZMTXpZ?=
 =?utf-8?B?S0dnQnc0OUV3UllNN3ZqUmE0b0t6ZWdDeGhsZSs1SUE0NzREQisyNWVla3pn?=
 =?utf-8?B?RlJLSGJMUVIrSytmazFRVTlTTXBJZ2tHTnB0WmVRSTdDKytMM0VWcU9DektQ?=
 =?utf-8?B?WW1BdmZvMDZGeUdiNHNudzJ1aHJKK2FCZ3Q1RFZYeEY5K2V4QzBwK1pZcEFP?=
 =?utf-8?B?TFAxeHBuN1FnOUdKMG5ka2dUOGZ1eXh2SFUxYmMveWJzdmFJcUpWWlE0cEtX?=
 =?utf-8?B?ZDJoZDEwWDJza1lkUzEvR1RPRVByZ2lSV2ltMWp3VUdIWFI0Nnhyc3JSQ3FH?=
 =?utf-8?B?dFIxckxocEVpOGcxQ3hDWUJuUmx1QVh4RC9kSEVyTFRueVNYM2VWUlJ5U3Nu?=
 =?utf-8?B?Sy9TVkZIWm1ZVklWVVdVRStFL1dMSlZRS2VERkhueUpxS2NNb21kYVEyZzl6?=
 =?utf-8?B?OFpWekg5bG5ZK0lMTGlUalBYb09RSlppWHlZTm9pUWVYV0dXMys2WjVnRzlF?=
 =?utf-8?B?NkhuVXMxT3dwbzlEUkJWTW5VU1hrQWJTOUhWbCtNQnZVRThYZHpTb3V1V1ZZ?=
 =?utf-8?Q?U7hYp/lmXbwpEWiwz2zzFBEmAdALnn+7/cXuvMO?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0d1eaf3-866a-4f83-119d-08d8f8f309c9
X-MS-Exchange-CrossTenant-AuthSource: AM0PR04MB5569.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 11:56:40.1086
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8Nz/VLzZg2otp1+nRrwA+7YChOgVrAZOyFZr8R7zYlY5eMNkmjMPKA8fTJrAzqDAC+eWlasoIVzJY9sA9gzGXw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR04MB5892
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The 04/06/2021 13:31, Pablo Neira Ayuso wrote:
> On Tue, Apr 06, 2021 at 08:51:30PM +0930, Simon Lees wrote:
> > 
> > 
> > On 4/6/21 7:22 PM, Pablo Neira Ayuso wrote:
> > > Hi,
> > > 
> > > On Tue, Apr 06, 2021 at 05:29:11PM +0930, Simon Lees wrote:
> > >>
> > >>
> > >> On 4/6/21 12:27 PM, Firo Yang wrote:
> > >>> The 04/03/2021 20:22, Pablo Neira Ayuso wrote:
> > >>>> On Sat, Apr 03, 2021 at 08:15:17PM +0200, Pablo Neira Ayuso wrote:
> > >>>>> Hi,
> > >>>>>
> > >>>>> On Thu, Apr 01, 2021 at 12:07:40PM +0800, Firo Yang wrote:
> > >>>>>> Our customer reported a following issue:
> > >>>>>> If '--concurrent' was passed to ebtables command behind other arguments,
> > >>>>>> '--concurrent' will not take effect sometimes; for a simple example,
> > >>>>>> ebtables -L --concurrent. This is becuase the handling of '--concurrent'
> > >>>>>> is implemented in a passing-order-dependent way.
> > >>>>>>
> > >>>>>> So we can fix this problem by processing it before other arguments.
> > >>>>>
> > >>>>> Would you instead make a patch to spew an error if --concurrent is the
> > >>>>> first argument?
> > >>>>
> > >>>> Wrong wording:
> > >>>>
> > >>>> Would you instead make a patch to spew an error if --concurrent is
> > >>>> _not_ the first argument?
> > >>>
> > >>> Hi Pablo, I think it would make more sense if we don't introduce this
> > >>> inconvenice to users. If you insist, I would go create the patch as you
> > >>> intended.
> > >>
> > >> Agreed, that also wouldn't be seen as a workable solution for us "SUSE"
> > >> as our customers who may have scripts or documented processes where
> > >> --concurrent is not first and such a change would be considered a
> > >> "Change in behavior" as such we can't ship it in a bugfix or minor
> > >> version update, only in the next major update and we don't know when
> > >> that will be yet.
> > >>
> > >> Sure this is probably only a issue for enterprise distro's but such a
> > >> change would likely inconvenience other users as well.
> > > 
> > > --concurrent has never worked away from the early positions ever.
> > > 
> > > What's the issue?
> > 
> > We had a customer complaining about the change in ordering causing
> > different results with one way working and the other not, looking back
> > at the report a second time I don't think they were ever using the "non
> > working way" in production but just to debug the other issue.
> 
> Thanks for explaining, then I think we can go for the "restrict
> position" fix which aligns with the -M, -t, ..., correct?

Hi Pablo,

To be frank, I think the 'restrict position' manner is really
unfriendly to users, which put burden on them to learn and remember this kind 
of rare and unique usage. I could create a bigger patch to change other
arugments '-M', '-t' along with '--concurrent'. Does this sound good to
you?

--
Firo

