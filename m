From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: iptables calls setsockopt incorrectly
Date: Thu, 8 Aug 2013 19:29:02 +0200
Message-ID: <20130808172902.GA11296@localhost>
References: <CA+0KVf052HAN73aMrM95aosN-=49Esam1spX=sUyvd61sDYDRA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: "Laurence J. Lane" <ljlane@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33160 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965704Ab3HHR3M (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Aug 2013 13:29:12 -0400
Content-Disposition: inline
In-Reply-To: <CA+0KVf052HAN73aMrM95aosN-=49Esam1spX=sUyvd61sDYDRA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Laurence,

On Thu, Aug 08, 2013 at 01:25:46PM -0400, Laurence J. Lane wrote:
> https://bugs.launchpad.net/ubuntu/+source/iptables/+bug/1187177
> http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=710997
> 
> 
> ---------- Forwarded message ----------
> From: LaMont Jones <lamont@debian.org>
> Date: Mon, Jun 3, 2013 at 6:07 PM
> Subject: Bug#710997: iptables calls setsockopt incorrectly
> To: submit@bugs.debian.org
> 
> 
> Package: iptables
> Version: 1.4.18-1
> Tags: patch
> --
> 
> Since time immemorial, iptables has called setsockopt() and treated any
> -1 return value as fatal.  Any system call can return EAGAIN or
> EINPROGRESS (depending on the origins of the API), and good coding
> practice requires checking for that and retrying or otherwise handling
> it.
> 
> In the case of iptables, if multiple processes are calling iptables
> concurrently, then it is likely that one of them will fail.  I have seen
> this with xen, as well as certain firewall configurations where the
> firewall rules are added as triggered by interfaces being discovered and
> configured.

We have these two patch for to address this in mainstream:

http://git.netfilter.org/iptables/commit/?id=93587a04d0f2511e108bbc4d87a8b9d28a5c5dd8
http://git.netfilter.org/iptables/commit/?id=d7aeda5ed45ac7ca959f12180690caa371b5b14b

Regards.
