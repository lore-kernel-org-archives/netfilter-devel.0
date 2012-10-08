From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: restore NOTRACK functionality, target
 aliasing
Date: Mon, 8 Oct 2012 10:37:21 +0200
Message-ID: <20121008083721.GA12128@1984>
References: <alpine.LNX.2.01.1210080141140.2933@nerf07.vanv.qr>
 <1349656356-10180-1-git-send-email-jengelh@inai.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51162 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752712Ab2JHIhZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Oct 2012 04:37:25 -0400
Content-Disposition: inline
In-Reply-To: <1349656356-10180-1-git-send-email-jengelh@inai.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Oct 08, 2012 at 02:32:36AM +0200, Jan Engelhardt wrote:
> Commit v1.4.16-1-g2aaa7ec is testing for real_name (not) being NULL
> which was always false (true). real_name was never NULL, so cs->jumpto
> would always be used, which rendered -j NOTRACK unusable, since the
> chosen real name.revision is for example NOTRACK.1, which does not exist
> at the kernel side.
> 
> 	# ./iptables/xtables-multi main4 -t raw -A foo -j NOTRACK
> 	dbg: Using NOTRACK.1
> 	WARNING: The NOTRACK target is obsolete. Use CT instead.
> 	iptables: Protocol wrong type for socket.
> 
> To reasonably support the extra-special verdict names, make it so that
> real_name remains NULL when an extension defined no alias, which we can
> then use to determine whether the user entered an alias name (which
> needs to be followed) or not.

I have applied this and made a new release.

I kindly told you. I don't want late patches to hit iptables if I'm
about to release it, ie. close to when the Linux kernel comes out.

The reason was that chances to hit bugs and not noticing becomes
higher. In other words, stick to conservative mode.

Let this serve as proof of it.

You disregarded my advice and now we have this shame, three releases
in one day just because of rushing.
