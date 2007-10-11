From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Add ip6t_ aliases
Date: Thu, 11 Oct 2007 06:08:08 +0200
Message-ID: <470DA1A8.9060300@trash.net>
References: <Pine.LNX.4.64.0710101342430.22916@fbirervta.pbzchgretzou.qr> <20071010.163346.54951705.davem@davemloft.net> <Pine.LNX.4.64.0710110138190.26305@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: David Miller <davem@davemloft.net>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46903 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829AbXJKEIK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Oct 2007 00:08:10 -0400
In-Reply-To: <Pine.LNX.4.64.0710110138190.26305@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jan Engelhardt wrote:
>>> Add missing ip6t_modulename aliases.
> 
> Oops. But please remove the hunk for xt_conntrack.c before applyign, I
> just noticed it does not do AF_INET6.


Done and applied, thanks Jan.
