From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: xt_connlimit 20070628 kernel
Date: Wed, 04 Jul 2007 17:55:17 +0900 (JST)
Message-ID: <200707040855.l648tIBY005526@toshiba.co.jp>
References: <4684ECB5.9070402@trash.net>
	<Pine.LNX.4.64.0707011552500.15758@fbirervta.pbzchgretzou.qr>
	<4688EF45.7020200@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: jengelh@computergmbh.de, netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4688EF45.7020200@trash.net>
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


Hi,

It seems old discussion, anyway,

From: Patrick McHardy <kaber@trash.net>
Date: Mon, 02 Jul 2007 14:27:49 +0200

> Jan Engelhardt wrote:
> > On Jun 29 2007 13:27, Patrick McHardy wrote:
> > 
> >>A single hash would have the advantage that it would make it easier to deal
> >>with IPv4 mapped addresses (thats assuming that an IPv4 mapped address and a
> >>regular address should be counted as the same thing).
> > 
> > 
> > Huwee :)
> > Mathematically seen, all that is required is a hash function that is pure (GCC
> > slang for "produces always the same for same input") for a tuple of
> > <ipaddress, struct xt_connlimit_data>. So I could use xhash for ipv4 and yhash
> > for ipv6 even and a per-connlimit_data rnd.
> > 
> > Right, to the topic: I think we're fine here.
> 
> 
> That didn't answer my question. Should IPv6 mapped IPv4 addresses be
> counted as the same address as the mapped IPv4 address or not?

Logically, IPv6 packets including (almost) mapped addresses can be
assumed that they belong to IPv4 connection.

But now I don't want to do that because mapped address can cause security
issues.

	http://www.ietf.org/internet-drafts/draft-ietf-v6ops-security-overview-06.txt
	(2.2.  IPv4-mapped IPv6 Addresses)

These issues arise because IPv6 packets including mapped address are handled as
IPv4 packets. So, to avoid new security issue we don't know yet, I think
that it's safe not to merge IPv4 connection and IPv6 connection.


P.S. That's the reason why hash function of nf_conntrack takes address family.

-- Yasuyuki Kozakai
