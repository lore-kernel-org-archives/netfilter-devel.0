From: Chris Frey <cdfrey@netdirect.ca>
Subject: Re: [2.4.23] compile / link error in net/ipv4/netfilter
Date: Tue, 2 Dec 2003 14:22:35 -0500
Sender: linux-kernel-owner@vger.kernel.org
Message-ID: <20031202142235.A6455@netdirect.ca>
References: <20031201202853.A31914@netdirect.ca> <20031202082333.GI546@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner+linux-kernel=40quimby.gnus.org@vger.kernel.org>
To: Harald Welte <laforge@netfilter.org>, linux-kernel@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20031202082333.GI546@obroa-skai.de.gnumonks.org>; from laforge@netfilter.org on Tue, Dec 02, 2003 at 01:53:33PM +0530
List-Id: netfilter-devel.vger.kernel.org

On Tue, Dec 02, 2003 at 01:53:33PM +0530, Harald Welte wrote:
> This is illegal, and 'make menuconfig' or 'make xconfig' should not
> allow you to combine the two of them.  Please describe how you managed
> to do that ;)

I had them all turned on as modules in an old config that I loaded, and
then turned module support off.

In theory the build system should prevent this, but I can see how that might
be hard to code (I'm not up to speed with the 2.4 build system internals)
so I called it user error on my part and continued on. :-)

- Chris
