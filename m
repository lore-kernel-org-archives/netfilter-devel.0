From: "temp02" <temp02@bluereef.com.au>
Subject: Conntrack_sip compilation broken with 2.6.15-git7
Date: Thu, 12 Jan 2006 17:26:34 +1100
Message-ID: <016a01c61741$22a8aab0$5001010a@bluereef.local>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

In compiling 2.6.15-git7 with sip conntrack support compiled in, the
following errors occur:

net/ipv4/netfilter/ip_conntrack_sip.c: In function `set_expected_rtp':
net/ipv4/netfilter/ip_conntrack_sip.c:260: `IPPROTO_UDP' undeclared (first
use in this function)
net/ipv4/netfilter/ip_conntrack_sip.c:260: (Each undeclared identifier is
reported only once
net/ipv4/netfilter/ip_conntrack_sip.c:260: for each function it appears in.)
net/ipv4/netfilter/ip_conntrack_sip.c: In function `sip_help':
net/ipv4/netfilter/ip_conntrack_sip.c:293: sizeof applied to an incomplete
type
net/ipv4/netfilter/ip_conntrack_sip.c: In function `init':
net/ipv4/netfilter/ip_conntrack_sip.c:384: `IPPROTO_UDP' undeclared (first
use in this function)
make[3]: *** [net/ipv4/netfilter/ip_conntrack_sip.o] Error 1
make[2]: *** [net/ipv4/netfilter] Error 2
make[1]: *** [net/ipv4] Error 2

Added include for in.h to ip_conntrack_sip.c which seem to make it happy..

and then failed again..

  CC      net/ipv4/netfilter/ip_conntrack_sip.o
net/ipv4/netfilter/ip_conntrack_sip.c: In function `sip_help':
net/ipv4/netfilter/ip_conntrack_sip.c:294: sizeof applied to an incomplete
type
make[3]: *** [net/ipv4/netfilter/ip_conntrack_sip.o] Error 1
make[2]: *** [net/ipv4/netfilter] Error 2

thanks,
