From: Patrick McHardy <kaber@trash.net>
Subject: Re: Why does ipv6 enabled interfere with ipv4 SNAT?
Date: Wed, 02 Apr 2008 12:26:34 +0200
Message-ID: <47F35F5A.50209@trash.net>
References: <20080325012807.GA15637@transpect.com> <alpine.LNX.1.10.0803250254100.9368@fbirervta.pbzchgretzou.qr> <20080325024424.GA16089@transpect.com> <Pine.LNX.4.64.0803251156560.1535@blackhole.kfki.hu> <20080325142553.GA8783@transpect.com> <47E91FEF.9080705@trash.net> <20080327141026.GA3288@transpect.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Jan Engelhardt <jengelh@computergmbh.de>,
	netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Whit Blauvelt <whit@transpect.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <20080327141026.GA3288@transpect.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Whit Blauvelt wrote:
> On Tue, Mar 25, 2008 at 04:53:19PM +0100, Patrick McHardy wrote:
> 
>> Please post the list of modules loaded and the output of
>> /proc/net/nf_conntrack.
> 
> First here is the list by the system in question, working once the ipv6
> module is blocked from loading at boot. Next is the list from a system with
> identical hardware and near-identical configuration (same firewall rules),
> but with ipv6 loading - and which also has only 4 of the 6 NICs showing up
> in the ipv6 proc conf space, and also has NAT (in this case DNAT is what I
> tested) failing - also where the NICs on the Internet side of things are
> those coincidentally not showing up with proc ipv6 conf settings. 

The firewall rules appear to be different between the two systems,
the first one has a lot more references to the IPv4 conntrack module.

> As to the output of /proc/net/nf_conntrack, you just want to see anything,
> or under specific load? I'm not going to just publicly post the raw data -
> although both systems have some there - since IPs can identify my client and
> their clients, which would violate confidentiality.

I'm mainly interested in one or more of the conntrack entries that
should get NATed but don't. One entry should be enough, feel free
to replace IPs as long as similar IPs still are similar.

> 
> Okay, the fixed system:
> 
> Module                  Size  Used by
> ...
 > iptable_nat             8708  1
 > nf_nat                 20012  2 nf_nat_ftp,iptable_nat
 > nf_conntrack_ipv4      19724  374 iptable_nat
> 
> Here's the list from a nearly identical sytem that's still got the ipv6
> module loading, and that's also failing at both populating the proc ipv6
> space fully (same thing - just four of the 6 NICs) and also failing at NAT
> (in this case DNAT was what I tried):
> 
> iptable_nat             8708  1 
> nf_nat                 20012  2 nf_nat_ftp,iptable_nat
> nf_conntrack_ipv4      19724  94 iptable_nat

Could you figure out whats causing the different amount of references
to nf_conntrack_ipv4? "-m state" rules, "-m conntrack" etc. take
references, maybe something fails during load?
