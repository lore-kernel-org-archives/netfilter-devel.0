From: Jean-Francois Dive <jef@linuxbe.org>
Subject: Re: 2.6 IPSEC + SNAT
Date: Wed, 01 Oct 2003 14:43:52 +0200
Sender: linux-net-owner@vger.kernel.org
Message-ID: <1065012231.2121.37.camel@gardafou>
References: <20031001121648.GA8755@gondor.apana.org.au>
Reply-To: jef@linuxbe.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: kuznet@ms2.inr.ac.ru, davem@redhat.com, jmorris@redhat.com,
	linux-net@vger.kernel.org, netfilter-devel@lists.netfilter.org
Return-path: <linux-net-owner@vger.kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>
In-Reply-To: <20031001121648.GA8755@gondor.apana.org.au>
List-Id: netfilter-devel.vger.kernel.org

the problem is the order of operation, but both ways have their
drawbacks:

- NAT - IPSec: well Herbert's bug report get fixed, i even suppose you
do some nat to get the traffic match the selectord, this is nice, but
when the packet get detranslated, you then should check policy on
denated packets, this mean that you may miss policy check failures: what
will be the packet after detranslation, you rely on NAT to do this check
and have firewall to feel good about it. For exemple in static nat
entries, one could see a cleartext packet arrive with the NAT'ed
addresses, pass the
"receive_cleartext_packet_but_they_should_be_encrypted" test, get
denated and pop in the inside network.

- IPSec - NAT: well this make the attempt not working but you do enforce
policy checks on packets before they get NAT worked on.

At the end, having the choice (NAT before or after) would be off course
the best, but...

just my 2 cents.

JeF

On Wed, 2003-10-01 at 14:16, Herbert Xu wrote:
> Hi:
> 
> I have received bug reports saying that SNAT does not work when the
> packets have to be SNATed before they can enter an IPSEC tunnel
> under the 2.6 IPSEC stack.
> 
> The problem is that SNAT can only be performed in POSTROUTING while
> IPSEC policy lookups are done at the same time as the route lookup.
> 
> Has anyone else thought about this problem?
> 
> I have considered introducing a new NAT chain between filtering
> and routing where you can place SNAT rules into.  Of course, the
> same thing applies to reverse DNAT rules as well.
> 
> Any opinions on this would be appreciated.
> 
> Thanks,
-- 

-> Jean-Francois Dive
--> jef@linuxbe.org

I think that God in creating Man somewhat overestimated his ability.
-- Oscar Wilde

