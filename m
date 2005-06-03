From: Amin Azez <azez@ufomechanic.net>
Subject: missing conntrack protocol on updates
Date: Fri, 03 Jun 2005 11:41:45 +0100
Message-ID: <42A033E9.3020907@ufomechanic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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

I have the recent icmp extension to conntrack built and lsof shows that 
the library is loaded

If I leave conntrack -E running on a test box with a LOT of traffic 
going through it I get quite a few conntrack updates with missing 
protocols, detected with this grep spell:
# conntrack -E conntrack | egrep -v 'tcp|udp|icmp|DESTROY'

They seem to come in groups, and doesn't seem to be related to anything 
particular I can detect except that orig_packets and reply_packets seem 
to be 1, so I wonder if they are icmp responses.

Of course as I am using a custom conntrack kernel module which also 
dumps out the mac addresses the fault could be here, I wondered if you 
would leave that grep running for a while to see if the fault is a 
general one?

I've not been able to get /proc/net/ip_conntrack to have a missing protocol

Azez



[UPDATE] src=192.168.0.252 dst=192.168.0.233 sport=80 dport=2118 
src=192.168.0.233 dst=192.168.0.252 sport=2118 dport=80 timeout=432000 
orig_packets=1 orig_bytes=52 reply_packets=1 reply_bytes=52 
src_mac=00:09:5b:bb:d2:aa dst_mac=00:01:02:12:c6:3a
[UPDATE] src=192.168.0.252 dst=192.168.0.233 sport=80 dport=2126 
src=192.168.0.233 dst=192.168.0.252 sport=2126 dport=80 timeout=432000 
orig_packets=1 orig_bytes=52 reply_packets=1 reply_bytes=52 
src_mac=00:09:5b:bb:d2:aa dst_mac=00:01:02:12:c6:3a
[UPDATE] src=192.168.0.252 dst=192.168.0.233 sport=80 dport=2128 
src=192.168.0.233 dst=192.168.0.252 sport=2128 dport=80 timeout=432000 
orig_packets=1 orig_bytes=52 reply_packets=1 reply_bytes=52 
src_mac=00:09:5b:bb:d2:aa dst_mac=00:01:02:12:c6:3a
[UPDATE] src=192.168.0.252 dst=192.168.0.233 sport=80 dport=2133 
src=192.168.0.233 dst=192.168.0.252 sport=2133 dport=80 timeout=432000 
orig_packets=1 orig_bytes=52 reply_packets=1 reply_bytes=52 
src_mac=00:09:5b:bb:d2:aa dst_mac=00:01:02:12:c6:3a
[UPDATE] src=192.168.0.252 dst=192.168.0.233 sport=80 dport=2134 
src=192.168.0.233 dst=192.168.0.252 sport=2134 dport=80 timeout=432000 
orig_packets=1 orig_bytes=52 reply_packets=1 reply_bytes=52 
src_mac=00:09:5b:bb:d2:aa dst_mac=00:01:02:12:c6:3a
[UPDATE] src=192.168.0.252 dst=192.168.0.233 sport=80 dport=2135 
src=192.168.0.233 dst=192.168.0.252 sport=2135 dport=80 timeout=432000 
orig_packets=1 orig_bytes=52 reply_packets=1 reply_bytes=52 
src_mac=00:09:5b:bb:d2:aa dst_mac=00:01:02:12:c6:3a
[UPDATE] src=192.168.0.252 dst=192.168.0.233 sport=80 dport=2136 
src=192.168.0.233 dst=192.168.0.252 sport=2136 dport=80 timeout=432000 
orig_packets=1 orig_bytes=52 reply_packets=1 reply_bytes=52 
src_mac=00:09:5b:bb:d2:aa dst_mac=00:01:02:12:c6:3a
[UPDATE] src=192.168.0.252 dst=192.168.0.233 sport=80 dport=2138 
src=192.168.0.233 dst=192.168.0.252 sport=2138 dport=80 timeout=432000 
orig_packets=1 orig_bytes=52 reply_packets=1 reply_bytes=52 
src_mac=00:09:5b:bb:d2:aa dst_mac=00:01:02:12:c6:3a
[UPDATE] src=192.168.0.252 dst=192.168.0.233 sport=80 dport=2139 
src=192.168.0.233 dst=192.168.0.252 sport=2139 dport=80 timeout=432000 
orig_packets=1 orig_bytes=52 reply_packets=1 reply_bytes=52 
src_mac=00:09:5b:bb:d2:aa dst_mac=00:01:02:12:c6:3a
[UPDATE] src=192.168.0.1 dst=192.168.0.255 sport=138 dport=138 
src=192.168.0.255 dst=192.168.0.1 sport=138 dport=138 [UNREPLIED] 
orig_packets=2 orig_bytes=491 reply_packets=0 reply_bytes=0 
src_mac=00:40:63:d5:72:50 dst_mac=ff:ff:ff:ff:ff:ff
