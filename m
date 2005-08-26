From: =?euc-kr?q?=C3=CA=BC=F8=20=C0=D3?= <csyimkor@yahoo.co.kr>
Subject: kernel option "Bridged IP/ARP packets filtering" degrades bridging
	per
Date: Fri, 26 Aug 2005 12:47:24 +0900 (JST)
Message-ID: <20050826034724.88957.qmail@web70107.mail.krs.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=euc-kr
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

I have tested the bridging performance of Linux.
I used SmartBit equipment.


Linux machine;

Xeon 3.06GHz * 2 CPU
1 G Memory
intel e1000 NIC 2 port LC type * 1 driver version
6.0.60
kernel 2.6.12


When I generated traffic with 64bytes packets both
direction without "Bridged IP/ARP packets filtering"
kernel option, I got success rate 10%.
(This result disappoints me.)
But when I enabled that option(I recompiled the
kernel), I got success rate 5%.
It was a half of prior result. 
I did not add any filter rules. I just enabled that
option because I wanted to use bridge
firewalling. 

What is the reason I got this result?
How can I fix this strange thing or enhance bridging
performance?
Please let me know.

Thanks in advance
Yimbo



__________________________________________________
두 유 야후!?
스팸때문에 짜증나세요? 야후! 메일의 스팸 차단 기술로 메일을 보호합니다 
http://mail.yahoo.co.kr
