From: Patrick McHardy <kaber@trash.net>
Subject: Re: Resend [Patch 1/2] Avoid direct connections between NATed hosts
Date: Fri, 19 Jan 2007 16:36:25 +0100
Message-ID: <45B0E579.2010803@trash.net>
References: <1168621167.28615.14.camel@localhost.localdomain>	
	<Pine.LNX.4.61.0701122350230.19224@yvahk01.tjqt.qr>	
	<1168722049.5737.4.camel@localhost> <45AE153F.6010105@trash.net>
	<1169047100.26570.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Eric Leblond <eric@inl.fr>
In-Reply-To: <1169047100.26570.1.camel@localhost.localdomain>
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

Eric Leblond wrote:
>>> 
>>>+	/* Start from random port to avoid prediction */
>>>+	if (range->flags & IP_NAT_RANGE_PROTO_RANDOM)
>>>+		port = (u_int16_t) net_random();
>>
>>No need to cast, also endianness error (port is __be16).


>>>diff --git a/net/ipv4/netfilter/ip_nat_proto_tcp.c b/net/ipv4/netfilter/ip_nat_proto_tcp.c
>>>index b586d18..78ff1bb 100644
>>>--- a/net/ipv4/netfilter/ip_nat_proto_tcp.c
>>>+++ b/net/ipv4/netfilter/ip_nat_proto_tcp.c
>>>@@ -8,6 +8,7 @@
>>> 
>>> #include <linux/types.h>
>>> #include <linux/init.h>
>>>+#include <linux/random.h>
>>> #include <linux/netfilter.h>
>>> #include <linux/ip.h>
>>> #include <linux/tcp.h>
>>>@@ -75,6 +76,9 @@ tcp_unique_tuple(struct ip_conntrack_tup
>>> 		range_size = ntohs(range->max.tcp.port) - min + 1;
>>> 	}
>>> 
>>>+	/* Start from random port to avoid prediction */
>>>+	if (range->flags & IP_NAT_RANGE_PROTO_RANDOM)
>>>+		port =  __cpu_to_be16(net_random());


Sorry that was my mistake, port is host endian, I can fix that before
applying. Other than that it looks fine, if there are no objections
from other people I'm going to apply it this weekend.
