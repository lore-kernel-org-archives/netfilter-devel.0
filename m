From: Bart De Schuymer <bdschuym@telenet.be>
Subject: Re: 2.6.12: connection tracking broken?
Date: Mon, 20 Jun 2005 06:39:35 +0000
Message-ID: <1119249575.3387.3.camel@localhost.localdomain>
References: <E1Dk9nK-0001ww-00@gondolin.me.apana.org.au>
	 <Pine.LNX.4.62.0506200432100.31737@kaber.coreworks.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Herbert Xu <herbert@gondor.apana.org.au>, bdschuym@pandora.be,
	netfilter-devel@manty.net, netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org, ebtables-devel@lists.sourceforge.net,
	rankincj@yahoo.com
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S261472AbVFTG0k@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <Pine.LNX.4.62.0506200432100.31737@kaber.coreworks.de>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Op ma, 20-06-2005 te 04:45 +0200, schreef Patrick McHardy:
> On Mon, 20 Jun 2005, Herbert Xu wrote:
> > Patrick McHardy <kaber@trash.net> wrote:
> >>
> >> The bridge-netfilter code defers calling of some NF_IP_* hooks to the
> >> bridge layer, when the conntrack reference is already gone, so the entry
> >
> > Why does it defer them at all? Shouldn't the fact that the device is
> > bridged be transparent to the IP layer?
> 
> I couldn't figure out the reason, it seems to have something to do
> with setting up device pointers for iptables and ebtables. It looks
> like the only way to fix this problem without keeping the conntrack
> reference while packets are queued at the device is to avoid defering
> the NF_IP_* hooks. Bart, can you explain why the hooks are defered
> please?

This is done so that iptables knows which bridge port the output device
is, using the iptables physdev match.

Can't you release the conntrack reference with a function registered on
the POSTROUTING hook with a prio higher than nat POSTROUTING (or
something like that)?

cheers,
Bart
