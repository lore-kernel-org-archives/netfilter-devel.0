From: Davide <tatonet@tiscali.it>
Subject: Re: nf_conntrack
Date: Thu, 26 Feb 2004 13:20:08 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200402261320.08113.tatonet@tiscali.it>
References: <200402200942.13265.tato.net@tin.it> <200402221110.28339.tato.net@tin.it> <200402230527.OAA02726@toshiba.co.jp>
Reply-To: tatonet@tiscali.it
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200402230527.OAA02726@toshiba.co.jp>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Yasuyuki,

On Monday 23 February 2004 06:27, you wrote:

> > > You need to write NA(P)T-PT code based on nf_conntrack. Maybe IPv4 NAT
> > > codes help you. The biggest issue is how pass packets from IPv4 stack
> > > to IPv6 stack and vice versa. I imagine that addresses in packets are
> > > mangled at only NF_IP{6}_PRE_ROUNTING, and then called netif_rx().
> >
> > That was my first idea. But I've seen some code that makes use
> > ip_route_me_harder() + ip_output() for injecting IPv4 packets, and
> > ip6_route_me_harder() + ip6_output for IPv6 packets.
> > I fear that with netif_rx() traslated packet would be tracked again, and
> > this is not what I need. (I'm sorry but I'm still studying netfilter and
> > conntrack (and English too ;) ) so it's likely that I'm wrong).
>
> Sorry, I'm confusing. Which path should packets go through ? we need to
> design so that users can filter/log packets before and/or after
> translating. At least, translated packets should go through
> NF_IP{6}_FORWARD, I think.

I agree with you, users should be able to filter/log NAT(P)T-PT'ed packets. 
However there are some (bad) problems.
At present time your conntrack code doesn't handle IPv6 fragments, but I guess  
that when it will do, IPv6 datagrams will be defragmented as in current 
conntrack. So I assume that NA(P)T-PT code will see only entire l3 packets.

One problem is that I should know if original datagrams had a fragment header 
or not. NA(P)T-PT should produce IPv4 packets with DF flag set for IPv6 
non-fragment datagrams and IPv4 packets with DF not set for IPv6 datagrams 
with a fragment header. So, although on one hand I need conntrack, on the 
other hand I should see original datagrams.
A similar problem turns out on IPv4-to-IPv6 translation. When I receive IPv4 
datagrams with DF not set, I should fragment them so that their IPv6 
translation fits in 1280 octects. If DF flag is set, in order to allow 
pathMTU discovery, I should preserve their size and I should translate them 
into IPv6 datagram without a fragmentation header (except for IPv4 fragments 
with DF set...).
I'm trying to say (with my terrible English) that a NA(P)T-PT implementation 
should have more control over IPv6/IPv4 packets: since conntrack 
defragments/fragments them it's impossible to be RFC 2766 compliant.

For these reasons I'm tempted to use the approach proposed by Henrik (virtual 
network device).

Please correct me if I've made any mistakes.

BTW: I'm very happy that your conntrack will be put into patch-o-matic-ng ;)

Best regards,
Davide

-- 
T@1t
