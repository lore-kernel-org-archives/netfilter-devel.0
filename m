Return-Path: <SRS0=6lPY=BO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DED2AC433E0
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Aug 2020 12:26:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C28E522BED
	for <netfilter-devel@archiver.kernel.org>; Tue,  4 Aug 2020 12:26:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725924AbgHDM04 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 4 Aug 2020 08:26:56 -0400
Received: from correo.us.es ([193.147.175.20]:44942 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725864AbgHDM0z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 4 Aug 2020 08:26:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id A4A2FF2DE6
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Aug 2020 14:15:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 95F71DA78B
        for <netfilter-devel@vger.kernel.org>; Tue,  4 Aug 2020 14:15:58 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8B8DEDA72F; Tue,  4 Aug 2020 14:15:58 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6E19FDA789;
        Tue,  4 Aug 2020 14:15:56 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Tue, 04 Aug 2020 14:15:56 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [213.143.49.65])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id E95C64265A32;
        Tue,  4 Aug 2020 14:15:55 +0200 (CEST)
Date:   Tue, 4 Aug 2020 14:15:53 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     "Jose M. Guisado" <guigom@riseup.net>
Cc:     netfilter-devel@vger.kernel.org, erig@erig.me, phil@nwl.cc
Subject: Re: [PATCH nft v4] src: enable json echo output when reading native
 syntax
Message-ID: <20200804121553.GA26896@salvia>
References: <20200731104944.21384-1-guigom@riseup.net>
 <20200804103846.58872-1-guigom@riseup.net>
 <20200804110552.GA18345@salvia>
 <12943ed7-2836-0201-73f4-7dc8ed0d91cb@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12943ed7-2836-0201-73f4-7dc8ed0d91cb@riseup.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Tue, Aug 04, 2020 at 02:13:01PM +0200, Jose M. Guisado wrote:
> Hi Pablo, sorry about the formatting issues.
> 
> One thing about your suggestion:
> 
> On 4/8/20 13:05, Pablo Neira Ayuso wrote:
> > if (!ctx->json_root)
> >                  return;
> 
> Checking uniquely for the absence of json_root is not enough as
> json_echo may have been initialized. In essence, the case the
> patch is fixing is when json_root is null but json_echo is not,
> to denote that we want json echo output but have not read json
> from input.

Ah, indeed, sorry. Then, probably:

        if (!ctx->json_root) {
               if (!ctx->json_echo)
                        return;

                ctx->json_echo = json_pack("{s:o}", "nftables", ctx->json_echo);
                json_dumpf(ctx->json_echo, ctx->output.output_fp, JSON_PRESERVE_ORDER);
                json_decref(ctx->json_echo);
                ctx->json_echo = NULL;
                fprintf(ctx->output.output_fp, "\n");
                fflush(ctx->output.output_fp);
        } else {
                json_dumpf(ctx->json_root, ctx->output.output_fp, JSON_PRESERVE_ORDER);
                json_cmd_assoc_free();
                json_decref(ctx->json_root);
                ctx->json_root = NULL;
        }
