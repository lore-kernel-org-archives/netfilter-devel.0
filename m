From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 09/13] manpages: fix broken markup (missing close tags)
Date: Sun, 13 Apr 2008 07:18:17 +0200
Message-ID: <48019799.20500@trash.net>
References: <f8e3139e003f45acd60f10a40644de0ad1eefaec.1207813085.git.jengelh@computergmbh.de> <ae230d6784ceb07a971dfaa80c1443dd0d44abf9.1207813085.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33319 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750915AbYDMFSV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 13 Apr 2008 01:18:21 -0400
In-Reply-To: <ae230d6784ceb07a971dfaa80c1443dd0d44abf9.1207813085.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Rework the whole line's markup at the same time.
> ---
>  extensions/libip6t_ah.man       |    2 +-
>  extensions/libip6t_dst.man      |    2 +-
>  extensions/libipt_connlimit.man |    2 +-
>  extensions/libxt_NFQUEUE.man    |    2 +-
>  extensions/libxt_connbytes.man  |    2 +-
>  extensions/libxt_dccp.man       |    4 ++--
>  extensions/libxt_recent.man     |    4 ++--

Applied with out the xt_recent bits.
