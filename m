From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] build: resolve build error involving libnftnl
Date: Wed, 15 Jul 2015 18:28:31 +0200
Message-ID: <20150715162831.GA14319@salvia>
References: <1436964819-28109-1-git-send-email-jengelh@inai.de>
 <1436964819-28109-2-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46233 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752340AbbGOQWs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jul 2015 12:22:48 -0400
Content-Disposition: inline
In-Reply-To: <1436964819-28109-2-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 15, 2015 at 02:53:38PM +0200, Jan Engelhardt wrote:
> make[2]: Entering directory '/home/jengelh/code/iptables/extensions'
>   CC       libebt_limit.oo
> In file included from ../iptables/nft.h:5:0,
>                  from libebt_limit.c:21:
> ../iptables/nft-shared.h:6:27: fatal error: libnftnl/rule.h: No such file or directory
>  #include <libnftnl/rule.h>
>                            ^
> compilation terminated.

Applied, thanks.
