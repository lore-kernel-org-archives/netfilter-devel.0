From: "Sven-Ola Tuecke" <sven-ola@gmx.de>
Subject: Re: Announcement: MAP66 extension for ip6tables
Date: Thu, 7 Oct 2010 08:37:41 +0200
Message-ID: <201010070837.42018.sven-ola@gmx.de>
References: <201010061842.20142.sven-ola@gmx.de> <201010062120.36885.sven-ola@gmx.de> <72e8fa8e51d5b3249b68f0ebad874a2c@mail.treenet.co.nz>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.22]:36238 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1752746Ab0JGGhv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Oct 2010 02:37:51 -0400
In-Reply-To: <72e8fa8e51d5b3249b68f0ebad874a2c@mail.treenet.co.nz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Good morning Amos,

Am Donnerstag, 7. Oktober 2010, um 02:13:58 schrieb Amos Jeffries:

[snip]

> > I don't plan to add NAT helpers for them, thats pointless somehow.
> 
> FWIW: FTP EPSV/EPRT extensions remove the need for layer-7 IPs and work
> with NAT44 and NAT66 nicely where the firewall supports them.

Scanned RFC2428 for this. The EPRT command needs an address mapping helper 
because it communicates the lower address within the high level application 
proto. Opening a new connection from server to client will be blocked by most 
stateful FWs anyhow. I woud say: old & bad design now compatible with a new 
protocol. Nothing to worry about - anybody will use EPSV <grin>

[snap]

> > space
> > reasons. Only 1.75 Mb Flash and 8 Mb RAM.
> 
> Are there really working IPv6-enabled 2.4 kernels in use?

Yes. The Broadcom router reference design was adopted by a dozen 
manufacturers. Besides space limitations, there is a binary-only WLAN driver 
module that forces the use of Linux-2.4. Embedded devices need some years to 
die and (with the help of the opensourced "OpenWrt") I woud say that there are 
10^7 devices around. IPv6 stack is basically working with the drawback that 
some things are un-implemented (e.g. IP6IP6 tunnel is a no-no)

[snup]

> NAT66 is designed to work stateless AFAICT. As such the mapping likely
> does not need conntrack at all.
> 
> Is there perhapse some way to only configure the map once but have it
> apply to both src and dst depending on the packet direction?
> 
> Why is /128 not allowed? that would be extremely useful for roaming
> devices internal firewalls and high-security setups with multi-homing.
> 
> AYJ

As Jan pointed out: copy of the addresses may be stored elsewhere in the form 
of hash keys. At least, I will place a warning in the docs and check for 
oopses if conntrack is active. You think about a single rule either in 
POSTROUTING or PREROUTING. May overcome above conntrack hash prob... Good 
point - I place it on the TODO.

/128? No. To keep checksum neutrality you need to balance the address change 
with some other bits in the header. Which requires a network range on the 
resulting addresses by design. I would also recommend mobile IPv6 for roaming 
and such.

While I mentioned "TODO": I plan to add a "---salt" option for the mapping. 
Why? Because IPv6 privacy extensions (aka use_tempaddr) hide the EUI48/64 to 
the outside. This may not be appliable in some environments. Adding a MAP66 
fromIPv6 -> sameIPv6 XOR salt pattern on the border router may be of help 
here. At least if you change --salt over time.

// Sven-Ola
