Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8F68C433ED
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Apr 2021 02:57:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67D44613AE
	for <netfilter-devel@archiver.kernel.org>; Tue,  6 Apr 2021 02:57:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238929AbhDFC57 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 5 Apr 2021 22:57:59 -0400
Received: from de-smtp-delivery-102.mimecast.com ([194.104.109.102]:39660 "EHLO
        de-smtp-delivery-102.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232555AbhDFC57 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Apr 2021 22:57:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1617677871;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=fwFx/AncqahPyQFWYMX+AF3yUaCyBPe7eqbTvLSx0D0=;
        b=ZVYi1qcLybonT7oFQIqUBxG37/AtIxUaKmDL55LK2t1kHi9CfBOTWRfeJDnmTxv4svgaUx
        F3hFhnbNQ1OjZFVtses4HOxKRbIr3roIWpNtXYny5DPHLK5xtWycbo8gsOAq2TtSBSXs/S
        fDL2ODDIRmWYt+zhBUlTM0YI7jTOJz0=
Received: from EUR04-HE1-obe.outbound.protection.outlook.com
 (mail-he1eur04lp2053.outbound.protection.outlook.com [104.47.13.53]) (Using
 TLS) by relay.mimecast.com with ESMTP id
 de-mta-11-B2Bm7Y7MNjKXB3YBgnMjUQ-1; Tue, 06 Apr 2021 04:57:50 +0200
X-MC-Unique: B2Bm7Y7MNjKXB3YBgnMjUQ-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oZHCCFWG6hwAmMnlHA5i+TTOQSKLlgOyqNXndzmiGtVb+OhMP9pcmxrTbXjvZW1HP/2TiljC6JC+yjF5rj7xcoYFiQxRJ/7hwYvoqK4B9mHOs7NDJ9Kp7ytl4vbS9rFCz2iq50yLdZ288S7ldpzJ0Ef97R2A3TMAmurtEXOpW9TL5sGLAR1RbpClOMr2/B1vG5ZCYwl1oOn2yfBqrve9/AbvIjdPTD3z28WhUO3lTTaLFR6OlNzKEyx/Cofn/Uu58aDbrQq/Yv39Dwsm7FNU8uHrXPkMmgf+LY4nChbKeRL+hnYKKaLx4nE9rGJTZTYkPw8BI+UMq1JtHdqbFnKR/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fwFx/AncqahPyQFWYMX+AF3yUaCyBPe7eqbTvLSx0D0=;
 b=VwyVbSd6n9dPPH6l2b2AmTwc4aIJypoY5gFVEC90neh1qG9itxmOKZE7q31EiimrBmD2r/rUhB28n72ViUcI/RSLYMlOrHcE26kuaobCKLQVh1O4nLXJ949F8roG40YVXwWjR4INWaCpZ52PrhCUzTI3JR/nngaR7PKNhTYDfN8oGYgGqOJ6PfbwH9AkzQyfRYfzEiDQiZRWiS1w5zrOpyUEADOfWReK2EQHdSnklxX93eZlZHOUvlqibvcSnNuJAMbKqoKz87Q6Gz63l9tqp5uke/xMgVk7onI4L38m0Xo/PeLyG8zu/S2MgfSP3KpXc/LbVphLOB5xYT54ZErDYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: netfilter.org; dkim=none (message not signed)
 header.d=none;netfilter.org; dmarc=none action=none header.from=suse.com;
Received: from VI1PR04MB5584.eurprd04.prod.outlook.com (2603:10a6:803:d5::10)
 by VI1PR04MB6815.eurprd04.prod.outlook.com (2603:10a6:803:130::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.28; Tue, 6 Apr
 2021 02:57:48 +0000
Received: from VI1PR04MB5584.eurprd04.prod.outlook.com
 ([fe80::61e0:5f2b:1f3:d0eb]) by VI1PR04MB5584.eurprd04.prod.outlook.com
 ([fe80::61e0:5f2b:1f3:d0eb%7]) with mapi id 15.20.3999.032; Tue, 6 Apr 2021
 02:57:47 +0000
Date:   Tue, 6 Apr 2021 10:57:37 +0800
From:   Firo Yang <firo.yang@suse.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, simonf.lees@suse.com
Subject: Re: [PATCH 1/2] ebtables: processing '--concurrent' beofore other
 arguments
Message-ID: <20210406025737.2jws5uuqz6ozncun@suse.com>
References: <20210401040741.15672-1-firo.yang@suse.com>
 <20210401040741.15672-2-firo.yang@suse.com>
 <20210403181517.GA4624@salvia>
 <20210403182204.GA5182@salvia>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210403182204.GA5182@salvia>
X-Originating-IP: [103.43.85.196]
X-ClientProxiedBy: HKAPR04CA0008.apcprd04.prod.outlook.com
 (2603:1096:203:d0::18) To VI1PR04MB5584.eurprd04.prod.outlook.com
 (2603:10a6:803:d5::10)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from suse.com (103.43.85.196) by HKAPR04CA0008.apcprd04.prod.outlook.com (2603:1096:203:d0::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.26 via Frontend Transport; Tue, 6 Apr 2021 02:57:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2fbd54c6-51b1-4506-162a-08d8f8a7c22c
X-MS-TrafficTypeDiagnostic: VI1PR04MB6815:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <VI1PR04MB6815436173D619A22F833D3988769@VI1PR04MB6815.eurprd04.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Pz99CyBylgaOfarl9PR5dS5fb6ipBuw0g5jDp9A7Jgn8LyTCHnS1X33du5zgEBmxsrMiSHyzWiuuonjEz3otGUiLMEDe+11qld7G4Zbb6eBfNO1wZ69JaSW70YdzRHP1S0/d8eRrqV0GpU1umrCCYcXBmU3a9vvrnpAzK+wsD8ee/Zf4wASBf9As5SM1C6OS1EqnIZ1ckovQo3EjuQgg7DHLxN6d5bhI3dChzS3QlTuFqWX4NgwT/Jzy+WkG6KWcUPhPaRDPV1mvFZMlRyFNp3hQMr0PMzrygds4cBrhbNq2twYxZSOSK1brsm17AgDw6BrJvJ1cML4BMfBOcIMo3XqYIRYnJJIYCI7sbq5DOVft8lg8718hTDb7v0vF0guSnLGs3Bk4cpFhfneUvoZuAcCjvIlvC7a+CYaGMPYIxxa+Uqw9MsLGzfWpxMwho+y3dxZRtZlL/aKcVzFd7p6QfGTYh8T03Q8lXIKbbSIrmW1QXv1bDQZyPB6ac0ZMYpaBPLz7rHlO/Ro0709ICAv3mYuWrFJisWbCWxhvFhuPUA7vhBBZ/8avvOM7x8/kX0hohvOMcKs4srKWIEDXqnkYRqJ7EN94I1Ye6/odTkV5ki1rPZdFhsfgmwIkFzI+m8fYRI3krNJPUjvU0fcZNeNFDS0Cdtbey6Y4i3RhUHvCWQ8UFAEaaWhEkSpeswGRaJAM
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:VI1PR04MB5584.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(39860400002)(346002)(136003)(376002)(107886003)(4326008)(956004)(2616005)(8676002)(44832011)(478600001)(1076003)(6916009)(86362001)(316002)(26005)(7696005)(55016002)(5660300002)(16526019)(36756003)(52116002)(6666004)(66556008)(66946007)(2906002)(38100700001)(8886007)(83380400001)(8936002)(186003)(66476007)(38350700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VXFCbERRcnRyUWMwL1BoNEZxR3c0RThZODFRMlB2VlA4OGFWOUdCWmpIalc2?=
 =?utf-8?B?dVhOK3FZTlFRbXRONVV6c2RPU0xJbmlaVlF2cXM0bW5DYmhjZlJKM2xkTGpp?=
 =?utf-8?B?US8yMCs4N1JpVk9Na3RpZ1prUGN3U3Vtc0d4dGZlb2F1RmZ3ZDJXTTNzRnNV?=
 =?utf-8?B?akg5UTd5ODhORUJMdG9TVmE1blZqUHFMNHlXN3hoNWNrODlUZCtCMG5JUDlq?=
 =?utf-8?B?Ym8zRHRnaHI4ZUpZanBGQXJTRnNTcC9lZzdLQ2FJL04yZGE3QldMT3BFTTZZ?=
 =?utf-8?B?dS81ek1VbjdkMVQyNzVKdUlSeWc1bWlmSHhqdG9CazlzQU9CVXJqOVJVQUpn?=
 =?utf-8?B?eThrSys1SEJtUjl3R1NMVkRJbEN1YXZrRURieE9aQkRjSCtSaElrOFVhN29v?=
 =?utf-8?B?bXprN2VyTDZ1NjVDUnRwZnZ2alVtZ1pOMzNGQi9DZEJvNDRqUTkxM1U2T3R0?=
 =?utf-8?B?Ykp1YmR6RjR3aTBBY0JsQXNqbVBWVS9OcHlDS05mSE5oVjJqcDJ1V2RFejcv?=
 =?utf-8?B?NTJxSHhaZjY1blMyZWs1cXpDUUEwTlBKTU5GZm15eVpNbVo1VVNOZ2NKSlZ3?=
 =?utf-8?B?Ni9mUjdFei9TdlNVUFllNnVLV0pKeEVXSzRFNlFSclNnUkdhOUZ3TUFTRmRI?=
 =?utf-8?B?L0JPK3A4SzBEUVJZSlZXL1pwTlozR1h3SkFrYUwwd0EycmlhTW41Y2RnL1Bq?=
 =?utf-8?B?eCtVMHpJMWlITXVhVkNzUGRwek9NY2F4US96a0lCSVlBdHNuUEw3OHk5Q3pI?=
 =?utf-8?B?c0I4Z3V1dWRBUkx6V2w2SmkyRWt5aTBiODNOcEdoNlM3VHlGbWMvVys0RUZB?=
 =?utf-8?B?V3k3RUN3VUNBZmo3WW0yR1Jja1JaUWVqcFNEall2NFFWeGNObnBPSmNidisv?=
 =?utf-8?B?bmxqZ05RY1FtRW1NTk9GSmdlbDZkdnN4cmNtRWU5d2gxODRiaEFtY1hjSVZP?=
 =?utf-8?B?dHNvUXorQURHandkSUlzZWljaktpVXJES0hqNEcvRjlMRXBIS0NrQ25zZUJl?=
 =?utf-8?B?M1NaVSs2NElhN2o0ZmxrTkd5THNhTGtPZEVvQVIzalo4NnpJdUNkdXhIUk5C?=
 =?utf-8?B?VDFFVUNXTkZVRG5uQmZPTWR4TUdGRmk0WW1za1cwTVVCanJ1OGpmUGlySXBY?=
 =?utf-8?B?M2UyUG9Lb2dvTGFkbDZPNURySmMvL01VR1RwQWovL2xlRjBvenY1TTkzR1hq?=
 =?utf-8?B?bkRJeDZ0YTZNbjhTejJvNVhjUTFmdDI5d3pnMVZIaU1aOHd0ZkF6RmtWem8v?=
 =?utf-8?B?UEZsSmdlNndyeUVHZTBMSlhXb1IrdXNnWENKTnRPNkFUMWpqelBxYUdPOWpB?=
 =?utf-8?B?UGJURlJhWnU3UkJPMXJxSVZzTytTTXNVbmU2eW9BUDEwRjRJeXJVYitBeU1X?=
 =?utf-8?B?TFV2RUZiNUpBUlEzRE9Zc0Y5a1hkZURSS1hEM0tES1REK2hGTWltejhja3RM?=
 =?utf-8?B?TXIxbzVYdk8zY2JXSmxJZlBSV1I0L2dpZGk3MlNoY0JIYmZZOTBhNjZuZTJH?=
 =?utf-8?B?UUZHWC9xdDNuRWZZM3hiY0hYOExrcldpUFVhZmJaWWs5aktkcW95OVlxekRR?=
 =?utf-8?B?RC94V2ZhNWNKaTR3dExXL1F6ZDA3YnRuRWVDWmEveEFmUFNmT3RrMG5EUHhC?=
 =?utf-8?B?SDBDa3NtQ0tTVTdYckU2T0JiU0pEa1lpYWRjeDYvdFd5TTRWN3dsaTBQdkxE?=
 =?utf-8?B?MmEyNklCRytORStHQzJmMXdWVXFma0M3RWcvcjhwVktBWXNqa016QnZTVGJJ?=
 =?utf-8?Q?DBoDYUIv8XHke0zyRRYRiXUpvOYg5o97GuRVfwy?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2fbd54c6-51b1-4506-162a-08d8f8a7c22c
X-MS-Exchange-CrossTenant-AuthSource: VI1PR04MB5584.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Apr 2021 02:57:47.8118
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IKQMr2wR4nmuXcdISxaO/n1nFp7FXeUF1QS1N6XyFs7O7oNumAe0cIk3m4IvLAyRS2WEx/Nc6DN7EGn1T/uH0A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR04MB6815
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

The 04/03/2021 20:22, Pablo Neira Ayuso wrote:
> On Sat, Apr 03, 2021 at 08:15:17PM +0200, Pablo Neira Ayuso wrote:
> > Hi,
> > 
> > On Thu, Apr 01, 2021 at 12:07:40PM +0800, Firo Yang wrote:
> > > Our customer reported a following issue:
> > > If '--concurrent' was passed to ebtables command behind other arguments,
> > > '--concurrent' will not take effect sometimes; for a simple example,
> > > ebtables -L --concurrent. This is becuase the handling of '--concurrent'
> > > is implemented in a passing-order-dependent way.
> > > 
> > > So we can fix this problem by processing it before other arguments.
> > 
> > Would you instead make a patch to spew an error if --concurrent is the
> > first argument?
> 
> Wrong wording:
> 
> Would you instead make a patch to spew an error if --concurrent is
> _not_ the first argument?

Hi Pablo, I think it would make more sense if we don't introduce this
inconvenice to users. If you insist, I would go create the patch as you
intended.

--
Firo

> 
> > --concurrent has never worked unless you place it in first place
> > anyway.
> 

