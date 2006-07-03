From: Menno Smits <menno@netboxblue.com>
Subject: Re: conntrack table filling up due to missing ACKs near the end of
 a TCP session
Date: Mon, 03 Jul 2006 18:07:29 +0100
Message-ID: <44A94ED1.2030204@netboxblue.com>
References: <44A53301.1090603@netboxblue.com> <44A53AD7.9000007@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <44A53AD7.9000007@trash.net>
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

Hi Patrick,

Thanks for your reply.

Patrick McHardy wrote:
> 
> If you look at the byte counters, the connection seems to consist
> only of three packets sent by the primary. I guess one of them
> was an ACK, which through connection pick-up places the conntrack
> in ESTABLISHED state. The first question would be why they're not
> properly associated with the real connection. Please try
> "echo 255 > /proc/net/ipv4/netfilter/ip_conntrack_log_invalid".
> As a work-around you could disable connection pickup or drop
> outgoing TCP packets with state NEW but no SYN.

I tried enabling invalid packet logging like you suggested but nothing 
was logged.

Turning off connection pickup via ip_conntrack_tcp_loose fixes the 
problem. There definitely seems to be an issue with packets being 
associated with the wrong connection.

I've looked a little closer at the dodgy connections in the table 
(before the workaround). They are always of one of two forms, 2 packets 
sent or 3 packets sent:

tcp      6 51949 ESTABLISHED src=pri.ma.ry.ip dst=sec.ond.ary.ip 
sport=25 dport=38755 packets=3 bytes=183 [UNREPLIED] src=sec.ond.ary.ip 
dst=pri.ma.ry.ip sport=38755 dport=25 packets=0 bytes=0 mark=0 use=1

tcp      6 48900 ESTABLISHED src=pri.ma.ry.ip dst=sec.ond.ary.ip 
sport=25 dport=57868 packets=2 bytes=122 [UNREPLIED] src=sec.ond.ary.ip 
dst=pri.ma.ry.ip sport=57868 dport=25 packets=0 bytes=0 mark=0 use=1

The IPs, packet counts and byte counts are always identical. Only the 
non-port-25 ports change.

Are you interested in packet dumps of the connections that cause this 
behaviour? I have some here.

Menno
