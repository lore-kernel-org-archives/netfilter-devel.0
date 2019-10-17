Return-Path: <SRS0=wLp+=YK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4EDC1ECE58E
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 11:11:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2B42A2082C
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 11:11:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502053AbfJQLLw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Oct 2019 07:11:52 -0400
Received: from correo.us.es ([193.147.175.20]:49336 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406044AbfJQLLw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Oct 2019 07:11:52 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 1028511EB26
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Oct 2019 13:11:48 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id F16A0CA0F3
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Oct 2019 13:11:47 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id E635921FE4; Thu, 17 Oct 2019 13:11:47 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id D3FA6B8005;
        Thu, 17 Oct 2019 13:11:45 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 17 Oct 2019 13:11:45 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id B1AA842EE38E;
        Thu, 17 Oct 2019 13:11:45 +0200 (CEST)
Date:   Thu, 17 Oct 2019 13:11:47 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 1/4] monitor: Add missing newline to error message
Message-ID: <20191017111147.nfja47h7rckrzofv@salvia>
References: <20191016230322.24432-1-phil@nwl.cc>
 <20191016230322.24432-2-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016230322.24432-2-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 17, 2019 at 01:03:19AM +0200, Phil Sutter wrote:
> These shouldn't happen in practice and printing to stderr is not the
> right thing either, but fix this anyway.
> 
> Fixes: f9563c0feb24d ("src: add events reporting")
> Signed-off-by: Phil Sutter <phil@nwl.cc>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

> ---
>  src/monitor.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/src/monitor.c b/src/monitor.c
> index 40c381149cdaa..20810a5de0cfb 100644
> --- a/src/monitor.c
> +++ b/src/monitor.c
> @@ -388,7 +388,7 @@ static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
>  
>  	set = set_lookup_global(family, table, setname, &monh->ctx->nft->cache);
>  	if (set == NULL) {
> -		fprintf(stderr, "W: Received event for an unknown set.");
> +		fprintf(stderr, "W: Received event for an unknown set.\n");
>  		goto out;
>  	}
>  
> -- 
> 2.23.0
> 
