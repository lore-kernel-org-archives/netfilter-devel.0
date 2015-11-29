From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft] proto: fix VLAN header definition
Date: Sun, 29 Nov 2015 23:37:43 +0100
Message-ID: <20151129223743.GA29878@breakpoint.cc>
References: <1448615614-16510-1-git-send-email-kaber@trash.net>
 <20151127094958.GB15392@breakpoint.cc>
 <20151127095424.GF4263@macbook.localdomain>
 <20151127103428.GC15392@breakpoint.cc>
 <20151127104248.GD15392@breakpoint.cc>
 <20151127104923.GH4263@macbook.localdomain>
 <20151127105417.GE15392@breakpoint.cc>
 <20151128233201.GA3542@salvia>
 <20151129000929.GA15493@breakpoint.cc>
 <20151129220037.GA2301@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:42064 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751086AbbK2Whq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 29 Nov 2015 17:37:46 -0500
Content-Disposition: inline
In-Reply-To: <20151129220037.GA2301@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sun, Nov 29, 2015 at 01:09:29AM +0100, Florian Westphal wrote:
> > Thanks for looking at this.  I'll take a closer look tomorrow,
> > your patch works fine for ip version/hdrlength but seems it messes
> > with endianess somewhere.
> 
> I forgot to update payload_shift_value() too, to skip the shift when
> not needed, sorry, new patch attached.

Almost there.  Again, with Patricks patch to fix VLAN header:

# src/nft --debug=netlink add rule bridge raw prerouting ether type vlan vlan type ip vlan id 4094 ip version 4 counter 
bridge raw prerouting
  [ payload load 2b @ link header + 12 => reg 1 ]
  [ cmp eq reg 1 0x00000081 ]
  [ payload load 2b @ link header + 16 => reg 1 ]
  [ cmp eq reg 1 0x00000008 ]
  [ payload load 2b @ link header + 14 => reg 1 ]
  [ bitwise reg 1 = (reg=1 & 0x00000f00 ) ^ 0x00000000 ]
  [ cmp eq reg 1 0x00000f00 ]
  [ payload load 1b @ network header + 0 => reg 1 ]
  [ bitwise reg 1 = (reg=1 & 0x000000f0 ) ^ 0x00000000 ]
  [ cmp eq reg 1 0x00000040 ]
  [ counter pkts 0 bytes 0 ]

for comparision, master.  All looks ok except the bitwise and cmp of vlan id.
# nft --debug=netlink add rule bridge raw prerouting ether type vlan vlan type ip vlan id 4094 ip version 4 counter
bridge raw prerouting 
  [ payload load 2b @ link header + 12 => reg 1 ]
  [ cmp eq reg 1 0x00000081 ]
  [ payload load 2b @ link header + 16 => reg 1 ]
  [ cmp eq reg 1 0x00000008 ]
  [ payload load 2b @ link header + 14 => reg 1 ]
  [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
  [ cmp eq reg 1 0x0000fe0f ]
  [ payload load 1b @ network header + 0 => reg 1 ]
  [ bitwise reg 1 = (reg=1 & 0x000000f0 ) ^ 0x00000000 ]
  [ cmp eq reg 1 0x00000040 ]
  [ counter pkts 0 bytes 0 ]

