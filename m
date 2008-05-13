From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 1/2]: ctnetlink: dump conntrack ID in event messages
Date: Tue, 13 May 2008 13:33:54 +0200
Message-ID: <48297CA2.3060904@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060108070904090608050802"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: "David S. Miller" <davem@davemloft.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39640 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbYEMLeb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 May 2008 07:34:31 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060108070904090608050802
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi Dave,

these two patches add missing modules aliases to xt_iprange, fixing
autoloading with old (as in: not from SVN) iptables versions and
change ctnetlink to include the conntrack ID in event messages, which
we wanted to do some time ago already, apparently I lost the patch.
I'll also push the xt_iprange patch to -stable.

Please apply, thanks.

  net/netfilter/nf_conntrack_netlink.c |    3 +++
  net/netfilter/xt_iprange.c           |    2 ++
  2 files changed, 5 insertions(+), 0 deletions(-)

Eric Leblond (1):
       [NETFILTER]: ctnetlink: dump conntrack ID in event messages

Phil Oester (1):
       [NETFILTER]: xt_iprange: module aliases for xt_iprange


--------------060108070904090608050802
Content-Type: text/x-diff;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

[NETFILTER]: ctnetlink: dump conntrack ID in event messages

Conntrack ID is not put (anymore ?) in event messages. This causes current ulogd2
code to fail because it uses the ID to build a hash in userspace. This hash is
used to be able to output the starting time of a connection.

Conntrack ID can be used in userspace application to maintain an easy match
between kernel connections list and userspace one. It may worth to add it if
there is no performance related issue.

Signed-off-by: Eric Leblond <eric@inl.fr>

[ Patrick: it was never included in events, but really should be ]

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit fee65a663d85aa9af3b295064e974ccb692e2c9c
tree 270fe662a648b07d5a4e26c2bc78a28356af5424
parent c4492586a618d18e8a5343a04bad0ec606064846
author Eric Leblond <eric@inl.fr> Tue, 13 May 2008 13:21:47 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 13 May 2008 13:21:47 +0200

 net/netfilter/nf_conntrack_netlink.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 16774ec..0edefcf 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -472,6 +472,9 @@ static int ctnetlink_conntrack_event(struct notifier_block *this,
 		goto nla_put_failure;
 	nla_nest_end(skb, nest_parms);
 
+	if (ctnetlink_dump_id(skb, ct) < 0)
+		goto nla_put_failure;
+
 	if (events & IPCT_DESTROY) {
 		if (ctnetlink_dump_counters(skb, ct, IP_CT_DIR_ORIGINAL) < 0 ||
 		    ctnetlink_dump_counters(skb, ct, IP_CT_DIR_REPLY) < 0)

--------------060108070904090608050802--
