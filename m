From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 0/6]: misc netfilter patches
Date: Tue, 11 Jan 2005 13:49:46 +0100
Message-ID: <41E3CB6A.4030200@trash.net>
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

I have a couple of assorted netfilter patches I would like to unload,
most noteworthy is the removal of skb_linearize in ip6tables.

You can pull all changes from bk://212.42.230.204/nf-2.6

Regards
Patrick


Harald Welte:
  o [NETFILTER] re-introduce __initdata to {arp,ip,ip6}_tables

Pablo Neira:
  o [NETFILTER]: move ipt_error and ipt_standard to iptables.h

Patrick McHardy:
  o [NETFILTER]: Fix ip6tables ESP matching with "-p all"
  o [NETFILTER]: Add --log-uid option to ipt_LOG/ip6t_LOG
  o [NETFILTER]: Remove skb_linearize in ip6tables
  o [NETFILTER]: Fix stack leakage in ip6tables
