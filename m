From: Patrick McHardy <kaber@trash.net>
Subject: Re: Checksum problem in tcp-window-tracking
Date: Tue, 15 Jun 2004 20:32:19 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40CF40B3.7040109@trash.net>
References: <Pine.LNX.4.33.0406151510320.15738-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Martin Josefsson <gandalf@wlug.westbo.se>,
 Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.33.0406151510320.15738-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Jozsef,

Jozsef Kadlecsik wrote:
> I committed the fixed version of the patch in cvs. Besides the fix the
> talkative log messages were trimmed in order to fit (better) into the
> ULOG buffer.

I think there is still a problem.

+       if (csum_tcpudp_magic(iph->saddr, iph->daddr,
+                             tcplen, IPPROTO_TCP,
+                             skb->ip_summed == CHECKSUM_HW
+                             && hooknum == NF_IP_PRE_ROUTING
+                               ? skb->csum
+                               : skb_checksum(skb, iph->ihl*4, tcplen, 
0))) {

On the outgoing path, the NIC is supposed to checksum the packet when
CHECKSUM_HW is set, so it hasn't got a valid checksum when the check is
performed. Do we need to check the checksum in LOCAL_OUT at all ?
Other than from raw-sockets, invalid packets can not occur.

Regards
Patrick

PS: Martin, how did you trigger these errors ?
