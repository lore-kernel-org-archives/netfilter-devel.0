From: Patrick McHardy <kaber@trash.net>
Subject: Re: nf-next: TEE and nesting
Date: Wed, 31 Mar 2010 12:33:25 +0200
Message-ID: <4BB324F5.10000@trash.net>
References: <1270031487-15094-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59317 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933184Ab0CaKd1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Mar 2010 06:33:27 -0400
In-Reply-To: <1270031487-15094-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> next on the calendar is the xt_TEE submission.
> 
> 
> The following changes since commit b44672889c11e13e4f4dc0a8ee23f0e64f1e57c6:
>   Jan Engelhardt (1):
>         netfilter: xtables: merge registration structure to NFPROTO_UNSPEC
> 
> are available in the git repository at:
> 
>   git://dev.medozas.de/linux master
> 
> Jan Engelhardt (5):
>       netfilter: ipv6: move POSTROUTING invocation before fragmentation
>       net: ipv6: add IPSKB_REROUTED exclusion to NF_HOOK/POSTROUTING invocation
>       netfilter: xtables: inclusion of xt_TEE
>       netfilter: xtables2: make ip_tables reentrant
>       netfilter: xt_TEE: have cloned packet travel through Xtables too

Please CC netdev since this includes larger changes to the IPv6 code.
