From: Stephen Clark <Stephen.Clark@seclark.us>
Subject: how to see ipsec traffic
Date: Thu, 11 May 2006 08:40:00 -0400
Message-ID: <446330A0.1030704@seclark.us>
Reply-To: Stephen.Clark@seclark.us
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
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

Hello List,

I have an ipsec tunnel setup between my office and my home.
When I use tcpdump on my home system I can see the esp packets going 
both ways
but I only see the received de-encapsulated traffic not what is being 
sent back. How
can I see the unencrypted replys.

Below is an example of a tcpdump running on my home system while I am 
pinging it
from my office. I see the icmp echo request but not icmp reply.




sudo /usr/sbin/tcpdump -lni eth1 icmp or esp
tcpdump: verbose output suppressed, use -v or -vv for full protocol decode
listening on eth1, link-type EN10MB (Ethernet), capture size 96 bytes
09:49:49.616062 IP 65.162.182.15 > 24.144.77.138: 
ESP(spi=0x0702d979,seq=0x1)
09:49:49.635388 IP 10.0.129.1 > 192.168.2.1: icmp 64: echo request seq 0
09:49:49.635426 IP 24.144.77.138 > 65.162.182.15: 
ESP(spi=0x05191a81,seq=0x1)
09:49:50.617714 IP 65.162.182.15 > 24.144.77.138: 
ESP(spi=0x0702d979,seq=0x2)
09:49:50.617714 IP 10.0.129.1 > 192.168.2.1: icmp 64: echo request seq 256
09:49:50.617855 IP 24.144.77.138 > 65.162.182.15: 
ESP(spi=0x05191a81,seq=0x2)

kernel is 2.6.15-1.1831_FC4

Thanks,
Steve

-- 

"They that give up essential liberty to obtain temporary safety, 
deserve neither liberty nor safety."  (Ben Franklin)

"The course of history shows that as a government grows, liberty 
decreases."  (Thomas Jefferson)
