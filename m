From: Linus Torvalds <torvalds@osdl.org>
Subject: Re: 2.6.20-rc4: regression: iptables failed to load rules
Date: Wed, 10 Jan 2007 08:15:55 -0800 (PST)
Message-ID: <Pine.LNX.4.64.0701100803270.3594@woody.osdl.org>
References: <5157576d0701082329o1875911j20f6679e2d35bb17@mail.gmail.com>
 <Pine.LNX.4.64.0701090929160.3594@woody.osdl.org> <45A49C47.6080407@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Tomasz Kvarsin <kvarsin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>, bunk@stusta.de,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	netfilter@lists.netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S964934AbXAJQTi@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <45A49C47.6080407@trash.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org



On Wed, 10 Jan 2007, Patrick McHardy wrote:
> 
> In the x_tables case it really caused a lot of unnecessary confusion,
> the recent connection tracking changes however needed new config
> options since we're keeping the old implementation around for a few more
> releases.

It's too late now, but it _could_ have fairly easily been handled totally 
differently: namely by having the user-visible config options be 
INDEPENDENT of the actual back-end.

The Kconfig language is actually pretty powerful for configuration issues, 
and the way to do this is relatively straightforward:

	config CONNTRACK
		tristate "Netfilter support"
		...

	config NEW_CONTRACK_SUPPORT
		bool "Layer 3 Independent Connection tracking"
		...

	config CONNTRACK_MARK
		bool  'Connection mark tracking support'
		depends on CONNTRACK
		...

	config OLD_CONNTRACK_MARK
		bool
		depends on CONNTRACK_MARK && CONNTRACK && !NEW_CONTRACK_SUPPORT
		default y

	config NEW_CONNTRACK_MARK
		bool
		depends on CONNTRACK_MARK && CONNTRACK && NEW_CONTRACK_SUPPORT
		default y

See? The _user_ just sees a single "CONNTRACK_MARK" option (that just 
depends on the *generic* CONNTRACK config option), but then the Kconfig 
file splits that into "OLD_CONNTRACK_MARK" or "NEW_CONNTRACK_MARK" 
depending on whether "NEW_CONTRACK_SUPPORT" was set or not.

> It probably won't be necessary anymore to make changes like this in
> the future, but in case it is I'll make sure to at least provide
> compatibility options for a few releases.

In general, I'd much rather see the config options impact what the "user 
experience" should be. Notice how the above does exactly that: all the 
USER really cares about whether the connection marks are enabled or not, 
and the "NEW_CONTRACK_SUPPORT" is _not_ part of the user-visible config 
(apart from the _one_ question that asks about which implementation you 
want to pick), but it is only used to pick which _implementation_ to 
choose.

So making the Kconfig files more user-oriented and less implementation- 
oriented automatically solves the problem with config options that change 
names (because if the effect is the same, it should have the same name - 
regardless of how it is implemented!).

		Linus
