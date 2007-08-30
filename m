From: Patrick McHardy <kaber@trash.net>
Subject: Re: /proc/net/ip_conntrack trange behavior
Date: Thu, 30 Aug 2007 08:49:24 +0200
Message-ID: <46D66874.1050405@trash.net>
References: <46CE8C05.5060202@nj.cpsecure.com>
	<200708290914.l7T9E934019648@toshiba.co.jp>
	<46D5BFB5.6000206@trash.net> <46D61A10.6010405@nj.cpsecure.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
To: Dong_Wei@nj.cpsecure.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46D61A10.6010405@nj.cpsecure.com>
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

Dong_Wei wrote:
> Thanks a lot. Yasuyuki and kaber
> 
> I have looked the 2.6.20 kernel and found that the reason.
> 
> When ip_conntrack try to pick up an ESTABLISHED TCP connection, this 
> issue will happen.


Exactly.

> 2.6 set an 'sysctl' value to deal with this situation
> 
> [..]
> 
> And we can't avoid this issue on 2.4, because no code deal with the 
> special case.


Thats correct. Is there a problem with this behaviour?
