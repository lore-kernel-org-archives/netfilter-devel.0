From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2/5] netfilter: xt extensions: use pr_<level> (2)
Date: Thu, 25 Mar 2010 15:10:19 +0100
Message-ID: <4BAB6ECB.90706@trash.net>
References: <1269521809-29393-1-git-send-email-jengelh@medozas.de> <1269521809-29393-3-git-send-email-jengelh@medozas.de> <4BAB604A.2090808@trash.net> <alpine.LSU.2.01.1003251414350.30248@obet.zrqbmnf.qr> <4BAB64D1.2070404@trash.net> <alpine.LSU.2.01.1003251443530.32573@obet.zrqbmnf.qr> <4BAB6C4F.9040002@trash.net> <alpine.LSU.2.01.1003251502320.32573@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:52759 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754485Ab0CYOKT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Mar 2010 10:10:19 -0400
In-Reply-To: <alpine.LSU.2.01.1003251502320.32573@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Branch has been prepared with the requested changes.
> 
> The following changes since commit 2c46cd8163b25bf6f38e612e9f1d162f0357c8f1:
>   Zhitong Wang (1):
>         netfilter: remove unused headers in net/ipv4/netfilter/nf_nat_h323.c
> 
> are available in the git repository at:
> 
>   git://dev.medozas.de/linux master
> 
> Jan Engelhardt (5):
>       netfilter: xtables: make use of caller family rather than target family
>       netfilter: xt extensions: use pr_<level> (2)
>       netfilter: xtables: make use of xt_request_find_target
>       netfilter: xtables: consolidate code into xt_request_find_match
>       netfilter: xt_recent: allow changing ip_list_[ug]id at runtime

Pulled, thanks Jan.
