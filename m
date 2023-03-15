Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CCA9EC61DA4
	for <netfilter-devel@archiver.kernel.org>; Wed, 15 Mar 2023 12:11:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbjCOML4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 15 Mar 2023 08:11:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjCOMLz (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 15 Mar 2023 08:11:55 -0400
Received: from EUR05-DB8-obe.outbound.protection.outlook.com (mail-db8eur05on2131.outbound.protection.outlook.com [40.107.20.131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 760708090C
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Mar 2023 05:11:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MdEbJ0CkVTLCqOlSTSWNC6gxIQgHH2XTXzy50wYYoBihqbE0KYAujkVadu9+e2aWoF8Qo/z3NLlGBH8fXnGZcCeJFFY+u6IQTJRIHG2wnsPZSTCZy/mBCIu4Cb47AfuSyleJs9ULwm8cuFwEkId/BhnNxSqv6w+OCpyvRE8wexCxRp5EtmrLIHGJzSag0NZkDyuzXClzz/nfYPwUOfgIeSqVRElS4J90XTbTyYwf8p0K+oSlqrER/Fo+0xnPAt2IpL5p5QTG2iUnBcN1xMKyqcJIg7/+vt9TB1xzyeBuyi6xAdqtG3Fregx/5FASwbpAfAOZGibAwWPKOiummarsLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ax1QsPlueQor4jhpsBoP7rHiIHiEEJPpga5cHGDt3/8=;
 b=dqMrMUX4lvH5AkthL8PUul0P/oezU4YcULIg/V43/jghlpwS66l2/sGs9e4VE/5UbFXThoK852BMhDvYDBHY3XM6tQp5p6dgvzPdqDPaY1mRCMqzMt6/vqHN98GDincgqsZ177WTolIHGlVOBFc97If2sHkEZRfrVXCD6INFBHy07YAOaDqVNY+NQCZbLMvW6M3/i6yHp7EPx/w5vvpDPXIPotHzbGLoOtppn1jsnTcsiaMWb0wGTiRcTKpZBy3E2pugRThX2/qjG8rWWg1mkiPp7Xj8Otp++w9oORYhdMFXZZOLBxzd4uQsfO+DCVfsNc00D01aw7eemkjmGlYtQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=voleatech.de; dmarc=pass action=none header.from=voleatech.de;
 dkim=pass header.d=voleatech.de; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=voleatech.de;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ax1QsPlueQor4jhpsBoP7rHiIHiEEJPpga5cHGDt3/8=;
 b=RG3sXnvRbFFe89UHNdTHVmIbCeYmlu4GCFM/hCdgpMPx/dEr3YKuzxBDEarlwbYv8odGtjmwOnWMejxuqhNA4ngYMgzOIfji9H6v1VLtwIX0G9dTQlVMbBlsV8FSUlAoF2CzGWKoskedr4LqkK7ZMBd/1ADU+gO3Wr9m/AQHGTE=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=voleatech.de;
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com (2603:10a6:20b:438::20)
 by DU0PR05MB10122.eurprd05.prod.outlook.com (2603:10a6:10:441::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.26; Wed, 15 Mar
 2023 12:11:52 +0000
Received: from AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::3fdc:3007:ffee:3c4d]) by AM9PR05MB8857.eurprd05.prod.outlook.com
 ([fe80::3fdc:3007:ffee:3c4d%8]) with mapi id 15.20.6178.029; Wed, 15 Mar 2023
 12:11:52 +0000
Date:   Wed, 15 Mar 2023 13:11:48 +0100
From:   Sven Auhagen <sven.auhagen@voleatech.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, abdelrahmanhesham94@gmail.com,
        ja@ssi.bg
Subject: Re: [PATCH v4] netfilter: nf_flow_table: count offloaded flows
Message-ID: <20230315121148.44yniy3ulkif42be@SvensMacbookPro.hq.voleatech.com>
References: <20230228101413.tcmse45valxojb2u@SvensMacbookPro.hq.voleatech.com>
 <ZBGugrmYyUeyTLqr@salvia>
 <20230315114533.p5nrnjimlg2jktpe@SvensMacbookPro.hq.voleatech.com>
 <ZBG0qQV7uvj26ReX@salvia>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBG0qQV7uvj26ReX@salvia>
X-ClientProxiedBy: FR3P281CA0090.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:1f::6) To AM9PR05MB8857.eurprd05.prod.outlook.com
 (2603:10a6:20b:438::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: AM9PR05MB8857:EE_|DU0PR05MB10122:EE_
X-MS-Office365-Filtering-Correlation-Id: 808933e9-a30f-498f-6a8b-08db254e75d2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 00JA0UWJji1iaxXrpugVPoX9fMEupxhTxnEdMed+ubbbjqGAGRf5r7iLbXI5mmXol/n3ANOoHYmToLAtnq+vOgJCG5j9/deepqCYBLMxc9giwdROt0VbVT4yJTwti1VtqdnMK5QFl/RPrz6y/hXkXhLXPKapPOSR3q9h/l0m0b3W7embutEMrYeZ5L53yk3dDZiwAzpeh3dgQZ0O1YON9BB3ZkoVsazubkozj/1KCH24YsLvfA5hp/Y2wzEL8xirqmVgTEQ19dUIyDIAGS7vwARcb9jEW8TIBkctjzr8tEJcosCzKRPGegBYfcFw40W72/efLkWdxMGI3gXRI4/lT8FvdXIq5Ty4LonSOkNeGbsf+T8j8YHVNHHwkmgZCHR1ratbwiz4w4/Q0az77vi4+8+cTLhXlvofrK0glS85Tz1SKtuMss2u/eHVSJ8vtak7C3f3GwGn7a9WZQyQo+5KUnUFe5o3+Um3CR0ow1XyH2FaOX6W3T3JPbwhy2prte4d66mLjOvzz+3jPcou+FYiMt4pxrJU1Ym9jsniBffnqxId2r8IaU51w4Jv5OooDPWUI7qId1H3oU6wU5HHnwqVWNFlT9YjY0gy3wJ9eofPFvEBHI/6Oq1xiW9/CN1Ob26y97cNVJt86PJdMzDJV4OdAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:AM9PR05MB8857.eurprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(4636009)(366004)(396003)(376002)(346002)(136003)(39840400004)(451199018)(41300700001)(8936002)(5660300002)(44832011)(2906002)(86362001)(38100700002)(478600001)(66556008)(8676002)(6486002)(66476007)(6666004)(6916009)(66946007)(4326008)(83380400001)(316002)(1076003)(9686003)(26005)(186003)(6512007)(6506007);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?jKDy/46PsLP5tcIzdT+ACvgLPQAQag07G0gfznLm4tmUDBZlRnGDc4x9oS8O?=
 =?us-ascii?Q?Eo4MWuRcJYJO8lUW23z57PpHYXhmbUkms32oyxu1lnLevlIp3Bvc6XhrrNix?=
 =?us-ascii?Q?f1HO6M9JvCIfSDYJEpU0jAFFL/Z+28+7ed0SV6hA9sAEnfxwJj1aSD3pKXGC?=
 =?us-ascii?Q?viPCKxLA5J9An8ZAZVIPJ0cF4ZanMFUcJbNntf7mUKobbI/ch+scaKoFhnim?=
 =?us-ascii?Q?7JqzlODV7O4VHfLsdDeYLQEiHWfE6Yg9roDtMRFFKUyxlLwTGsu1mvN0608n?=
 =?us-ascii?Q?e7Jk1FLn8BVGdziHXuPTnqp/BG6P3iAcYcp1yrxfUQ3SCm/YLD3DIwklqTjV?=
 =?us-ascii?Q?0viT41pb82FlchqadVVl9QpOsfEIcaawXW2z0zi2XHlrhbgfFlZDXdg25Xwn?=
 =?us-ascii?Q?wjba3SNPJrVSw4qb55YlGqAtFhU2OBCLJLBr34E5YpiwuvsLX1CC5kIB3b/D?=
 =?us-ascii?Q?NY+Yl9CRuv4k1SeePjWCN3ZFzkZgSKW12GotW7bkn5BpgkRDHAyD9GWG6ZTk?=
 =?us-ascii?Q?BnRLTkk6KrX9Y0wylUXghAhpCceSa+vdE+xFwuoUNxAKPvunnTFDqADzoKen?=
 =?us-ascii?Q?eZ+VXK9p1MStaom0JsEyZfKV3FKQjcqTPJR1XWYhBKu/VNFB/4VMAMc+VRZl?=
 =?us-ascii?Q?S0Jrsw3SrrNMaYH10JcPP3rirNzWRjqibDbFaOOPKPI7ODT7Dw7E0/wyDxQc?=
 =?us-ascii?Q?sEjgkvI54MCdfGWqac/UsXNGKqE08NL1e1/kZN4LQ6gsB7Hx7eZjFLzA48Pf?=
 =?us-ascii?Q?dN17oMhUm8V99OAUaK0eSOmVFQRmyWU5JfZG4nwidSLa8HqFg+G1esuGA7nN?=
 =?us-ascii?Q?p8phVgMnc033jt/6LTDly44uDhKQQWOziNVuyeOFpCGgy4iOq3VFG4D0Nza/?=
 =?us-ascii?Q?J87pPIwuzCMs2OCXuDcucFzkd7zMI7bkjU+TElDP16oDNK/QhMbNhfUtRWvh?=
 =?us-ascii?Q?GCm+FHxrgY7/kJE1rlTGtOc5gehgRjtKhpktRm0fqFm9diCLMaaXw3pxE/Nm?=
 =?us-ascii?Q?f1cScZ3sJC6gOq8RhvG4yHh7kmdZpcctTJT32bR8wwjViB8Un0UPOaCLUWLn?=
 =?us-ascii?Q?oQZnINaBgVJqQC1G3TyCjiGKDgVJZr/6Q7lonrxp+R6IGUPew3nCi5of/qq8?=
 =?us-ascii?Q?OOVFVinGUNbkUnhX874xSHoDM9y9fhi3rJ1mSjPKHZgsA21fZscF5m7Prwmf?=
 =?us-ascii?Q?pl3tUYYW+OfTZg04XznaIb+77IDXrD3JxHeKsm1CfJI4mbNu1NDjptkCjwwh?=
 =?us-ascii?Q?Kqz1x53TVGd1+E7mz5TIQrbWgQTiA8wql2g6wCP9UtNzrMhNX1pbdm8EcnYb?=
 =?us-ascii?Q?rXhasftFdJoxkDR2GcnstPLbNL16XzamDLhn2VYV8QpB6/cew1AVY6sc4i1i?=
 =?us-ascii?Q?m7pDfil6cAohDR1rX4JhRWgUEyJ8M7o7N8rcMAS0CJzcSfXZK5UdwwTv4A7R?=
 =?us-ascii?Q?/5IpMRqjeJXon/oGYIiTEAXSVvfKwFsnniQQIltWR8gHb+CCPoINYLDzxKFD?=
 =?us-ascii?Q?+JF+N7bnSyH3XfS2N46xN0/K/6QB2c0Fo61L0s/W9GNmbIUk8gE8hZKj2ZzF?=
 =?us-ascii?Q?dXCIc7tDWW9f6eElFFDOGuapR91y7EKMXvlYAFyLE63PEoiEXUPp/7Fsq0jf?=
 =?us-ascii?Q?Mw=3D=3D?=
X-OriginatorOrg: voleatech.de
X-MS-Exchange-CrossTenant-Network-Message-Id: 808933e9-a30f-498f-6a8b-08db254e75d2
X-MS-Exchange-CrossTenant-AuthSource: AM9PR05MB8857.eurprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Mar 2023 12:11:51.8863
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: b82a99f6-7981-4a72-9534-4d35298f847b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FtU8affyhsia1XOcDqWw9oHQSERKZ7+eXGcEvpR3OdIGd2YEyOWyqEdsrH/Dc7xDsg4uj+3964IDSTBvtecRzovkLBz9YtpwktmjDB5WBdg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DU0PR05MB10122
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Mar 15, 2023 at 01:06:01PM +0100, Pablo Neira Ayuso wrote:
> On Wed, Mar 15, 2023 at 12:45:33PM +0100, Sven Auhagen wrote:
> > On Wed, Mar 15, 2023 at 12:39:46PM +0100, Pablo Neira Ayuso wrote:
> > > Hi Sven,
> > 
> > Hi Pablo,
> > 
> > > 
> > > On Tue, Feb 28, 2023 at 11:14:13AM +0100, Sven Auhagen wrote:
> > > > Add a counter per namespace so we know the total offloaded
> > > > flows.
> > > 
> > > Thanks for your patch.
> > > 
> > > I would like to avoid this atomic operation in the packet path, it
> > > should be possible to rewrite this with percpu counters.
> > > 
> > 
> > Isn't it possible though that a flow is added and then removed
> > on two different CPUs and I might end up with negative counters
> > on one CPU?
> 
> I mean, keep per cpu counters for addition and deletions. Then, when
> dumping you could collected them and provide the number.
> 
> We used to have these stats for conntrack in:
> 
> /proc/net/stat/nf_conntrack
> 
> but they were removed, see 'insert' and 'delete', they never get
> updated anymore. conntrack is using atomic for this: cnet->count, but
> it is required for the upper cap (maximum number of entries).

I see that makes sense.
Let me rework the patch to have per cpu insert and delete counters
and send it in as v5.

Thanks
Sven

> 
> > > But, you can achieve the same effect with:
> > > 
> > >   conntrack -L | grep OFFLOAD | wc -l
> > > 
> > 
> > Yes, we are doing that right now but when we have like
> > 10 Mio. conntrack entries this ends up beeing a very long
> > and expensive operation to get the number of offloaded
> > flows. It would be really beneficial to know it without
> > going through all conntrack entries.
> > 
> > > ?
> 
> Yes, with such a large number of entries, conntrack -L is not
> convenient.
