From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC] SSDP (UPnP) conntrack helper
Date: Fri, 24 Feb 2012 17:53:59 +0100
Message-ID: <20120224165359.GB11488@1984>
References: <jhkpju$dsp$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ian Pilcher <arequipeno@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36857 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755363Ab2BXQyE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Feb 2012 11:54:04 -0500
Content-Disposition: inline
In-Reply-To: <jhkpju$dsp$1@dough.gmane.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 16, 2012 at 11:46:38PM -0600, Ian Pilcher wrote:
> Attached is my first crack at a conntrack helper for SSDP, which is used
> by DLNA/UPnP clients to discover media servers.

We're targeting to have this helper and others in user-space in the
short tun.

I have a patch to add user-space helper infrastructure. I expect to
have it done soon.

I think it's time to think about having helpers in user-space.
