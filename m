From: YOSHIFUJI Hideaki / =?iso-2022-jp?B?GyRCNUhGIzFRTEAbKEI=?=
	<yoshfuji@wide.ad.jp>
Subject: Re: skb->mac.raw, when is does it point to ethhdr
Date: Fri, 29 Apr 2005 02:24:01 +0900 (JST)
Message-ID: <20050429.022401.71711919.yoshfuji@wide.ad.jp>
References: <d4r2n4$o39$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: azez@ufomechanic.net
In-Reply-To: <d4r2n4$o39$1@sea.gmane.org>
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

In article <d4r2n4$o39$1@sea.gmane.org> (at Thu, 28 Apr 2005 17:29:35 +0100), Amin Azez <azez@ufomechanic.net> says:

> I've been treating skb->mac.raw as a pointer to ethhdr and stealing mac 
> addresses when conntrack's are created.
> 
> So the question comes up, how do we tell when skb->mac.raw is pointing 
> to an ethernet frame header and when it is pointing to something else?

Basically, the hardware header (ether frame) is resolved / appended
in the ip_finish_output2() (for IPv4) or ip6_output_finish() (for IPv6),
after POST_ROUTING.
Thus, in the POST_ROUTING (or before the POST_ROUTING),
hardware header (ether frame) is not available (in most cases).

--yoshfuji
