From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 2.6 0/6]: another netfilter update
Date: Sun, 26 Sep 2004 23:51:58 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <415739FE.1040108@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi Dave,

these 6 patches fix two minor issues from the last patchset
and convert the remaining conntrack protocols and matches to
skb_header_pointer.

You can pull all patches from bk://212.42.230.204/netfilter-2.6

ChangeSet@1.1992.1.6, 2004-09-26 23:20:58+02:00, kaber@coreworks.de
  [NETFILTER]: Convert icmp conntrack protocol to skb_header_pointer
 
  Signed-off-by: Patrick McHardy <kaber@trash.net>

ChangeSet@1.1992.1.5, 2004-09-26 23:18:51+02:00, kaber@coreworks.de
  [NETFILTER]: Convert udp conntrack protocol to skb_header_pointer
 
  Signed-off-by: Patrick McHardy <kaber@trash.net>

ChangeSet@1.1992.1.4, 2004-09-26 23:17:39+02:00, kaber@coreworks.de
  [NETFILTER]: Convert sctp conntrack protocol to skb_header_pointer
 
  Signed-off-by: Patrick McHardy <kaber@trash.net>

ChangeSet@1.1992.1.3, 2004-09-26 23:16:04+02:00, kaber@coreworks.de
  [NETFILTER]: Convert sctp match to skb_header_pointer
 
  Signed-off-by: Patrick McHardy <kaber@trash.net>

ChangeSet@1.1992.1.2, 2004-09-26 23:14:34+02:00, kaber@coreworks.de
  [NETFILTER]: make ipt_helper depend on ipt_conntrack again
 
  Signed-off-by: Patrick McHardy <kaber@trash.net>

ChangeSet@1.1992.1.1, 2004-09-26 23:13:21+02:00, kaber@coreworks.de
  [NETFILTER]: Fill hole in netfilter skb fields on 64bit
 
  Signed-off-by: Patrick McHardy <kaber@trash.net>
