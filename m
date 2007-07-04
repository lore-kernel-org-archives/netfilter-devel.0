From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_connlimit 20070628 kernel
Date: Wed, 04 Jul 2007 16:52:58 +0200
Message-ID: <468BB44A.8000401@trash.net>
References: <4684ECB5.9070402@trash.net>	<Pine.LNX.4.64.0707011552500.15758@fbirervta.pbzchgretzou.qr>	<4688EF45.7020200@trash.net>
	<200707040855.l648tIBY005526@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: jengelh@computergmbh.de, netfilter-devel@lists.netfilter.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200707040855.l648tIBY005526@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
> Logically, IPv6 packets including (almost) mapped addresses can be
> assumed that they belong to IPv4 connection.
> 
> But now I don't want to do that because mapped address can cause security
> issues.
> 
> 	http://www.ietf.org/internet-drafts/draft-ietf-v6ops-security-overview-06.txt
> 	(2.2.  IPv4-mapped IPv6 Addresses)
> 
> These issues arise because IPv6 packets including mapped address are handled as
> IPv4 packets. So, to avoid new security issue we don't know yet, I think
> that it's safe not to merge IPv4 connection and IPv6 connection.
> 
> 
> P.S. That's the reason why hash function of nf_conntrack takes address family.


Thanks for the explanation Yasuyuki.
