From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 3/4] [LIBNETFILTER_CONNTRACK] snprintf: remove duplicate
 initializer entry
Date: Thu, 08 Oct 2009 18:02:23 +0200
Message-ID: <4ACE0D0F.5010809@netfilter.org>
References: <20091007123624.5204.92195.stgit@lb64> <20091007123902.5204.28787.stgit@lb64>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Hannes Eder <heder@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49002 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757541AbZJHQJs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Oct 2009 12:09:48 -0400
In-Reply-To: <20091007123902.5204.28787.stgit@lb64>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hannes Eder wrote:
> diff --git a/src/conntrack/snprintf.c b/src/conntrack/snprintf.c
> index 452d62f..1104c63 100644
> --- a/src/conntrack/snprintf.c
> +++ b/src/conntrack/snprintf.c
> @@ -21,7 +21,6 @@ const char *proto2str[IPPROTO_MAX] = {
>  	[IPPROTO_ICMPV6]		= "icmpv6",
>  	[IPPROTO_SCTP]			= "sctp",
>  	[IPPROTO_GRE]			= "gre",
> -	[IPPROTO_UDPLITE]		= "udplite",
>  	[IPPROTO_DCCP]			= "dccp",
>  };

Applied, thanks!
