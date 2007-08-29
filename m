From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: /proc/net/ip_conntrack trange behavior
Date: Wed, 29 Aug 2007 18:14:08 +0900 (JST)
Message-ID: <200708290914.l7T9E934019648@toshiba.co.jp>
References: <46CE8C05.5060202@nj.cpsecure.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Dong_Wei@nj.cpsecure.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46CE8C05.5060202@nj.cpsecure.com>
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

From: Dong_Wei <Dong_Wei@nj.cpsecure.com>
Date: Fri, 24 Aug 2007 15:43:01 +0800

> Hi, all
> 	When I checked /proc/net/ip_conntrack in my Linux server, I found some 
> strange tracks like the following:
> 
> [normal case]
> tcp      6 387113 ESTABLISHED src=219.135.189.40 dst=58.60.9.41
> sport=2391 dport=443 src=58.60.9.41 dst=219.135.189.40 sport=443
> dport=2391 [ASSURED] use=1
> 
> [strange track]
> tcp      6 377231 ESTABLISHED src=222.173.17.207 dst=219.135.189.11
> sport=19691 dport=3815 [UNREPLIED] src=219.135.189.11 dst=222.173.17.207
> sport=3815 dport=19691 use=1
> 
> As we kown after SYN->SYN,ACK->ACK. TCP connection is in ESTABLISHED
> state. and the ip_conntrack "see" the REPLY direction packet, I think
> the conntrak should be ASSURED. not UNREPLIED.
> 
> So, pls help me. My kernel version is 2.4.22
> 
> Thanks in advance  :-)
> 

When only SYN and SYN/ACK are detected by ip_conntrack, the state of the
connection is ESTABLISHED. Please note that 'ESTABLISHED' is not TCP state,
but generic connection state.

-- Yasuyuki Kozakai
