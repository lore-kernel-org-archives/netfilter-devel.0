From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables: guided option parser, run 4
Date: Mon, 09 May 2011 11:26:51 +0200
Message-ID: <4DC7B35B.8030800@trash.net>
References: <1304250630-6150-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48520 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750814Ab1EIJ0z (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 May 2011 05:26:55 -0400
In-Reply-To: <1304250630-6150-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 01.05.2011 13:50, schrieb Jan Engelhardt:
> The following changes since commit 26ed9ea93564bb5ffdb5238eaa202cd9bcf6d6d1:
> 
>   combine ip6?tables-multi into xtables-multi (2011-04-19 18:22:11 -0700)
> 
> are available in the git repository at:
>   git://dev.medozas.de/iptables opts
> 
> Jan Engelhardt (9):
>       build: bump libxtables ABI version
>       libxt_TEE: use guided option parser
>       xtoptions: respect return value in xtables_getportbyname
>       libxt_TOS: use guided option parser
>       libxt_tos: use guided option parser
>       extensions: remove unused TOS code
>       libxtables: XTTYPE_PORTRC support
>       libxt_udp: use guided option parser
>       libxt_dccp: use guided option parser


Pulled, thanks Jan.
