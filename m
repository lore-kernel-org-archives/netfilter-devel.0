From: Patrick Schaaf <bof@bof.de>
Subject: Re: [PATCH] multiple devices with ranges match support
Date: Thu, 19 Sep 2002 00:12:12 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020918221212.GG10465@oknodo.bof.de>
References: <638AA0336D7ED411928700D0B7B0D75B03053C9C@aimail.aiinet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <638AA0336D7ED411928700D0B7B0D75B03053C9C@aimail.aiinet.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, Sep 18, 2002 at 02:52:31PM -0400, Eble, Dan wrote:
> > -----Original Message-----
> > From: Jay Schulist [mailto:jschlst@linux-sna.org] 
> > mdev v1.2.7a options:
> ...
> >  --i dev[,dev:dev,dev...]       match inbound device(s)
> >  --o dev[,dev:dev,dev...]       match outbound device(s)
> 
> Would you ever want to use this on interfaces with secondary addresses, like
> eth0:4?  (Does that even matter?  I'm not too familiar with them; I just
> remember seeing that syntax.)

Their use is deprecated (use "ip addr add ..." instead), but it's
nevertheless a good idea to avoid actively breaking them. However,
if I remember correctly, they don't really appear as input or
output device of real packets in the kernel, so in this place,
it's probably OK to reuse ':'.

However, in general, I'm not so sure that it makes sense to expand
all kinds of match options into multidimensional specification
languages for arbitrary subsets of their keyspaces, with all kinds
of option specific shortcut forms for how ranges and patterns are
written. Each option becomes its own mini-language. I don't like.

What's wrong with the good old subchain, and several "-i dev" lines
branching off to there?

<evil-idea-mode>
Or, to turn the approach around 180 degree, what about a "chain" match,
to be used like this:
iptables -N mydevs
iptables -A mydevs -i eth+ -j ACCEPT
iptables -A mydevs -i tap+ -j ACCEPT
iptables -A mydevs -j DROP
...
iptables -A somewhere -m chain --chain mydevs -p tcp --dport 22
<evil-idea-mode/>

best regards
  Patrick

P.S.: My deepest apologies, Jay, for you receiving so many rants from
me this evening. Please, don't take them personally. I hope to help.
