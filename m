From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: Full header rewrite before local delivery
Date: Mon, 6 Aug 2007 16:55:57 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0708061654390.13469@fbirervta.pbzchgretzou.qr>
References: <46B733E8.20803@unibas.ch>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
To: Christophe Jelger <Christophe.Jelger@unibas.ch>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46B733E8.20803@unibas.ch>
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


On Aug 6 2007 16:44, Christophe Jelger wrote:
>
> This means I'd like to use ip_tables to do this full NAT but it
> seems that with the existing code one can only do SNAT in the
> postrouting while I need to do that before local delivery to the IP
> stack. Also I'd still like to use existing modules to NAT FTP, SIP,
> etc ...

I think you can do SNAT in the raw table (PREROUTING and OUTPUT),
before the conntrack tuple is assigned to the skb.


	Jan
-- 
