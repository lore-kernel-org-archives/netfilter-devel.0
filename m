From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: tcp match silently drops packets
Date: Sun, 16 Oct 2005 19:35:32 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0510161931530.32106@filer.marasystems.com>
References: <4349D97A.9070708@snapgear.com>
	<200510160751.j9G7ph5t009316@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Netfilter Developers <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200510160751.j9G7ph5t009316@toshiba.co.jp>
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

On Sun, 16 Oct 2005, Yasuyuki KOZAKAI wrote:

> I cannot reproduce this situation with linux-2.4.31 and recent iptables.
> tcp_match() return 0 for such packet because it doesn't have tcp header and
> datalen is 0.
>
> 	if (offset == 1) {
> 		duprintf("Dropping evil TCP offset=1 frag.\n");
> 		*hotdrop = 1;
> 		return 0;
> 	} else if (offset == 0 && datalen < sizeof(struct tcphdr)) {
> 		/* We've been asked to examine this packet, and we
> 		   can't.  Hence, no choice but to drop. */
> 		duprintf("Dropping evil TCP offset=0 tinygram.\n");
> 		*hotdrop = 1;
> 		return 0;
> 	}
>
> Could you tell me what you mean 'match and silently drop' in detail ?

The above code forces such packets to be dropped with no visible traces to 
why. (*hotdrop = 1, and also hinted by the debug message and comment)

What he ment was "the match will silently drop the packet", not that the 
rule as such will match the packet..

Regards
Henrik
