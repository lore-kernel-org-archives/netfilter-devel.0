From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables: connlimit dstaddr support
Date: Thu, 20 Jan 2011 11:21:47 +0100
Message-ID: <4D380CBB.9020804@trash.net>
References: <1295458349-14106-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, jan.rovner@diadema.cz
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33102 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755215Ab1ATKVu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jan 2011 05:21:50 -0500
In-Reply-To: <1295458349-14106-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 19.01.2011 18:32, schrieb Jan Engelhardt:
> The following changes since commit 9c60365e043a430f74115bbfaf58ce0df7585f49:
> 
>   libxt_quota: print negation when it has been selected (2011-01-18 11:02:04 +0100)
> 
> are available in the git repository at:
>   git://dev.medozas.de/iptables master
> 
> Jan Engelhardt (3):
>       libxt_connlimit: reword help text to say prefix length
>       libxt_connlimit: add a --connlimit-upto option
>       libxt_connlimit: support for dstaddr-supporting revision 1
> 

Pulled, thanks Jan.
