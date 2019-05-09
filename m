Return-Path: <SRS0=htyh=TJ=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED8F5C04AB1
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 May 2019 14:57:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C893320644
	for <netfilter-devel@archiver.kernel.org>; Thu,  9 May 2019 14:57:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726560AbfEIO5I (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 9 May 2019 10:57:08 -0400
Received: from mail.us.es ([193.147.175.20]:59720 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726234AbfEIO5I (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 9 May 2019 10:57:08 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D8B561C4388
        for <netfilter-devel@vger.kernel.org>; Thu,  9 May 2019 16:57:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C80B1DA703
        for <netfilter-devel@vger.kernel.org>; Thu,  9 May 2019 16:57:04 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id BDA4CDA705; Thu,  9 May 2019 16:57:04 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C77FFDA703;
        Thu,  9 May 2019 16:57:02 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 09 May 2019 16:57:02 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (unknown [31.4.199.18])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id A03B44265A31;
        Thu,  9 May 2019 16:57:02 +0200 (CEST)
Date:   Thu, 9 May 2019 16:57:01 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Fernando Fernandez Mancera <ffmancera@riseup.net>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nft WIP] jump: Allow jump to a variable when using nft
 input files
Message-ID: <20190509145701.bwg5wrkv47eahhlp@salvia>
References: <20190509113358.856-1-ffmancera@riseup.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190509113358.856-1-ffmancera@riseup.net>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, May 09, 2019 at 01:33:58PM +0200, Fernando Fernandez Mancera wrote:
> This patch introduces the use of nft input files variables in 'jump'
> statements, e.g.
> 
> define dest = chainame
> 
> add rule ip filter input jump $dest

You need two patches to achieve this.

First patch should replace the chain string by an expression, ie.

diff --git a/include/expression.h b/include/expression.h
index 6416ac090d9f..d3de4abfd435 100644
--- a/include/expression.h
+++ b/include/expression.h
@@ -240,7 +240,7 @@ struct expr {
                struct {
                        /* EXPR_VERDICT */
                        int                     verdict;
-                       const char              *chain;
+                       struct expr             *chain;
                };
                struct {
                        /* EXPR_VALUE */

Then, this first patch should also update the whole codebase to use
this new chain expression. From the parser, you will have to call
constant_expr_alloc() using the string_type datatype to store the
chain string. Still from this initial patch, you also have to call
expr_evaluate() from stmt_evaluate_verdict() on this new chain
expression field. You will also need to update the netlink_delinearize
path to allocate the constant expression so ruleset listing does not
break.

Then, the second patch only needs to update the parser to allocate the
symbol expression, very much like you did in this WIP patch and things
will just work out of the box, given that first patch is now calling
expr_evaluate() :).
