From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 0/3] fixes for ipv6header/eui64 and introduce
	skb_header_pointer
Date: Thu, 04 Nov 2004 16:06:22 +0100
Message-ID: <418A456E.6040202@trash.net>
References: <200411010840.iA18eeia001852@toshiba.co.jp>	<41899235.1030309@trash.net>
	<200411041044.iA4AiSWj006510@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200411041044.iA4AiSWj006510@toshiba.co.jp>
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

Yasuyuki Kozakai wrote:

>OK, today I wrote patches for 2.4 and started testing them. But I don't have
>enough time to test next week, maybe I'll send them at the week after next.
>
Great, thanks a lot.

>
>By the way, is there any other IPv6 module which is needed to change to work
>without skb_linearize() ? If no, we can finally remove it from ip6_tables.c
>
ip6_queue (and ip_queue) need to be changed. I'm currently
testing a patch for ip_queue, the change to ip6_queue is similar.
After that I think we can remove it.

Regards
Patrick
