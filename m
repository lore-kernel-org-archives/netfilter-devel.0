From: Patrick McHardy <kaber@trash.net>
Subject: Re: SO_ORIGINAL_DST does not work in nat/OUTPUT anymore
Date: Sun, 10 Jul 2005 19:53:16 +0200
Message-ID: <42D1608C.7040909@trash.net>
References: <42D12E28.7020707@hoelldampf.net>	<20050710153234.GM20465@sunbeam.de.gnumonks.org>	<42D14A6D.4000900@trash.net>
	<Pine.LNX.4.61.0507101822200.9759@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0507101822200.9759@filer.marasystems.com>
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

Henrik Nordstrom wrote:
> On Sun, 10 Jul 2005, Patrick McHardy wrote:
> 
>> you first. I don't see how this change can affect SO_ORIGINAL_DST
>> though, all it does is look up the conntrack entry by a tuple
>> generated from data stored in the socket. It never even gets to
>> see a packet.
> 
> I would guess the problem is that there may be two conntracks for the
> session, one before nat and another after, or that the tuple lookup does
> not look at the expected tuple variant needed to find the conntrack.. If
> I understood the Jens problem correctly this traffic goes over loopback
> via DNAT..  (output -> DNAT -> loopback -> input -> socket)

You're absolutely right. After performing DNAT the packet doesn't match
either side of the conntrack in PRE_ROUTING and a new one is created.

iptables -t nat -A OUTPUT -d 1.2.3.4 -j DNAT --to-dest 127.0.0.1

telnet 1.2.3.4 22 results in this conntrack:

tcp      6 431997 ESTABLISHED src=172.16.1.123 dst=1.2.3.4 sport=37395
dport=22 packets=3 bytes=164 src=127.0.0.1 dst=172.16.1.123 sport=22
dport=37395 packets=2 bytes=153 [ASSURED] mark=0 use=1

In PRE_ROUTING the packet will be 172.16.1.123:37395->127.0.0.1:22,
which doesn't match and a new conntrack is created:

tcp      6 431997 ESTABLISHED src=172.16.1.123 dst=127.0.0.1 sport=37395
dport=22 packets=3 bytes=164 src=127.0.0.1 dst=172.16.1.123 sport=22
dport=1024 packets=2 bytes=153 [ASSURED] mark=0 use=1

This is the one where SO_ORIGINAL_DST gets its destination from.

Thanks for the hint. Harald, if I can't think of anything else (seems
likely) I'll revert the patch.

Regards
Patrick
