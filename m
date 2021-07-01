Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 437D4C11F66
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Jul 2021 02:32:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17CB6613E4
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Jul 2021 02:32:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238507AbhGACe0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Jun 2021 22:34:26 -0400
Received: from mail-co1nam11on2064.outbound.protection.outlook.com ([40.107.220.64]:12320
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238056AbhGACe0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Jun 2021 22:34:26 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NaleKwAjVUP6Fff8dnCl1ki4wlxPniqjdqXcFOCI68kJg639NZqJq096uG5XC0IWdBVqE3OoIHSyxicn2B9naxB/QGG6jyYOqBkdLYv3Rnz5f1pvP4yEqHFOBuKpayl7i1D9GynwJ+Q7oBDFXQ7NnmNhKWmjlgILtv5sRGfW9RmS2sVlptDDTMp87DXApyQk3NeQw9cP0E8/jdb8S6k6gCik7SHlL4xUpkHIXXFkZCxZ3MTVHQr06iUTxzVtF0T1isdw8kEZukcesxYMyZel+6UEAQy3J65zRhcUePilS8d4NxeI3mXInVA9azNxFtWqXU6wGxTATeoXjVIFdK9jTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e9xgbI9/DqFi0WkUrs3SGKsV0YRHuTdhJUzRq/uH+K8=;
 b=h0CK5ur70E62rWDiLvEngU8vc4zXcGZg/qI9vs1HB5qK4uadPxs2gd8kDfLh1ggKcRdZaiTODT6JaRzJdWNUnOmickDlbfE/kyvJEafMB2VZvQafqw3FRUXJqTWCsQPZfoRU7Z7Jh+ggBLLUCDWBHaKZzLmes2SkL0yxfhPLkN69EEVqNTKGWDjv+xeGa3HFiwH5rgQ/ZjEyWHbfZCEuELNlS0UQ5+WjX7gZJOnTnzaYJP5qtTE8+nJtRHxvdHxhdUU7L0rfABGXwML+FBdxe+XRKq4GRUloa08LYQ6gwEgXcmBR3+XVyi0aqtYPR1bqudAKH0DgF3gQNb3FYANl5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=alum.wpi.edu; dmarc=pass action=none header.from=alum.wpi.edu;
 dkim=pass header.d=alum.wpi.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alum.wpi.edu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e9xgbI9/DqFi0WkUrs3SGKsV0YRHuTdhJUzRq/uH+K8=;
 b=otZamjTUUcqhaamg4lmg0OV76fuernyF1SD9Vwr5yPtkJD1+EninG3XWzIx6gnA/20CtAE+TPSYU3/vg5C1LJNVefa0olafqE41NTAk3Xj3Nb81NATuPQKouKhf4gByBtswT54z65b0KZ4rxRl5YW/4k4UP10wfz+n1nzvYG+j4=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=alum.wpi.edu;
Received: from CY4PR22MB0470.namprd22.prod.outlook.com (2603:10b6:903:be::20)
 by CY4PR22MB0117.namprd22.prod.outlook.com (2603:10b6:903:13::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.22; Thu, 1 Jul
 2021 02:31:54 +0000
Received: from CY4PR22MB0470.namprd22.prod.outlook.com
 ([fe80::6809:ed7d:cfd2:dc38]) by CY4PR22MB0470.namprd22.prod.outlook.com
 ([fe80::6809:ed7d:cfd2:dc38%11]) with mapi id 15.20.4264.026; Thu, 1 Jul 2021
 02:31:54 +0000
Date:   Wed, 30 Jun 2021 22:31:50 -0400
From:   "Neal P. Murphy" <neal.p.murphy@alum.wpi.edu>
To:     netfilter-devel@vger.kernel.org
Subject: Re: Reload IPtables
Message-ID: <20210630223150.409365d1@playground>
In-Reply-To: <c78c189b-efad-0d20-fa9e-989c828d7067@att.net>
References: <08f069e3-914f-204a-dfd6-a56271ec1e55.ref@att.net>
        <08f069e3-914f-204a-dfd6-a56271ec1e55@att.net>
        <4ac5ff0d-4c6f-c963-f2c5-29154e0df24b@hajes.org>
        <6430a511-9cb0-183d-ed25-553b5835fa6a@att.net>
        <877683bf-6ea4-ca61-ba41-5347877d3216@thelounge.net>
        <d2156e5b-2be9-c0cf-7f5b-aaf8b81769f8@att.net>
        <f5314629-8a08-3b5f-cfad-53bf13483ec3@hajes.org>
        <adc28927-724f-2cdb-ca6a-ff39be8de3ba@thelounge.net>
        <96559e16-e3a6-cefd-6183-1b47f31b9345@hajes.org>
        <16b55f10-5171-590f-f9d2-209cfaa7555d@thelounge.net>
        <54e70d0a-0398-16e4-a79e-ec96a8203b22@tana.it>
        <f0daea91-4d12-1605-e6df-e7f95ba18cac@thelounge.net>
        <8395d083-022b-f6f7-b2d3-e2a83b48c48a@tana.it>
        <20210628104310.61bd287ff147a59b12e23533@plushkava.net>
        <20210628220241.64f9af54@playground>
        <c78c189b-efad-0d20-fa9e-989c828d7067@att.net>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.148.50.133]
X-ClientProxiedBy: MN2PR02CA0035.namprd02.prod.outlook.com
 (2603:10b6:208:fc::48) To CY4PR22MB0470.namprd22.prod.outlook.com
 (2603:10b6:903:be::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from playground (73.148.50.133) by MN2PR02CA0035.namprd02.prod.outlook.com (2603:10b6:208:fc::48) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.21 via Frontend Transport; Thu, 1 Jul 2021 02:31:53 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c2aae080-f2aa-4729-755d-08d93c3863df
X-MS-TrafficTypeDiagnostic: CY4PR22MB0117:
X-Microsoft-Antispam-PRVS: <CY4PR22MB01178BB5F4F8E564CE1DE76888009@CY4PR22MB0117.namprd22.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: o36ZH8u/ymzH+OzEiGB6tgDlyT1pYsR2hsuFptdWHQyMcd+tchOs2dnDyBOEkwtAfRVUp7cFSJvV9l1ksRSQHoCEwaKzOYdCkKqgYXW0J1/1LS40Ft83AvJUltP4Men3GyyQ//KMPK6w9Ciybh6m104SrmXhdSAnmONG5wzoHjrTLnzaFRe3b62XYfeUb10qC106lvhJU7wd7z1pG7niTDjpcRN+Wtj1WCXKuXQ1GIQC3i513zW9kdj3zU601Bt7kS5LR1gCtsdZrhbrYmRHIbkRJPoD6oPNxBFlp5gne8ELi1kRvPy8lEKpMGypAnDnYHIqhEXLNG2NNhr8FTQuBvHZkNZD8a2j9Ai70U9RG2tFkkGbPgFHaxIR4GrYJnsXHEBesScLiYqf/B9Ui3QhCUCVqnat6yfVyXHfkUEwVOk1tkzOaEEj4d74Ai9abiecYIY92DS5AipSjw5B4FtjtmKAoYZmRtwHZNdRq9S4PkVxaF5z5QGKK2LAeAxJ64tcU3XgUh+XLqn/3Hg7QGc2lIgblAOzqTkGfJTotFs9z1oOY/BzLaUTQ7xBSza+5TUnxNZrd8LxWJri6AofDQl4+NuoMSeMgMJ0lFUmZXakg/ktROzppjH4Z0VOuwgQmzwS3WLINXlSaOB27FkBcrk/fvLQVglhXPrcjARhoHAn0XCUKLNOTXuK5xqCtbPLheDvtHwkxDl9QemEo7D/gTeqwA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR22MB0470.namprd22.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(396003)(346002)(136003)(39860400002)(376002)(52116002)(16526019)(38100700002)(38350700002)(1076003)(66476007)(75432002)(5660300002)(6496006)(478600001)(186003)(9686003)(8936002)(66556008)(26005)(55016002)(6916009)(33716001)(2906002)(53546011)(3480700007)(83380400001)(7116003)(316002)(86362001)(8676002)(786003)(66946007)(9576002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?FQHrecaVadZgWX35f0N7wqKfke8ctgBLecDImgPdEy7psCdlld79beYK/zRJ?=
 =?us-ascii?Q?PqsQbpslIS2e6DTi8imZ+0UYx7MYK8eW/7k4vpVLUUe8kNxf8IcmhJx7mmc0?=
 =?us-ascii?Q?St8IRrmc7V/uHMKg0fEQs0IEN9qwQXCakxWELmrXW4uXmvOnn789FRwhXDo9?=
 =?us-ascii?Q?/8qFrN880CV7U2+TmN0eojkztBV3cmo+Ck02mdXuuuTatnFskRXlBWnOQ6CS?=
 =?us-ascii?Q?lnfwaadVdHMh1YHJCsZc2j4MKYOhLnkgz+H2KQO0f/trdE9IWKYt7Lc21U8s?=
 =?us-ascii?Q?LzH33yOeoLGL0wGvDMkLiwSdGgjebgHAhDHn+g4ToeBA/73Vpe53n43mGrhu?=
 =?us-ascii?Q?7YxZbDNIyiZmbqhVtePEjzc6zRRTb/QFR9rXklWo82g0OHGoYJr0wGFCAQE7?=
 =?us-ascii?Q?pl1IYUuL8c9XGctXuh8qbmNqZUujSGgsS87E+R1mEjk/Bv7vB+Lb+f3ASvrL?=
 =?us-ascii?Q?DOzG67x0GvZLWcCxekEzMWMxwzxAP/au02lwDAnox68rBizlgYc9p9wIyd2s?=
 =?us-ascii?Q?zasv6Q9lzvBmp8xzpl17ktw2L5CCYd3D+dgQ5kU9w1xNqNdEsJR3gL+GS5pR?=
 =?us-ascii?Q?k7hKjxZXyw0bLIRbfll28GrUQ/Mds37ew3xtDyORdfx+9jkduRLcF2YPVUYy?=
 =?us-ascii?Q?DYONlvXjL52aIa+T+6m2Gy7dUfRQxNPdK6wAwRbRlKbC5Sv+lOlvPEQDJH4f?=
 =?us-ascii?Q?2Ewxy1bPmPPXtffYijvRqtL02599LZkDiBsUswZz1roa9H/rNgKbJOkE4MVQ?=
 =?us-ascii?Q?4rBRy4eRUV0YWt0iefcvat3EB6qvbhYHkGjYckEu495RkDVYX+/0ARlRm7TL?=
 =?us-ascii?Q?Pal3qdY/zJxPggB4jHVhWdcxauhOSZn0fbqRH65qZz6VYT/T7krDJ18VU198?=
 =?us-ascii?Q?H65GrAC5tyxC86BdELyIHjt8PDIo9vnDV+d64ucrfJYDLEOdluEpsVfEPw5C?=
 =?us-ascii?Q?JAl6ZJNDHkeRLoYD6axhQ1PAzbup5VhkN2RptVbCBKuCFIlWa6NQhnMS8v+G?=
 =?us-ascii?Q?0sla2cq1cIEenYoO0RwrOrTkuG2/ZiwG5yjB8tJ9k+ZnSSNDgTjhAJi6jkn1?=
 =?us-ascii?Q?1JiuCHOTEMaa6n1xHUwfTuyHONPg5nfFO1sM60YJ/UaWj8q6PIWAT/yXQ7OH?=
 =?us-ascii?Q?zJMldF6WL5CMJg/gJmw+GDqlR4INBuvBtSQ5zT+ZoyXl4IoL4qxnjErQh1XY?=
 =?us-ascii?Q?dGnhGNq0ezPh4/ZzChmVPZTKWnvUvnI/XglH1yhge8Q1IxWsSIJF2sCI5ZOR?=
 =?us-ascii?Q?OZI3O3nin7DttjTOFTbeNbFP8ORhXC83LA7cyIhD5po4Zq7afzr5dKjmNWQc?=
 =?us-ascii?Q?7YKOTH/hPem/OuRWSc2kGQxl?=
X-OriginatorOrg: alum.wpi.edu
X-MS-Exchange-CrossTenant-Network-Message-Id: c2aae080-f2aa-4729-755d-08d93c3863df
X-MS-Exchange-CrossTenant-AuthSource: CY4PR22MB0470.namprd22.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2021 02:31:54.2629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46a737af-4f36-4dda-ae69-041afc96eaef
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fC9FfLYXP7NemKEZkqSN6y/cglxom7+yceGnME96RPV/OuOrC59A3STNOA9ZvsW09UydCQjYji/zk8MgjmzFt37ASmzRpGJWfYpGAAZAPDc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR22MB0117
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 29 Jun 2021 10:52:38 -0400
slow_speed@att.net wrote:

> On 6/28/21 10:02 PM, Neal P. Murphy wrote:
> > On Mon, 28 Jun 2021 10:43:10 +0100
> > Kerin Millar <kfm@plushkava.net> wrote:
> >   
> >> Now you benefit from atomicity (the rules will either be committed at once, in full, or not at all) and proper error handling (the exit status value of iptables-restore is meaningful and acted upon). Further, should you prefer to indent the body of the heredoc, you may write <<-EOF, though only leading tab characters will be stripped out.
> >>  
> > 
> > [minor digression]
> > 
> > Is iptables-restore truly atomic in *all* cases? Some years ago, I found through experimentation that some rules were 'lost' when restoring more than 25 000 rules. If I placed a COMMIT every 20 000 rules or so, then all rules would be properly loaded. I think COMMITs break atomicity. I tested with 100k to 1M rules. I was comparing the efficiency of iptables-restore with another tool that read from STDIN; the other tool was about 5% more efficient.
> >   
> 
> Please explain why you might have so many rules.  My server is pushing 
> it at a dozen.

In this particular case, I needed a lot of rules to obtain a reasonable estimate of the relative efficiencies of the two programs, enough rules to mask program initialization time.

I agree that tens of thousands of rules is probably outrageous for most purposes. A good firewall--that restricts outgoing conns, handles TESTNET addresses, isolates traffic between several internal LANs while allowing certain traffic to pass between them, employs NAT, and uses CONNMARKs to tag traffic and to provide traffic stats--can easily use over 600 rules, if not a good deal more. Yet a 1.6GHz Atom N270 can still process four saturated gigE NICs with plenty of cycles to spare with those 600 rules.

N
