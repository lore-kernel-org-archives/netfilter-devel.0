From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 5/8] Combine ipt and ip6t manpages
Date: Mon, 14 Apr 2008 08:44:38 +0200
Message-ID: <4802FD56.3080707@trash.net>
References: <1208075154-5666-1-git-send-email-jengelh@computergmbh.de> <b99189c17a0a98eee21175c1ea2fe9818e4b2892.1208075035.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63266 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754205AbYDNGon (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Apr 2008 02:44:43 -0400
In-Reply-To: <b99189c17a0a98eee21175c1ea2fe9818e4b2892.1208075035.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> ---
>  extensions/libip6t_TCPMSS.man                      |   42 ----------
>  extensions/libip6t_connlimit.man                   |   27 -------
>  extensions/libip6t_length.man                      |    4 -
>  extensions/libip6t_multiport.man                   |   20 -----
>  extensions/libip6t_tcp.man                         |   45 -----------
>  extensions/libipt_TRACE.man                        |   10 ---
>  extensions/libipt_length.man                       |    4 -
>  extensions/libipt_policy.man                       |   48 ------------
>  extensions/{libipt_TCPMSS.man => libxt_TCPMSS.man} |    8 +-
>  extensions/{libip6t_TRACE.man => libxt_TRACE.man}  |    3 +-
>  .../{libipt_connlimit.man => libxt_connlimit.man}  |    0 
>  extensions/libxt_length.man                        |    5 +
>  .../{libipt_multiport.man => libxt_multiport.man}  |    0 
>  .../{libip6t_policy.man => libxt_policy.man}       |    0 
>  extensions/{libipt_tcp.man => libxt_tcp.man}       |    0 
>  15 files changed, 12 insertions(+), 204 deletions(-)
>  delete mode 100644 extensions/libip6t_TCPMSS.man
>  delete mode 100644 extensions/libip6t_connlimit.man
>  delete mode 100644 extensions/libip6t_length.man
>  delete mode 100644 extensions/libip6t_multiport.man
>  delete mode 100644 extensions/libip6t_tcp.man
>  delete mode 100644 extensions/libipt_TRACE.man
>  delete mode 100644 extensions/libipt_length.man
>  delete mode 100644 extensions/libipt_policy.man
>  rename extensions/{libipt_TCPMSS.man => libxt_TCPMSS.man} (77%)
>  rename extensions/{libip6t_TRACE.man => libxt_TRACE.man} (94%)
>  rename extensions/{libipt_connlimit.man => libxt_connlimit.man} (100%)
>  create mode 100644 extensions/libxt_length.man
>  rename extensions/{libipt_multiport.man => libxt_multiport.man} (100%)
>  rename extensions/{libip6t_policy.man => libxt_policy.man} (100%)
>  rename extensions/{libipt_tcp.man => libxt_tcp.man} (100%)

Please send a unidiff that includes all those renames
so I can apply it using "patch".
