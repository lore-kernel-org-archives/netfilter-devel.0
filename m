From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] 2.6.16.19 Fix the bug of "return 0 instead of the error
 code in ipt_register_table"
Date: Thu, 01 Jun 2006 17:01:42 +0200
Message-ID: <447F0156.8020603@trash.net>
References: <20060601102449.GA8572@gsy2.lepton.home>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030705040603010200050504"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	lkm <linux-kernel@vger.kernel.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: lepton <ytht.net@gmail.com>
In-Reply-To: <20060601102449.GA8572@gsy2.lepton.home>
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

This is a multi-part message in MIME format.
--------------030705040603010200050504
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

lepton wrote:
> Hi,
> 
> There is a bug in ipt_register_table() in
> net/ipv4/netfilter/ip_tables.c:
> 
> ipt_register_table() will return 0 instead of
> the error code when xt_register_table() fails
> 
> Signed-off-by: Lepton Wu <ytht.net@gmail.com>
> 
> diff -prU 10 linux-2.6.16.19.oirg/net/ipv4/netfilter/ip_tables.c linux-2.6.16.19/net/ipv4/netfilter/ip_tables.c
> --- linux-2.6.16.19.oirg/net/ipv4/netfilter/ip_tables.c	2006-05-31 08:31:44.000000000 +0800
> +++ linux-2.6.16.19/net/ipv4/netfilter/ip_tables.c	2006-06-01 18:11:25.000000000 +0800

Thanks. As usual this bug has been happily copy and pasted around,
so I've added this patch instead.


--------------030705040603010200050504
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: x_tables: fix xt_register_table error propagation

When xt_register_table fails the error is not properly propagated back.
Based on patch by Lepton Wu <ytht.net@gmail.com>.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit b010cc3184ce7cb65a9865ae52ec2ce6f3fe4c9d
tree 9744395bcd9c7d976048ebd8afbabfc0a9b542a4
parent 10263005af5814396b8263c1c2a4367d49548e13
author Patrick McHardy <kaber@trash.net> Thu, 01 Jun 2006 16:59:12 +0200
committer Patrick McHardy <kaber@trash.net> Thu, 01 Jun 2006 16:59:12 +0200

 net/ipv4/netfilter/arp_tables.c |    3 ++-
 net/ipv4/netfilter/ip_tables.c  |    3 ++-
 net/ipv6/netfilter/ip6_tables.c |    3 ++-
 3 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/ipv4/netfilter/arp_tables.c b/net/ipv4/netfilter/arp_tables.c
index d0d1919..ad39bf6 100644
--- a/net/ipv4/netfilter/arp_tables.c
+++ b/net/ipv4/netfilter/arp_tables.c
@@ -1120,7 +1120,8 @@ int arpt_register_table(struct arpt_tabl
 		return ret;
 	}
 
-	if (xt_register_table(table, &bootstrap, newinfo) != 0) {
+	ret = xt_register_table(table, &bootstrap, newinfo);
+	if (ret != 0) {
 		xt_free_table_info(newinfo);
 		return ret;
 	}
diff --git a/net/ipv4/netfilter/ip_tables.c b/net/ipv4/netfilter/ip_tables.c
index cee3397..101ad98 100644
--- a/net/ipv4/netfilter/ip_tables.c
+++ b/net/ipv4/netfilter/ip_tables.c
@@ -2113,7 +2113,8 @@ int ipt_register_table(struct xt_table *
 		return ret;
 	}
 
-	if (xt_register_table(table, &bootstrap, newinfo) != 0) {
+	ret = xt_register_table(table, &bootstrap, newinfo);
+	if (ret != 0) {
 		xt_free_table_info(newinfo);
 		return ret;
 	}
diff --git a/net/ipv6/netfilter/ip6_tables.c b/net/ipv6/netfilter/ip6_tables.c
index 2e72f89..0b5bd55 100644
--- a/net/ipv6/netfilter/ip6_tables.c
+++ b/net/ipv6/netfilter/ip6_tables.c
@@ -1281,7 +1281,8 @@ int ip6t_register_table(struct xt_table 
 		return ret;
 	}
 
-	if (xt_register_table(table, &bootstrap, newinfo) != 0) {
+	ret = xt_register_table(table, &bootstrap, newinfo);
+	if (ret != 0) {
 		xt_free_table_info(newinfo);
 		return ret;
 	}

--------------030705040603010200050504--
