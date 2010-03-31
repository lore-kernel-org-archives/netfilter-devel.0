From: Patrick McHardy <kaber@trash.net>
Subject: Re: nf-next: error codes
Date: Wed, 31 Mar 2010 08:00:08 +0200
Message-ID: <4BB2E4E8.1070809@trash.net>
References: <1269533065-22318-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:54037 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932376Ab0CaGAL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Mar 2010 02:00:11 -0400
In-Reply-To: <1269533065-22318-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> (JFYI, the next pull group will be hashlimit v0 removal.)
> 
> 
> The following changes since commit 5dc7a6d5749d3ddbf9fbea9512cb45762428512c:
>   Jan Engelhardt (1):
>         netfilter: xt_recent: allow changing ip_list_[ug]id at runtime
> 
> are available in the git repository at:
> 
>   git://dev.medozas.de/linux master
> 
> Jan Engelhardt (12):
>       netfilter: bridge: use NFPROTO values for NF_HOOK invocation
>       netfilter: ipv4: use NFPROTO values for NF_HOOK invocation
>       netfilter: ipv6: use NFPROTO values for NF_HOOK invocation
>       netfilter: decnet: use NFPROTO values for NF_HOOK invocation
>       netfilter: ipvs: use NFPROTO values for NF_HOOK invocation
>       netfilter: xtables: untangle spaghetti if clauses in checkentry
>       netfilter: xtables: change xt_match.checkentry return type
>       netfilter: xtables: change xt_target.checkentry return type
>       netfilter: xtables: change matches to return error code
>       netfilter: xtables: change targets to return error code
>       netfilter: xtables: slightly better error reporting
>       netfilter: xtables: shorten up return clause

Pulled, thanks Jan.
