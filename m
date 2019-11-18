Return-Path: <SRS0=asLr=ZK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 382DFC432C0
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Nov 2019 18:18:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1926A222AB
	for <netfilter-devel@archiver.kernel.org>; Mon, 18 Nov 2019 18:18:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726747AbfKRSSz (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 18 Nov 2019 13:18:55 -0500
Received: from correo.us.es ([193.147.175.20]:40984 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726423AbfKRSSz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Nov 2019 13:18:55 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A84EE118461
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Nov 2019 19:18:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 97BDBB8007
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Nov 2019 19:18:50 +0100 (CET)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8D563B8001; Mon, 18 Nov 2019 19:18:50 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1E98BBAACC;
        Mon, 18 Nov 2019 19:18:48 +0100 (CET)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Mon, 18 Nov 2019 19:18:48 +0100 (CET)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id ED69B42EE38E;
        Mon, 18 Nov 2019 19:18:47 +0100 (CET)
Date:   Mon, 18 Nov 2019 19:18:49 +0100
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Christian =?iso-8859-1?Q?G=F6ttsche?= <cgzones@googlemail.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: nftables: secmark support
Message-ID: <20191118181849.k4tb5rnmcuzigbaw@salvia>
References: <CAJ2a_DcUH1ZaovOTNS14Z64Bwj5R5y4LLmZUeEPWFaNKECS6mQ@mail.gmail.com>
 <20191022173411.zh3o2wnoqxpjhjkq@salvia>
 <CAJ2a_DdVOTDPpamh=DKcGde_8gp++xYPwBP=0gY3_GDqPFntrQ@mail.gmail.com>
 <CAJ2a_Df61oAEc4NSFZneThOpwQcsmmjf7_RiV9y-bePwYO-9Sw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJ2a_Df61oAEc4NSFZneThOpwQcsmmjf7_RiV9y-bePwYO-9Sw@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Christian,

On Mon, Nov 18, 2019 at 05:44:07PM +0100, Christian Göttsche wrote:
> Am Mo., 28. Okt. 2019 um 15:27 Uhr schrieb Christian Göttsche
> <cgzones@googlemail.com>:
> > > This is what your patch [6] does, right? If you don't mind to rebase
> > > it I can have a look if I can propose you something else than this new
> > > keyword.
> >
> > Attached at the end (base on 707ad229d48f2ba7920541527b755b155ddedcda)
> 
> friendly ping; any progress?
> 
> rebased against 4a382ec54a8c09df1a625ddc7d32fc06257c596d at
> https://paste.debian.net/1116802/

Thanks for following up on this. A few comments on your patch:

1) I would replace secmark_raw by secmark instead. I think we should
   hide this assymmetry to the user. I would suggest you also extend
   the evaluation phase, ie. expr_evaluate_meta() and expr_evaluate_ct()
   to bail out in case the user tries to match on the raw packet / ct
   secmark ID. IIRC, the only usecase for this raw ID is to save and
   to restore the secmark from/to the packet to/from the conntrack
   object.

And a few minor issues:

2) Please remove meta_key_unqualified chunk.

        meta_key_unqualified    SET stmt_expr

3) Remove the reset command chunk too:

--- a/src/rule.c
+++ b/src/rule.c
@@ -2539,6 +2539,12 @@ static int do_command_reset(struct netlink_ctx
*ctx, struct cmd *cmd)
        case CMD_OBJ_QUOTA:
                type = NFT_OBJECT_QUOTA;
                break;
+       case CMD_OBJ_SECMARKS:
+               dump = true;
+               /* fall through */
+       case CMD_OBJ_SECMARK:
+               type = NFT_OBJECT_SECMARK;
+               break;
        default:
                BUG("invalid command object type %u\n", cmd->obj);
        }

Thanks.
