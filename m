From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 0/4]: Netfilter fixes
Date: Tue, 25 Jan 2005 05:47:55 +0100
Message-ID: <41F5CF7B.20209@trash.net>
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

these are Martin's fixes for fallout from the recent patches and an 
additional
patch to add support for inversion to ipt_multiport.

You can pull all changes from bk://212.42.230.204/nf-2.6

Regards
Patrick


Martin Josefsson:
  o [NETFILTER]: Fix compile with NAT but without modules
  o [NETFILTER]: Fix compile errors without NAT
  o [NETFILTER]: Fix SNAT/DNAT target size checks

Phil Oester:
  o [NETFILTER]: Add inversion to multiport match
