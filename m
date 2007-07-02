From: Patrick McHardy <kaber@trash.net>
Subject: Re: Problem accessing https://my.procurve.com/profile/index.aspx
 (ACK is over the upper bound)
Date: Mon, 02 Jul 2007 15:26:50 +0200
Message-ID: <4688FD1A.4010303@trash.net>
References: <Pine.LNX.4.64.0707010207490.13212@bizon.gios.gov.pl>	<Pine.LNX.4.64.0707010255010.13212@bizon.gios.gov.pl>
	<Pine.LNX.4.64.0707010334080.13212@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0707010334080.13212@bizon.gios.gov.pl>
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

Krzysztof Oledzki wrote:
> Found this:
> 
> http://groups.google.pl/group/fa.openbsd.tech/browse_frm/thread/e27c7363b2c636b5/01ba6e0fa873cf42
> 
> 
> Sounds familiar - it seems that there may be a crappy OpenBSD firewall
> lurking somewhere along the path. :(


Indeed, too bad they apparently don't fix their crap and we're getting
at least one report per month about this.


> What we can do with such packets? Maybe, when a ack is valid but a sack
> is not (as it is in this situation) we are able to remove such insane
> sack option(s) with a hope that this ACK itself may acknowledge something?


I'm not too big a fan of this idea, but I will consider it if someone
sends a patch. It would have to be manually enabled at least.

> This is how this connection looks like when
> net.ipv4.netfilter.ip_conntrack_tcp_be_liberal is enabled:
> 
> [...]
> 04:34:42.835709 IP (tos 0x0, ttl 241, id 65123, offset 0, flags [DF],
> proto: TCP (6), length: 52) 216.34.143.7.443 > 195.177.210.11.6747: .,
> cksum 0x746e (correct), ack 1809367099 win 7490 <nop,nop,sack 1
> {2713870527:2713872556}>
> sacked full 2029 octets + acked everyting to 1809367099
> 
> 04:34:42.841979 IP (tos 0x0, ttl 241, id 65127, offset 0, flags [DF],
> proto: TCP (6), length: 565) 216.34.143.7.443 > 195.177.210.11.6747: P
> 3724064785:3724065298(513) ack 1809367099 win 7490 <nop,nop,sack 1
> {2713870527:2713872556}>
> (redundant) sacked full 2029 octets + acked everyting to 1809367099 +
> sending some data + PUSH
> 
> 04:34:42.853077 IP (tos 0x0, ttl 127, id 10684, offset 0, flags [DF],
> proto: TCP (6), length: 1150) 195.177.210.11.6747 > 216.34.143.7.443: P
> 1809367099:1809368209(1110) ack 3724065298 win 64900
> 
> Bingo... :)
> 
> There is a Windows XP host behind this NAT and is seems it is quite
> happy ignoring this sack crap as the ack itself finnaly acknowledged
> everyting. The transmition continues.
> 
> 
> Additionally, creating TCPOPTSSTRIP target to allow striping specific
> tcp option(s) (for example Sack-Permitted from a SYN packet) may also be
> usable if it is possible to include this extension in a base kernel.
> This may also help with a similar window scaling problem as current
> solution requires to add a route on _all_ hosts inside a network.
> Working around it on a firewall may be much faster.


Feel free to send patches :)
