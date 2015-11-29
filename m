From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft] proto: fix VLAN header definition
Date: Sun, 29 Nov 2015 01:09:29 +0100
Message-ID: <20151129000929.GA15493@breakpoint.cc>
References: <1448615614-16510-1-git-send-email-kaber@trash.net>
 <20151127094958.GB15392@breakpoint.cc>
 <20151127095424.GF4263@macbook.localdomain>
 <20151127103428.GC15392@breakpoint.cc>
 <20151127104248.GD15392@breakpoint.cc>
 <20151127104923.GH4263@macbook.localdomain>
 <20151127105417.GE15392@breakpoint.cc>
 <20151128233201.GA3542@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:40899 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751754AbbK2AJe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 28 Nov 2015 19:09:34 -0500
Content-Disposition: inline
In-Reply-To: <20151128233201.GA3542@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Fri, Nov 27, 2015 at 11:54:17AM +0100, Florian Westphal wrote:
> > Patrick McHardy <kaber@trash.net> wrote:
> > > Yes, I also did that and it looks correct. I think we probably have a
> > > discrepancy with bit numbering:
> > > 
> > > Looking at an older patch of you:
> > > 
> > > -               [IPHDR_VERSION]         = HDR_BITFIELD("version", &integer_type, 0, 4),
> > > -               [IPHDR_HDRLENGTH]       = HDR_BITFIELD("hdrlength", &integer_type, 4, 4),
> > > +               [IPHDR_VERSION]         = HDR_BITFIELD("version", &integer_type, 4, 4),
> > > +               [IPHDR_HDRLENGTH]       = HDR_BITFIELD("hdrlength", &integer_type, 0, 4),
> > > 
> > > So you seem to assume a numbering which corresponds to how you would express
> > > it in C. My patch assumes numbering as used in the RFCs/IEEE standards, which
> > > is basically the opposite direction.
> > 
> > Right, there is a general problem with all sub-byte fields.
> > 
> > I just noticed that decoding of ip version/hdrlen doesn't work either.
> > (ip hdrlength 4 ip version 5).
> > 
> > I am sure that I tested matching on ip version/hdrlen on both
> > x86-64 and a MSB machine (don't recall architecture, ppc i think).
> 
> The existing approach works fine in x86-64 and ppc here.
> 
> pahole also reports that version bitfield offset starts at 0, then
> hdrlength starts at 4, both in x86-64 and ppc.
> 
> Probably the problem is the way we calculate the shifts. I managed to
> set the offset according to RFCs/IEEE by adjusting the existing
> arithmetics, I think the offset semantics was accidentally changes
> with this first approach to address sub-byte matching.

Thanks for looking at this.  I'll take a closer look tomorrow,
your patch works fine for ip version/hdrlength but seems it messes
with endianess somewhere.

With Patricks fix to make VLAN header in IEEE notation:

src/nft --debug=netlink add rule bridge raw prerouting ether type vlan vlan type ip vlan id 4094 ip version 4 counter
bridge raw prerouting
  [ payload load 2b @ link header + 12 => reg 1 ]
  [ cmp eq reg 1 0x00008100 ]
  [ payload load 2b @ link header + 16 => reg 1 ]
  [ cmp eq reg 1 0x00000800 ]
  [ payload load 2b @ link header + 14 => reg 1 ]
  [ bitwise reg 1 = (reg=1 & 0x00000f00 ) ^ 0x00000000 ]
  [ cmp eq reg 1 0x00000f00 ]
  [ payload load 1b @ network header + 0 => reg 1 ]
  [ bitwise reg 1 = (reg=1 & 0x000000f0 ) ^ 0x00000000 ]
  [ cmp eq reg 1 0x00000040 ]
  [ counter pkts 0 bytes 0 ]

master (counter increments):
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

