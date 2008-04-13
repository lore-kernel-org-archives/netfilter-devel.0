From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 06/13] Move libipt_recent to libxt_recent
Date: Sun, 13 Apr 2008 07:16:45 +0200
Message-ID: <4801973D.3050702@trash.net>
References: <f8e3139e003f45acd60f10a40644de0ad1eefaec.1207813085.git.jengelh@computergmbh.de> <d3033172e8809e30f6ce06e9c7e1685bb7a61f86.1207813085.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33288 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882AbYDMFQt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Apr 2008 01:16:49 -0400
In-Reply-To: <d3033172e8809e30f6ce06e9c7e1685bb7a61f86.1207813085.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> ---
>  extensions/{libipt_recent.c => libxt_recent.c}     |  122 ++++++------
>  extensions/{libipt_recent.man => libxt_recent.man} |    2 +-
>  include/linux/netfilter/xt_recent.h                |   26 +++
>  include/linux/netfilter_ipv4/ipt_recent.h          |   27 ---
>  4 files changed, 88 insertions(+), 89 deletions(-)
>  rename extensions/{libipt_recent.c => libxt_recent.c} (67%)
>  rename extensions/{libipt_recent.man => libxt_recent.man} (99%)
>  create mode 100644 include/linux/netfilter/xt_recent.h
>  delete mode 100644 include/linux/netfilter_ipv4/ipt_recent.h

I'll apply this once I have a patch for the kenrel that I'm
willing to apply.
