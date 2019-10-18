Return-Path: <SRS0=5/AD=YL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CD8BCA9EA0
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Oct 2019 08:31:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7DD6820820
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Oct 2019 08:31:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2632856AbfJRIbB (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Oct 2019 04:31:01 -0400
Received: from correo.us.es ([193.147.175.20]:49204 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387458AbfJRIbB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Oct 2019 04:31:01 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id AAAB2DA7ED
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Oct 2019 10:30:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 958E14C3C3
        for <netfilter-devel@vger.kernel.org>; Fri, 18 Oct 2019 10:30:56 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 8B2CADA8E8; Fri, 18 Oct 2019 10:30:56 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 98460A7E2B;
        Fri, 18 Oct 2019 10:30:54 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Fri, 18 Oct 2019 10:30:54 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id 75C5742EF4E0;
        Fri, 18 Oct 2019 10:30:54 +0200 (CEST)
Date:   Fri, 18 Oct 2019 10:30:56 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH 6/8] xtables-restore: Drop pointless newargc
 reset
Message-ID: <20191018083056.6ovhjtl5eluwmqhh@salvia>
References: <20191017224836.8261-1-phil@nwl.cc>
 <20191017224836.8261-7-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191017224836.8261-7-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Oct 18, 2019 at 12:48:34AM +0200, Phil Sutter wrote:
> This was overlooked when merging argv-related code: newargc is
> initialized at declaration and reset in free_argv() again.
> 
> Fixes: a2ed880a19d08 ("xshared: Consolidate argv construction routines")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  iptables/xtables-restore.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/iptables/xtables-restore.c b/iptables/xtables-restore.c
> index df8844208c273..bb6ee78933f7a 100644
> --- a/iptables/xtables-restore.c
> +++ b/iptables/xtables-restore.c
> @@ -232,9 +232,6 @@ void xtables_restore_parse(struct nft_handle *h,
>  			char *bcnt = NULL;
>  			char *parsestart = buffer;
>  
> -			/* reset the newargv */
> -			newargc = 0;

Are you sure this is correct? This resets the variable for each table
this is entering.

BTW, newargv, newargc are defined as globals which is very hard to
follow when reading this code. Probably place them in a structure
definition and pass them to functions to make easier to follow track
of this code?

That code would qualify for placing it under
iptables/xtables-restore.c since it is common for the xml and the
native parser as I suggested before.
