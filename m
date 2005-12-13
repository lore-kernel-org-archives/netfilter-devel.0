From: Balazs Scheidler <bazsi@balabit.hu>
Subject: Re: (D)NAT with IPv6 (was "nf_conntrack & NAT")
Date: Tue, 13 Dec 2005 09:57:17 +0100
Message-ID: <1134464237.14327.5.camel@bzorp.balabit>
References: <20051123132419.GJ24091@fi.muni.cz>
	<20051206154320.GG4038@rama.exocore.com>
	<20051206173135.GQ5617@eychenne.org>
	<Pine.LNX.4.58.0512071201460.17863@blackhole.kfki.hu>
	<20051207145438.GA5617@eychenne.org>
	<Pine.LNX.4.58.0512071603190.17863@blackhole.kfki.hu>
	<20051208114120.GF5617@eychenne.org>
	<20051208115632.GB13067@oknodo.bof.de>
	<20051209045759.GD4244@rama.exocore.com>
	<1134420153.4093.12.camel@bzorp.balabit>
	<20051212225614.GB685@samad.com.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Alexander Samad <alex@samad.com.au>
In-Reply-To: <20051212225614.GB685@samad.com.au>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 2005-12-13 at 09:56 +1100, Alexander Samad wrote:
> Has the issue of trying to load balance serveral machine behind a nat
> box been brought up for ipv6, if DNAT (and SNAT) are not available for
> ipv6 how are you going to hid a farm of servers behind a single (or
> multiple addresses), DNS round robin doesn't work because it doesn't
> take into account weather the ip is active or not ?

You could do something similar with policy routing, e.g. mark the
connections based on your load-balancing decision and have routing to
direct packets based on this mark to the appropriate boxes, e.g. select
next-hop based on connection mark.

Now it is only a question of the servers whether they are willing to
serve connections originally destined to a different IP address. (this
requires something like tproxy to work).

Of course the above is not optimal as it is not transparent to the
servers involved, but can be solved nevertheless.

Alternatively you can do it from userspace with some kernel backing to
avoid copying data to userspace (e.g. establish two IPv6 connections the
way you like and ask a kernel function to copy data on the two separate
sockets). It is not as fast as forwarding but I doubt it would be much
slower than the current NAT framework.

-- 
Bazsi
