From: Willy Tarreau <willy@w.ods.org>
Subject: Re: [PATCH]: latest netfilter+ipsec patches
Date: Fri, 5 Mar 2004 00:11:41 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040304231141.GA1782@alpha.home.local>
References: <20040127130739.GR11761@sunbeam.de.gnumonks.org> <20040128000938.GH11761@sunbeam.de.gnumonks.org> <401777B4.9020000@trash.net> <20040128103000.GP11761@sunbeam.de.gnumonks.org> <401D12B6.5030707@trash.net> <40301AB2.2030103@trash.net> <40337D63.6080602@trash.net> <20040218220337.GA3193@alpha.home.local> <40356624.6050209@trash.net> <4047AE0E.1080003@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
   Harald Welte <laforge@netfilter.org>,
   Henrik Nordstrom <hno@marasystems.com>, Tom Eastep <teastep@shorewall.net>,
   Michal Ludvig <mludvig@suse.cz>, alex@samad.com.au, guillaume@morinfr.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <4047AE0E.1080003@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Patrick,

On Thu, Mar 04, 2004 at 11:30:38PM +0100, Patrick McHardy wrote:
> (long CC list, if anyone doesn't want to be on it anymore please say so)

no pb, please keep me in :-)

> - hook-traversal on input is symetrical to output now. This means
> packets will traverse PRE_ROUTING/LOCAL_IN before decryption and
> PRE_REROUTING/LOCAL_IN or PRE_ROUTING/FORWARD afterwards.

This is excellent. So if I understand it right, a packet now passes this way
(please excuse the ascii-art, it seems I'll never take the time to start xfig)

            [incoming packet]
                    |<-----------------. 
                    v                  |
               PREROUTING              |
    dest!=local?  /  \  dest==local?   |
                /      \               |
         FORWARD        LOCAL_IN       |
             |            |            |
             |      (ipsec?decrypt:nop)|
             |            |   \        / dest!=local ? nf_postxfrm_nonlocal()
             |            |    `------'
             v            v  dest==local ? ip_local_deliver_finish()


So if it behaves like this (which is what seems the best solution to me), is
there a risk that a carefully crafted packet loops many times on the right
side (multiple encapsulation with local DIP) ? And if so, is it risky or not,
wrt resource leak, multiple locks, etc... ?

> The only problem with this approach I'm currently aware of is that
> one of the ip-protocol handlers marked with xfrm_prot
> (xfrm4_tunnel.c) is also responsible for dispatching packets to
> ipip.c; the encapsulated packets heading for a ipip-tunnel won't
> traverse the netfilter hooks on input.

I don't know well the internals of IPSEC (bought the book but didn't read it
yet). Are IPIP tunnels often used ? or are they simply used according to a
negociation, in which case the ipsec implementation on the netfilter side
could refuse them ?

> - new match "policy" for matching the policy that was used during
> decapsulation (well, the used SAs, policy checks come later), and the
> policy that will be used for encapsulation.

Even more interesting... Now we can for sure check that packets coming from
a tunnel have not been spoofed by another tunnel.

Thanks a lot Patrick.
My main goal is to use this on 2.4 with davem/herbert xu's ipsec backport.
I will soon check if your patches apply on top of their implementation.

Cheers,
Willy
