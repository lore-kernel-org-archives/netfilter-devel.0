From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 0/5]: NAT fixes
Date: Mon, 29 Nov 2004 00:27:56 +0100
Message-ID: <41AA5EFC.1080708@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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

Hi Dave,

the next 5 patches (against your 2.6.11 tree) fix DNAT on loopback and 
some issues
with locally generated ICMP errors for NATed packets.

You can pull all changes from bk://212.42.230.204/nf-2.6-nat

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
