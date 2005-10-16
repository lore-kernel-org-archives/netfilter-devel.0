From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: tcp match silently drops packets
Date: Sun, 16 Oct 2005 16:51:43 +0900 (JST)
Message-ID: <200510160751.j9G7ph5t009316@toshiba.co.jp>
References: <4349D97A.9070708@snapgear.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: philipc@snapgear.com
In-Reply-To: <4349D97A.9070708@snapgear.com>
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


Hi, Philip,

From: Philip Craig <philipc@snapgear.com>
Date: Mon, 10 Oct 2005 13:01:14 +1000

> If you send a 20 byte IP packet that has the protocol set to 6,
> (ie TCP packet with no TCP header) then the following rule will match:
> 
> iptables -I FORWARD -p tcp
> 
> and the following rule will match and silently drop the packet:
> 
> iptables -I FORWARD -p tcp --syn
>
> I think the behaviour of the first rule is fine, but the second one
> should simply not match.  These packets probably should be dropped,
> but this is a policy decision, and shouldn't be implemented in the
> tcp match.  And if it must drop it, then a log message or counter
> somewhere would be nice.

I cannot reproduce this situation with linux-2.4.31 and recent iptables.
tcp_match() return 0 for such packet because it doesn't have tcp header and
datalen is 0.

	if (offset == 1) {
		duprintf("Dropping evil TCP offset=1 frag.\n");
		*hotdrop = 1;
		return 0;
	} else if (offset == 0 && datalen < sizeof(struct tcphdr)) {
		/* We've been asked to examine this packet, and we
		   can't.  Hence, no choice but to drop. */
		duprintf("Dropping evil TCP offset=0 tinygram.\n");
		*hotdrop = 1;
		return 0;
	}

Could you tell me what you mean 'match and silently drop' in detail ?

Regards,
-----------------------------------------------------------------
Yasuyuki Kozakai @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
