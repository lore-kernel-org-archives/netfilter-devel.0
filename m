From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: TOS target broken wrt RFC 1349
Date: Thu, 29 Apr 2004 19:58:32 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404291809060.29329-100000@filer.marasystems.com>
References: <Pine.LNX.4.58.0404291448500.5102@chris.camcom.co.uk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Chris Wilson <chris@netservers.co.uk>
In-Reply-To: <Pine.LNX.4.58.0404291448500.5102@chris.camcom.co.uk>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 29 Apr 2004, Chris Wilson wrote:

> OK, thank you for clearing that up for me. However, either tcpdump or the
> kernel must be wrong, because when I set TOS to 0x02, tcpdump says that I
> set the ECT bit! (I know you will all say that tcpdump is wrong :-)

It is a matter on conflicting RFCs.

Both RFC 1349 (obsolete TOS RFC) and RFC 3168 (ECN) defines different
meanings of bit #6 (0x02).

STD 5 (RFC 791). Defines 3 bits precedence and 3 bits type of service. 
The last 2 bits (#6, #7) is undefined.

RFC 1349. Defines 3 bits of precedence (STD 5) and 4 bits of TOS. This
matches the Linux TOS definitions. Only 1 bit undefined of the TOS octet
in this RFC (MBZ, Must Be Zero)

RFC 2474. Defines 6 bits of DS, combining the precendence and TOS bits of
STD 5 as one single 6 bit field. The code pints xxx000 is defined in the
same manner as the Precedence of STD 5. The last 2 bits of the TOS octet
is left undefined.

RFC 1349 defines the two unused bits of RFC 2474 for use by ECN.

> Well, it doesn't give you full power over the TOS octet, see ipt_TOS.c:
> 
>         if (tos != IPTOS_LOWDELAY
>             && tos != IPTOS_THROUGHPUT
>             && tos != IPTOS_RELIABILITY
>             && tos != IPTOS_MINCOST
>             && tos != IPTOS_NORMALSVC) {
>                 printk(KERN_WARNING "TOS: bad tos value %#x\n", tos);
>                 return 0;
>         }

Ugh.. did not know of this. But ok.. this is not good. The TOS is far to
overloaded to assume that one wants to use on obsoleted RFC.. In addition
for all practical purposes Precedence is a form of TOS and is why it is 
included in DS (and is in fact the only defined codepoints of DS)

Regards
Henrik
