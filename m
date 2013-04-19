From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_CHECKSUM doesn't work as expected
Date: Fri, 19 Apr 2013 14:18:16 +0200
Message-ID: <20130419121816.GE19523@macbook.localnet>
References: <CAJEG_Nc63CdikpWiuJrBrjZ08v8rY5c9PvFwqAKkynDyvfRqPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jorge Ventura <jorge.araujo.ventura@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46226 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968275Ab3DSMSX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Apr 2013 08:18:23 -0400
Content-Disposition: inline
In-Reply-To: <CAJEG_Nc63CdikpWiuJrBrjZ08v8rY5c9PvFwqAKkynDyvfRqPw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 18, 2013 at 10:48:38AM -0500, Jorge Ventura wrote:
> Dear nf devels,
> I am trying to use the xt_CHECKSUM module to fix an UDP packet that
> it's comming with check sum error. I have an iptables firewall with
> two ethernet cards (eth0 private and eth1 public), all ethernet
> offload parameters are off in both ethernet cards and
> nf_conntrack_checksum = 0.
> 
> This is my iptables rule to fix the checksum:
> 
> iptables -A POSTROUTING -t mangle -p udp --dport 162 -j CHECKSUM --checksum-fill
> 
> The trafic resulting when the single UDP packet is received using tcpdump:
> 
> input at eth1 (public):  [src ip].1046 > [eth1 public ip].162: [bad
> udp cksum ff!]
> output at eth0 (private): [src ip].1046 > [eth0 private ip].162: [bad
> udp cksum ff!]
> 
> I did use printk inside the module to see what do I have at
> skb->ip_summed and I observed that the value is CHECKSUM_NONE, however
> to have the checksum fixed by the function checksum_tg, this value
> should be CHECKSUM_PARTIAL.
> 
> Please let me know if I am miss understanding the way that
> --checksum-fill is handled by xt_CHECKSUM module.

The target can only compute proper checksums for packets which have no
checksum set. If it is already set, the value will get included in the
calculation and the result will be wrong.
