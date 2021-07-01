Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 552E0C11F68
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Jul 2021 01:49:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 419156135C
	for <netfilter-devel@archiver.kernel.org>; Thu,  1 Jul 2021 01:49:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238415AbhGABwO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 30 Jun 2021 21:52:14 -0400
Received: from mail-co1nam11on2068.outbound.protection.outlook.com ([40.107.220.68]:12128
        "EHLO NAM11-CO1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S238384AbhGABwO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 30 Jun 2021 21:52:14 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=kG6YOjxNmTr06bUMLpW1OWkW6XMsm3DwxKcHHn42CNgVu6g6A+UeM7bbV0w7hQF7hWPXQiYi5mZfRBMgkI33UJwW8CTg1tKND89ELWFHdPVj4kzIWl/HHD1B0x4u1JbtcbQK4KrWibAZWvpyNWTvEs1d4TKAzCvjBbIXGPOCyDei/v/y5RQOWouv/29pl0hG/fHKPRRn7pzmxcbo1bOhugZGiEkuxjOvg70d+fgqS4ldj4wAOl2nbP6UqJXpils9C6ZyXbDQkTqPmwBL3CBYUdk1u9pdbwmAkp6Jkk4QZWhtrHpGhTO1tIOZv4InXV9VshYDPRNtSpEv3ChXP6cbng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2tsKr9os6qOU2Bx+mURG7jsOC1E9FWXxofTaUx1DEsM=;
 b=VZlDpcD8Jyam5ChRXicdQcmOpLOYfJcyNc3FBsBhVKKIbgO8FF5+AM9kJBVCL/qM6auUv4tNm9ugEzSm/BRPpg8wKNXn9UThXHK7kAsluBhppIVM/XvXQR1LaetL/KrWcWhin6IMH8AJxedP8ZZUZ7K/JKoiNXP6V4RB9SMOocEYjKjauSn4YfuN7LmTedo3bHBy9WXriJxwWaxdEPx2X/F/f+FppmHn263DM0xqkCpmcMzaQjZj6nrjIFqvCrF5QiaYPDFXf8D/6jDok8eGNlEpEIO49RoFFT/fG7yNP8bIULdG9F2OYZzcc+Jq2wfRuNZT5oDqMvSqOUFYrMphxg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=alum.wpi.edu; dmarc=pass action=none header.from=alum.wpi.edu;
 dkim=pass header.d=alum.wpi.edu; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alum.wpi.edu;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2tsKr9os6qOU2Bx+mURG7jsOC1E9FWXxofTaUx1DEsM=;
 b=PN7SOKVWgPs1UYf7oP3mvBcB0nkFPEUIoZxVjkh8BEvo4a5MiPOIfxfLIhH08nctNvGRmumxmUo8jdBNhPZcmFR/RBnaHLG3Nhiu6jAzOjBa4uAjpEBGbfz+WXeRmYl0ONjFRBjhM9tjlFdKTLHMF35P/RIXC6SA31tiEtJM83c=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=alum.wpi.edu;
Received: from CY4PR22MB0470.namprd22.prod.outlook.com (2603:10b6:903:be::20)
 by CY4PR22MB0949.namprd22.prod.outlook.com (2603:10b6:903:156::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.23; Thu, 1 Jul
 2021 01:49:42 +0000
Received: from CY4PR22MB0470.namprd22.prod.outlook.com
 ([fe80::6809:ed7d:cfd2:dc38]) by CY4PR22MB0470.namprd22.prod.outlook.com
 ([fe80::6809:ed7d:cfd2:dc38%11]) with mapi id 15.20.4264.026; Thu, 1 Jul 2021
 01:49:42 +0000
Date:   Wed, 30 Jun 2021 21:49:38 -0400
From:   "Neal P. Murphy" <neal.p.murphy@alum.wpi.edu>
Cc:     netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
Subject: Re: Reload IPtables
Message-ID: <20210630214938.1396b4a0@playground>
In-Reply-To: <20210629083718.GA10943@salvia>
References: <f5314629-8a08-3b5f-cfad-53bf13483ec3@hajes.org>
        <adc28927-724f-2cdb-ca6a-ff39be8de3ba@thelounge.net>
        <96559e16-e3a6-cefd-6183-1b47f31b9345@hajes.org>
        <16b55f10-5171-590f-f9d2-209cfaa7555d@thelounge.net>
        <54e70d0a-0398-16e4-a79e-ec96a8203b22@tana.it>
        <f0daea91-4d12-1605-e6df-e7f95ba18cac@thelounge.net>
        <8395d083-022b-f6f7-b2d3-e2a83b48c48a@tana.it>
        <20210628104310.61bd287ff147a59b12e23533@plushkava.net>
        <20210628220241.64f9af54@playground>
        <20210629083652.GA10896@salvia>
        <20210629083718.GA10943@salvia>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.148.50.133]
X-ClientProxiedBy: BL1PR13CA0322.namprd13.prod.outlook.com
 (2603:10b6:208:2c1::27) To CY4PR22MB0470.namprd22.prod.outlook.com
 (2603:10b6:903:be::20)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from playground (73.148.50.133) by BL1PR13CA0322.namprd13.prod.outlook.com (2603:10b6:208:2c1::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4287.8 via Frontend Transport; Thu, 1 Jul 2021 01:49:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d6492f93-d5f7-4cc6-63c4-08d93c327eab
X-MS-TrafficTypeDiagnostic: CY4PR22MB0949:
X-Microsoft-Antispam-PRVS: <CY4PR22MB0949C90299AF4E61DD03106888009@CY4PR22MB0949.namprd22.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ntyvei5jlE89VMglS9ow3GxSdaGQ7jfxzPXWqyuDftDtEfT/VAEWU2fVMyp3F4W8nX8YMYy9iloMaE7wAUUyTV69d8/rTuRJnel+ntlGTEewM5g3wQfNAV68ikRP7oNfflz5z7ddX0s5+Go9CDu1UfTGoPT9SVNV647sTGp9Ikpko1hkOpYkXVSycZyyY4OqSkbZDWl+BSiausLSIE2kO4O/J31V97vD9P/neUUiadoFY76IbraHg6fJZSXCFzJqIbPZCXNj1Pzdc7O6uZVpXFPbZmWbXVV6bgeOb9c8598d/rdbtVKOrqvdWbi5OIP6h6MeMP5sC/FZUINBl/MI1+wU23GTdRP/2D+0vrSdR2nRSZhLLXaU6xFtMJMu41gQl3Kc98Q1JfGX1zO/8Dd2+eyDdi9FMIHE39d4DfZKtK39ARVvxsSkU/BYjskl0xASFOOJnKCdmRNXYrJtT3KgNbyGkJAh/YdiJUpCMHxhnfcBP5rPY5quGj/tzfk2+zQYA7AzWnmraSgjCxISDET88e/B44c4VcPAgHxqM3zSgrE1aKOmOm7K15QAJ7jH8GgxDsxh92cQCer+Tw0w/WMGt76y6Kvs0RIafVbnGfStuI2QeT0qXEQKfzbm8xLVWDPCExDsmDoFQW7O42o28hpev2m8PwUwdUA/woTIQtQSzAVkDb4X0lvJG05Er6RUuQ2yMaYEnGnbN08NRG82qF3ojKBTbGU7Il/BSeFa4JqX6kACy84o6nwpSWZI/OMSlffT4TQmxoSrKs2HpB3LkNsnj//ESG3dVsDIip4rVr0KI/C1Y5JRMa96aUZKVb9RWxxw
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR22MB0470.namprd22.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(376002)(396003)(366004)(39860400002)(83380400001)(55016002)(16799955002)(3480700007)(9686003)(8676002)(966005)(186003)(75432002)(38100700002)(6666004)(26005)(38350700002)(956004)(16526019)(316002)(52116002)(33716001)(2906002)(450100002)(5660300002)(4326008)(66476007)(66556008)(6496006)(8936002)(66946007)(478600001)(9576002)(86362001)(1076003)(7116003)(109986005)(786003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?96d27eAkUxl8mRokdzKpvV0UxDoPgdpUvm+NtQVabW/KhRr3Iwl1x0ydTwRi?=
 =?us-ascii?Q?ks0wq2A22cXXyVr6eVZp9YVGLrMhHHnmNKegYTsA6jdx6GARefbj32GBsSQz?=
 =?us-ascii?Q?k+tODgc1Ogv56QGH7w90sAS/Xb8vilL19Jfrf0bE3NOEYOUFlaYQyGo069xB?=
 =?us-ascii?Q?iKQDvTPs82McAAPRrMt2ioLGt+RTikftrQmRy2xJYtRsSUw+b72jrMIxyGpq?=
 =?us-ascii?Q?vDH23rW5PODHZBvWbH/AdmGRSTONbGE62wf0pB1wsD3cD9GXBAyhX2srQwv7?=
 =?us-ascii?Q?NkD5M1Iu0CpcBOdc9j0IYG9DW5qTQgPAy149L78UUjk4WVH1p4fUlTBmZ/Wb?=
 =?us-ascii?Q?S/a48BzPEsHDWohpBjFIgqASNRh9gzp+4OAHEi+s4O/vwIzZMXfyfjiywQ49?=
 =?us-ascii?Q?PQ/EO/Ka5PHz8miWv/U+ys2xV7vkZuNRp3BtnDzn4nsBAYY+Tbioxx69A+J0?=
 =?us-ascii?Q?JcNVKrwSKa1aT1erFAZmX6TpHtjqKpLJ29qNKewLkrEuD6iu9lkGGJj6scGg?=
 =?us-ascii?Q?s+gjTYzxZmH394gAlu03ukI1ZRiGDRggVdfTWu3/MKVSM4Ekt37/IzlL95hS?=
 =?us-ascii?Q?riLxRI60DemXvUfeuXrIWZMCKS8TkpA+RB0uiuCML8o5M+8bfbD5ney3fFLV?=
 =?us-ascii?Q?vcriylXZ1rnz+vK2frnwrpaLooqiEWzIFg4Csf+vPRMNYIgCniXyATIpentP?=
 =?us-ascii?Q?RsM59rxofk9olb6gOf34BocFYG5f79ZxI3gSytq7DMn8q7ZFPKLn7XSg5Zlz?=
 =?us-ascii?Q?dJ5feTE7sne2W55SUvAlKT/G/OoTPC6SlDBJ2KIsn7+IsP32d+OkfIRpUwe+?=
 =?us-ascii?Q?6R36WfyDDONyuPuIDJy+/XUfzWpwCNatUkAmyYNNg+aze5AnGNWNDVIsYg0s?=
 =?us-ascii?Q?kRdyJkaAybr4hZECTUObUpCoxGHrCm1Ea7LQxbPeG2kG9/JpTg0laMRlGtaK?=
 =?us-ascii?Q?wSCC+niKtYT/iCP3rMpcpkUFogO0xLvrmy/qwGMHsMagLufvuEPIhMRU67u5?=
 =?us-ascii?Q?Ok5MTRgjmuoDTB1r0XReRrb/EoXfhdPRDpHYH/hpFUy584Vo4R7l4ySrOiCb?=
 =?us-ascii?Q?Oo9cKjQsKqLgSycZnzlOQd5uijLcMBqcgoonYq9IiAFr8XK86E6uINV2bGFO?=
 =?us-ascii?Q?FfYY/k0UW/5XkdbN+TjKcNMu/gLZ1eEhKnDRL5CgeKXs648L3SNNA3eaduRm?=
 =?us-ascii?Q?raOwCAhU5cDcDhsD+POx16c+S007+8o+RwvfZdBYbnTK339kmMnEImT1WprW?=
 =?us-ascii?Q?qjCoQiIbap9QmMvSpdoQxwocGQ3pHz//r+4JNPEQk/UCI99uszI3KtCFaP+9?=
 =?us-ascii?Q?ljpufD9roT1JhhomeE14lqn9?=
X-OriginatorOrg: alum.wpi.edu
X-MS-Exchange-CrossTenant-Network-Message-Id: d6492f93-d5f7-4cc6-63c4-08d93c327eab
X-MS-Exchange-CrossTenant-AuthSource: CY4PR22MB0470.namprd22.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 01 Jul 2021 01:49:42.3395
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46a737af-4f36-4dda-ae69-041afc96eaef
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xh6EyQerW9VTgtvOQSYRRQErwekCNYh7DJVYf+SMndDXbXXv7VUNoiof7E0xOJTcINRmUbTukuTa2TG/iUu+O1zlTnko5kgtX6gimE2w/ko=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR22MB0949
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, 29 Jun 2021 10:37:18 +0200
Pablo Neira Ayuso <pablo@netfilter.org> wrote:

> On Mon, Jun 28, 2021 at 10:02:41PM -0400, Neal P. Murphy wrote:
> > On Mon, 28 Jun 2021 10:43:10 +0100
> > Kerin Millar <kfm@plushkava.net> wrote:
> >   
> > > Now you benefit from atomicity (the rules will either be committed at once, in full, or not at all) and proper error handling (the exit status value of iptables-restore is meaningful and acted upon). Further, should you prefer to indent the body of the heredoc, you may write <<-EOF, though only leading tab characters will be stripped out.
> > >   
> > 
> > [minor digression]
> > 
> > Is iptables-restore truly atomic in *all* cases?  
> 
> Packets either see the old table or the new table, no intermediate
> ruleset state is exposed to packet path.
> 
> > Some years ago, I found through experimentation that some rules were
> > 'lost' when restoring more than 25 000 rules.  
> 
> Could you specify kernel and userspace versions? Rules are not 'lost'
> when restoring large rulesets.

This goes back to late '10, early '11: linux 2.6.35, iptables 1.4.10; possibly even earlier releases. I don't recall trying the experiment since.

> 
> > If I placed a COMMIT every 20 000 rules or so, then all rules would
> > be properly loaded. I think COMMITs break atomicity.  
> 
> Why are you placing COMMIT in every few rules 20 000 rules?

If I recall correctly, when I attempted to restore/load more than 'N' rules or so back then, a few rules at that 'N' 'boundary' would not be in the final iptables ruleset. IIRC, it didn't matter how quickly or slowly I added the rules. By including a COMMIT every 20k rules or so, all of the rules I loaded would be added, be it 10k or 100k (or more).

There was also a vmalloc failure up around 130k-150k rules.

A couple references:
  - https://marc.info/?l=netfilter&m=133814281919741&w=2
  - https://community.smoothwall.org/forum/viewtopic.php?p=292390#p292390

> 
> > I tested with 100k to 1M rules.  
> 
> iptables is handling very large rulesets already.
> 
> > I was comparing the efficiency of iptables-restore with another tool
> > that read from STDIN; the other tool was about 5% more efficient.  
> 
> Could you please specify what other tool are you refering to?

The tool is ipbatch (part of Smoothwall Express). It was written because, at least back then, iptables was not able to read from STDIN. Smoothwall Express reads its config/settings files and generates the firewall rules on the fly and pipes them to ipbatch. Also, the rules are generated by function/application, not by table; iptables-restore would not be usable without major changes to the way Smoothwall Express generates its firewall rules.

Neal
