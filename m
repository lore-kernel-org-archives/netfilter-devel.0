Return-Path: <SRS0=wLp+=YK=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C86FBECE58E
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 11:14:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A531A2082C
	for <netfilter-devel@archiver.kernel.org>; Thu, 17 Oct 2019 11:14:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2502090AbfJQLOm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 17 Oct 2019 07:14:42 -0400
Received: from correo.us.es ([193.147.175.20]:51420 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406044AbfJQLOm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 17 Oct 2019 07:14:42 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 27F4311EB92
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Oct 2019 13:14:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 178F5B8011
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Oct 2019 13:14:37 +0200 (CEST)
Received: by antivirus1-rhel7.int (Postfix, from userid 99)
        id 16408B8007; Thu, 17 Oct 2019 13:14:37 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 1ED3ECE17F;
        Thu, 17 Oct 2019 13:14:35 +0200 (CEST)
Received: from 192.168.1.97 (192.168.1.97)
 by antivirus1-rhel7.int (F-Secure/fsigk_smtp/550/antivirus1-rhel7.int);
 Thu, 17 Oct 2019 13:14:35 +0200 (CEST)
X-Virus-Status: clean(F-Secure/fsigk_smtp/550/antivirus1-rhel7.int)
Received: from us.es (sys.soleta.eu [212.170.55.40])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: 1984lsi)
        by entrada.int (Postfix) with ESMTPSA id F0A7042EE38E;
        Thu, 17 Oct 2019 13:14:34 +0200 (CEST)
Date:   Thu, 17 Oct 2019 13:14:37 +0200
X-SMTPAUTHUS: auth mail.us.es
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Phil Sutter <phil@nwl.cc>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [nft PATCH 4/4] rule: Fix for single line ct timeout printing
Message-ID: <20191017111437.6rhllpyuw3wbti56@salvia>
References: <20191016230322.24432-1-phil@nwl.cc>
 <20191016230322.24432-5-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016230322.24432-5-phil@nwl.cc>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Virus-Scanned: ClamAV using ClamSMTP
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Oct 17, 2019 at 01:03:22AM +0200, Phil Sutter wrote:
> Commit 43ae7a48ae3de ("rule: do not print semicolon in ct timeout")
> removed an extra semicolon at end of line, but thereby broke single line
> output. The correct fix is to use opts->stmt_separator which holds
> either newline or semicolon chars depending on output mode.

What output mode this breaks? It looks indeed like I overlook
something while fixing up this.

Thanks.

> Fixes: 43ae7a48ae3de ("rule: do not print semicolon in ct timeout")
> Signed-off-by: Phil Sutter <phil@nwl.cc>
> ---
>  src/rule.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/src/rule.c b/src/rule.c
> index 2d35bae44c9e5..3c7c8d63f8cdf 100644
> --- a/src/rule.c
> +++ b/src/rule.c
> @@ -1869,7 +1869,7 @@ static void obj_print_data(const struct obj *obj,
>  		nft_print(octx, "%s", opts->nl);
>  		nft_print(octx, "%s%sprotocol ", opts->tab, opts->tab);
>  		print_proto_name_proto(obj->ct_timeout.l4proto, octx);
> -		nft_print(octx, "%s", opts->nl);
> +		nft_print(octx, "%s", opts->stmt_separator);
>  		nft_print(octx, "%s%sl3proto %s%s",
>  			  opts->tab, opts->tab,
>  			  family2str(obj->ct_timeout.l3proto),
> -- 
> 2.23.0
> 
