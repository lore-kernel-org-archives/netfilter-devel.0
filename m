From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 8/8] Implement AF_UNSPEC as a wildcard for extensions
Date: Mon, 14 Apr 2008 08:47:43 +0200
Message-ID: <4802FE0F.7050403@trash.net>
References: <1208075154-5666-1-git-send-email-jengelh@computergmbh.de> <086a05074b7e86f9d4421abf968dce3109c62390.1208075035.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63335 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753061AbYDNGrs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 02:47:48 -0400
In-Reply-To: <086a05074b7e86f9d4421abf968dce3109c62390.1208075035.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> When a match or target is registered using
> xtables_register_{match,target}, xtables.c will consider AF_UNSPEC as
> a wildcard when specified as the .family member. Rules between
> two competing matches/targets are:
> 
> - higher revision (if usable in kernel) wins over lower revision
> - in case of same revision: generic AF_UNSPEC loses to specific AF_...
> ---
>  extensions/libxt_CLASSIFY.c  |   17 +---------------
>  extensions/libxt_MARK.c      |   18 +----------------
>  extensions/libxt_RATEEST.c   |   22 ++-----------------
>  extensions/libxt_SECMARK.c   |   18 +----------------
>  extensions/libxt_TRACE.c     |   13 +-----------
>  extensions/libxt_length.c    |   17 +---------------
>  extensions/libxt_limit.c     |   17 +---------------
>  extensions/libxt_mark.c      |   36 +--------------------------------
>  extensions/libxt_pkttype.c   |   17 +---------------
>  extensions/libxt_quota.c     |   16 +--------------
>  extensions/libxt_rateest.c   |   21 ++-----------------
>  extensions/libxt_standard.c  |   13 +-----------
>  extensions/libxt_statistic.c |   18 +----------------
>  extensions/libxt_string.c    |   19 +-----------------
>  extensions/libxt_time.c      |   17 +---------------
>  extensions/libxt_u32.c       |   17 +---------------
>  xtables.c                    |   22 +++++++++++++++-----
>  17 files changed, 37 insertions(+), 281 deletions(-)

Applied.
