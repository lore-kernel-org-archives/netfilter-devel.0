From: Greg KH <greg@kroah.com>
Subject: Re: [stable] [NETFILTER] xt_pkttype match fixes
Date: Mon, 14 Jan 2008 15:07:11 -0800
Message-ID: <20080114230711.GA8342@kroah.com>
References: <Pine.LNX.4.64.0712220340490.8607@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kaber@trash.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, stable@kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:39954 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751681AbYANXK3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Jan 2008 18:10:29 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0712220340490.8607@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Dec 22, 2007 at 03:41:29AM +0100, Jan Engelhardt wrote:
> 
> We were always interpreting an IPv6 packet as IPv4, but
> ipv4_is_multicast() is only valid for AF_INET (obviously). Fix this
> by adding an extra condition to check for AF_INET.
> 
> Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

Did this ever go into Linus's tree?  I don't see it there, and as such,
I can't take this for the -stable tree, sorry.

thanks,

greg k-h
