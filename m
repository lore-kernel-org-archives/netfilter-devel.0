From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nft] proto: fix VLAN header definition
Date: Fri, 27 Nov 2015 11:34:28 +0100
Message-ID: <20151127103428.GC15392@breakpoint.cc>
References: <1448615614-16510-1-git-send-email-kaber@trash.net>
 <20151127094958.GB15392@breakpoint.cc>
 <20151127095424.GF4263@macbook.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>, pablo@netfilter.org,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:38708 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751504AbbK0Keb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Nov 2015 05:34:31 -0500
Content-Disposition: inline
In-Reply-To: <20151127095424.GF4263@macbook.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy <kaber@trash.net> wrote:
> On 27.11, Florian Westphal wrote:
> > Patrick McHardy <kaber@trash.net> wrote:
> > > The VID is located after Priority and CFI.
> > 
> > With this patch matching on vlan id does not work for me anymore
> > on x86-64.
> > 
> > With trace-patch nft but without this patch:
> > 
> > table bridge filter {
> > chain input {
> >    type filter hook input priority -200; policy accept;
> >    vlan id 4094 counter packets 827 bytes 63839
> > 
> > With this patch, the counters remain at zero:
> > 
> > unknown unknown & 0xfff [invalid type] == 0xffe [invalid type] counter packets 850 bytes 65375
> > vlan id 4094 counter packets 0 bytes 0
> > 
> > (The 'unknown unknown' line is the 'old' vlan rule added by unpatched
> >  nft binary, the 'vlan id' is the one added with the patched one).
> 
> Odd, since it decodes correctly. Could you send the output of
> nft --debug=netlink with and without the patch?

master:
nft --debug=netlink  add rule  bridge filter input vlan id 4094 counter
bridge filter input
 [ payload load 2b @ link header + 12 => reg 1 ]
 [ cmp eq reg 1 0x00000081 ]
 [ payload load 2b @ link header + 14 => reg 1 ]
 [ bitwise reg 1 = (reg=1 & 0x0000ff0f ) ^ 0x00000000 ]
 [ cmp eq reg 1 0x0000fe0f ]
 [ counter pkts 0 bytes 0 ]

patched:
# src/nft --debug=netlink  add rule  bridge filter input vlan id 4094 counter
bridge filter input
 [ payload load 2b @ link header + 12 => reg 1 ]
 [ cmp eq reg 1 0x00000081 ]
 [ payload load 2b @ link header + 14 => reg 1 ]
 [ bitwise reg 1 = (reg=1 & 0x0000f0ff ) ^ 0x00000000 ]
 [ cmp eq reg 1 0x0000e0ff ]
 [ counter pkts 0 bytes 0 ]
