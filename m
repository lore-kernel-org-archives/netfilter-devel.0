From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 5/8] netfilter: ipset: Null pointer exception in ipset list:set
Date: Thu, 23 Feb 2017 12:14:06 +0100
Message-ID: <1487848449-2731-6-git-send-email-pablo@netfilter.org>
References: <1487848449-2731-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1487848449-2731-1-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Vishwanath Pai <vpai@akamai.com>

If we use before/after to add an element to an empty list it will cause
a kernel panic.

$> cat crash.restore
create a hash:ip
create b hash:ip
create test list:set timeout 5 size 4
add test b before a

$> ipset -R < crash.restore

Executing the above will crash the kernel.

Signed-off-by: Vishwanath Pai <vpai@akamai.com>
Reviewed-by: Josh Hunt <johunt@akamai.com>
Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
---
 net/netfilter/ipset/ip_set_list_set.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/ipset/ip_set_list_set.c b/net/netfilter/ipset/ip_set_list_set.c
index 51077c53d76b..178d4eba013b 100644
--- a/net/netfilter/ipset/ip_set_list_set.c
+++ b/net/netfilter/ipset/ip_set_list_set.c
@@ -260,11 +260,14 @@ list_set_uadd(struct ip_set *set, void *value, const struct ip_set_ext *ext,
 		else
 			prev = e;
 	}
+
+	/* If before/after is used on an empty set */
+	if ((d->before > 0 && !next) ||
+	    (d->before < 0 && !prev))
+		return -IPSET_ERR_REF_EXIST;
+
 	/* Re-add already existing element */
 	if (n) {
-		if ((d->before > 0 && !next) ||
-		    (d->before < 0 && !prev))
-			return -IPSET_ERR_REF_EXIST;
 		if (!flag_exist)
 			return -IPSET_ERR_EXIST;
 		/* Update extensions */
-- 
2.1.4
