From: Peter Osterlund <petero2@telia.com>
Subject: Re: Linux 2.6.20-rc4
Date: 09 Jan 2007 00:02:30 +0100
Message-ID: <m3ps9pp1fd.fsf@telia.com>
References: <Pine.LNX.4.64.0701062216210.3661@woody.osdl.org>
	<m37ivyr1v6.fsf@telia.com>
	<Pine.LNX.4.64.0701071442580.3661@woody.osdl.org>
	<45A2C6AE.5080400@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Linus Torvalds <torvalds@osdl.org>,
	"David S. Miller" <davem@davemloft.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Netfilter Development Mailinglist
	<netfilter-devel@lists.netfilter.org>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1161134AbXAHXCj@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <45A2C6AE.5080400@trash.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Patrick McHardy <kaber@trash.net> writes:

> Linus Torvalds wrote:
> > On Sun, 7 Jan 2007, Peter Osterlund wrote:
> > 
> >>I get kernel panics when doing large ethernet transfers. A loop doing

> >>  EFALLGS: 00010206 (2.6.20-rc4 #13)
> >>  EIP is at ipv4_conntrack_help+0x6b/0x83
> >>  eax: c0475e44 ebx: 9f5cea37 ecx: d1dcebb0 edx: 00000014
> >>  esi: d1dcebb0 edi: c0475e44 ebp: c0475dd8 esp: c0475dc4
> > 
> > which is ipv4_conntrack_help():
> > 
> > 	return help->helper->help(pskb,
> > 		(*pskb)->nh.raw - (*pskb)->data
> > 				+ (*pskb)->nh.iph->ihl*4,
> > 		ct, ctinfo);
> > 
> > and that call instruction is the one that oopses because "help->helper" is 
> > corrupt (it's 0x9f5cea37 - not a valid kernel pointer).
> 
> I guess its because of an uninitialized helper field in struct
> nf_conntrack_expect, which is then copied from the expectation to
> the conntrack entry.
> 
> Peter, do you have locally generated netbios ns queries on the machine
> running nf_conntrack?

I have samba running on both machines. I guess that generates some
netbios traffic even though it isn't currently in active use.

> If so, please try this patch.

Thanks, the patch appears to help. The kernel has now survived much
longer with this patch than it used to do without it.

I will recompile with gcc 4.1.1 too just to make sure, but if you
don't hear anything more from me, consider the case closed. :)

-- 
Peter Osterlund - petero2@telia.com
http://web.telia.com/~u89404340
