From: Chris Wilson <chris@netservers.co.uk>
Subject: Re: TOS target broken wrt ECN (was RFC 1349)
Date: Fri, 30 Apr 2004 11:22:29 +0100 (BST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.58.0404301055140.17235@chris.camcom.co.uk>
References: <Pine.LNX.4.44.0404290113410.17188-100000@filer.marasystems.com>
  <Pine.LNX.4.58.0404291748430.5102@chris.camcom.co.uk> <1083317127.12783.71.camel@andromache>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Henrik Nordstrom <hno@marasystems.com>,
        Netfilter Developers <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Glen Turner <glen.turner@aarnet.edu.au>
In-Reply-To: <1083317127.12783.71.camel@andromache>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Glen,

> Bit 6, the one at issue, was occasionally used for the "minimize cost"
> TOS. It never gained much OS support at the time, and Netfilter offers
> better support for that ToS than the OSs of the pre-DiffServ era. 
> Monitoring for that ToS bit by backbone ISP during the IETF discussions
> about ECN didn't show any use. Ironically Netfilter could alter that
> situation :-)

Yes, I was trying to use it to reduce the priority of TCP packets outbound 
from our leased line router to the Internet, and some firewalls out there 
were dropping our TCP traffic because this bit was set (presumably because 
they thought it was ECN, and took a dislike to it ;)

> > If so, then the TOS target is dangerous since it will disrupt the 
> > operation of ECN, and the documentation should mention that. I'd be happy 
> > to write a patch to update it if people are interested.
> 
> Best if Netfilter makes it clear that Bit 6 is discouraged.

Not just bit 6. From line 36 of ipt_TOS.c:

	iph->tos = (iph->tos & IPTOS_PREC_MASK) | tosinfo->tos;

IPTOS_PREC_MASK is #defined to 0xE0, so this will clear the lowest five 
bits of the TOS octet, including both ECN bits, and replace them with 
whatever value the user specifies.

Unfortunately, I have to agree with you that minimize-cost and 
maximize-security TOS values are now useless since the IETF has redefined 
their bits to something else. It would appear that backwards compatibility 
has been completely broken, because ECN packets can be handled badly by 
TOS routers, and TOS packets handled badly by ECN routers.

Therefore, I think there should be a big fat warning on the TOS target 
that it breaks ECN and should not be used on the Internet.

A less drastic option is to not clear the lower two bits, and disable the 
minimize-cost TOS target. However, this target will still have strange 
interactions with ECN, since an ECN router can set bit 6 to signal 
CE, which causes other TOS routers to treat the packet differently 
(minimize-cost or an invalid TOS value, depending on the values of the 
other bits).

> It would help immensely if the tos page noted that ToS is deprecated and
> if ToS-backward-compatibility were added to DSCP.

I agree, but I'd say that it's not just deprecated, but dangerous as well.

> # iptables --match dscp --dscp tos-minimize-delay
> 
> Obviously there would be no tos-minimize-cost, but that would be no
> loss.

Except financially ;)

Cheers, Chris.
-- 
_  __ __     _
 / __/ / ,__(_)_  | Chris Wilson -- UNIX Firewall Lead Developer |
/ (_  ,\/ _/ /_ \ | NetServers.co.uk http://www.netservers.co.uk |
\__/_/_/_//_/___/ | 21 Signet Court, Cambridge, UK. 01223 576516 |
