From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables patches 20110710
Date: Mon, 11 Jul 2011 10:41:37 +0200
Message-ID: <4E1AB741.6060103@trash.net>
References: <1310322139-28505-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45249 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757414Ab1GKIlk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Jul 2011 04:41:40 -0400
In-Reply-To: <1310322139-28505-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 10.07.2011 20:22, schrieb Jan Engelhardt:
> The following changes since commit 795ea2e8d4d9f01a606d0d7aac22572801e06989:
> 
>   Merge branch 'master' of git://dev.medozas.de/iptables (2011-07-05 15:16:05 +0200)
> 
> are available in the git repository at:
> 
>   git://dev.medozas.de/iptables master
> 
> Jan Engelhardt (6):
>       libxtables: properly reject empty hostnames
>       libxtables: ignore whitespace in the multiaddress argument parser
>       option: remove last traces of intrapositional negation
>       libxtables: set clone's initial data to NULL
>       libxt_conntrack: restore network-byte order for v1,v2
>       libxt_conntrack: move more data into the xt_option_entry


Pulled, thanks Jan.
