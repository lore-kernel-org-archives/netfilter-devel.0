From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH]: 1st step to remove skb_linearize() in ip6_tables.c and
 optimization
Date: Tue, 06 Jul 2004 12:20:23 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40EA7CE7.2000502@trash.net>
References: <200406240404.NAA01264@toshiba.co.jp> <40DABA52.9070700@trash.net> <19040125165321.GA4640@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>,
 netfilter-devel@lists.netfilter.org,  kisza@securityaudit.hu,
 usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <19040125165321.GA4640@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte wrote:
> On Thu, Jun 24, 2004 at 01:26:10PM +0200, Patrick McHardy wrote:
> 
>>Think of 100 rules matching "-p tcp --dport X". We copy the tcp header
>>100 times, for a total of 2000 bytes. 
> 
> 
> but we're talking about local copies to the stack.  those copies are 20
> byte copies to the cache, and most likely would never have to hit memory
> at all.  

I did some profiling:

1000 non-matching rules for tcp-sport, ~40mbit tcp transfer, about 10
minutes

The top three entries are:

CPU: Athlon, speed 1667.51 MHz (estimated)
Counted CPU_CLK_UNHALTED events (Cycles outside of halt state) with a 
unit mask of 0x00 (No unit mask) count 100000
samples  %        linenr info                 image name 
app name                 symbol name
3489310  50.0932  (no location information)   ip_tables.ko 
ip_tables                ipt_do_table
1405809  20.1821  skbuff.c:858                vmlinux 
vmlinux                  skb_copy_bits
755945   10.8525  ip_tables.c:1488            ip_tables.ko 
ip_tables                tcp_match

skb_copy_bits is taking about twice as much cycles as tcp_match
and 20% of total cycles.

Regards
Patrick
