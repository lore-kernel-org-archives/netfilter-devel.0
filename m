From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 00/13] ipset kernel patches v3
Date: Tue, 01 Feb 2011 15:18:49 +0100
Message-ID: <4D481649.3080109@trash.net>
References: <1296514388-20900-1-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:43098 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756921Ab1BAOTM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Feb 2011 09:19:12 -0500
In-Reply-To: <1296514388-20900-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 31.01.2011 23:52, schrieb Jozsef Kadlecsik:
> Hi,
> 
> Here follows the updated ipset kernel patches. The list of changes compared
> to the previous one:
> 
> - Separate ipset errnos completely from system ones and bump protocol
>   version
> - Use better error codes in xt_set.c
> - Fix sparse warning about shadowed definition
> - bitmap:ip type: flavour specific adt functions
> - bitmap:port type: flavour specific adt functions
> - Move the type specificic attribute validation to the core
> - Use vzalloc() instead of __vmalloc()
> - Use meaningful error messages in xt_set.c
> - Constified attribute cannot be written
> - Send (N)ACK at dumping only when NLM_F_ACK is set
> - Correct the error codes: use ENOENT and EMSGSIZE
> 
> [Because the protocol changed (NLM_F_ACK is used at dumping and error codes
> are changed), the protocol version number is incremented.]
> 
> Best regards,
> Jozsef
> 
> Jozsef Kadlecsik (13):
>   NFNL_SUBSYS_IPSET id and NLA_PUT_NET* macros
>   IP set core support
>   bitmap:ip set type support
>   bitmap:ip,mac type support
>   bitmap:port set type support
>   hash:ip set type support
>   hash:ip,port set type support
>   hash:ip,port,ip set type support
>   hash:ip,port,net set type support
>   hash:net set type support
>   hash:net,port set type support
>   list:set set type support
>   "set" match and "SET" target support

Thanks Jozsef. I don't see any major issues with the API and anything
else can be changed more easily once this is in the tree, so I'll apply
everything and will probably send a few minor cleanups on top later.

