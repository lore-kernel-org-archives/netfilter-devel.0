From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 0/5]: NAT fixes
Date: Sat, 27 Nov 2004 13:48:01 +0100
Message-ID: <41A87781.5090304@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
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

I've added these five patches to my tree, they fix NAT on loopback
and problems with locally generated ICMP errors. If no one complains
I'm going to push them to Dave this weekend.

Patrick McHardy:
  o [NETFILTER]: Verify NAT manips have been applied before reversing 
them in icmp_reply_translation
  o [NETFILTER]: Apply PRE_ROUTING manips in LOCAL_OUT for locally 
generated icmp errors
  o [NETFILTER]: Save a level of indentation in icmp_reply_translation
  o [NETFILTER]: Remove CONFIG_IP_NF_NAT_LOCAL config option
  o [NETFILTER]: Release dst_entry in PRE_ROUTING after NAT

Regards
Patrick
