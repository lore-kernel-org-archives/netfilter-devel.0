From: Patrick Schaaf <bof@bof.de>
Subject: Re: [PATCH] big endian patch against netfilter after PPTP NAT pat ch
Date: Sun, 9 Feb 2003 17:53:47 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030209165347.GA1737@oknodo.bof.de>
References: <771F217D7A4AF84494632457889470A412D77E@bcmsg011.corp.ads> <3E41A7BC.20209@snapgear.com> <20030209092911.GO13269@naboo.fugue.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20030209092911.GO13269@naboo.fugue.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> yes.  David Miller has indicated that he wants us to use
> individual-member initialization instead of our '{{{{ }}, }}' stuff.
> So maybe this is the time to do the change - or at least use named
> initializers like '{ asdf: 0xffff, }'

Nowaways, we'd rather use the C99 syntax: { .asdf = 0xffff, }.

I'm all for a change towards such initializers; the current stuff
is completely opaque.

best regards
  Patrick
