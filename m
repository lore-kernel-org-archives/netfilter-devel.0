From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 04/24] Drop -W from CFLAGS and some tiny code cleanups
Date: Sun, 06 Apr 2008 17:33:17 +0200
Message-ID: <47F8ED3D.8060608@trash.net>
References: <1207495642-21055-1-git-send-email-jengelh@computergmbh.de> <061d258929606e444537930d3e243b5b8921ffcd.1207495183.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37172 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259AbYDFPdJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Apr 2008 11:33:09 -0400
In-Reply-To: <061d258929606e444537930d3e243b5b8921ffcd.1207495183.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> - change "unsigned" to explicit "unsigned int"
> - remove some casts
> ---
>  configure.ac                   |    2 +-
>  extensions/dscp_helper.c       |    2 +-
>  extensions/libip6t_dst.c       |    2 +-
>  extensions/libip6t_hbh.c       |    2 +-
>  extensions/libip6t_rt.c        |    2 +-
>  extensions/libipt_SAME.c       |    6 +++---
>  extensions/libxt_TCPOPTSTRIP.c |    2 +-
>  extensions/libxt_quota.c       |    2 +-
>  iptables-xml.c                 |   14 +++++++-------
>  xtables.c                      |    2 +-
>  10 files changed, 18 insertions(+), 18 deletions(-)

Applied.
