From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH 06/11] ipvs: Use struct_size() helper
Date: Mon, 18 Feb 2019 00:23:52 +0100
Message-ID: <20190217232357.29858-7-pablo@netfilter.org>
References: <20190217232357.29858-1-pablo@netfilter.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190217232357.29858-1-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: "Gustavo A. R. Silva" <gustavo@embeddedor.com>

One of the more common cases of allocation size calculations is finding
the size of a structure that has a zero-sized array at the end, along
with memory for some number of elements for that array. For example:

struct foo {
    int stuff;
    struct boo entry[];
};

size = sizeof(struct foo) + count * sizeof(struct boo);
instance = alloc(size, GFP_KERNEL)

Instead of leaving these open-coded and prone to type mistakes, we can
now use the new struct_size() helper:

size = struct_size(instance, entry, count);

This code was detected with the help of Coccinelle.

Signed-off-by: Gustavo A. R. Silva <gustavo@embeddedor.com>
Acked-by: Simon Horman <horms+renesas@verge.net.au>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 net/netfilter/ipvs/ip_vs_ctl.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/net/netfilter/ipvs/ip_vs_ctl.c b/net/netfilter/ipvs/ip_vs_ctl.c
index 432141f04af3..446beeb5e7b2 100644
--- a/net/netfilter/ipvs/ip_vs_ctl.c
+++ b/net/netfilter/ipvs/ip_vs_ctl.c
@@ -2722,8 +2722,7 @@ do_ip_vs_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 		int size;
 
 		get = (struct ip_vs_get_services *)arg;
-		size = sizeof(*get) +
-			sizeof(struct ip_vs_service_entry) * get->num_services;
+		size = struct_size(get, entrytable, get->num_services);
 		if (*len != size) {
 			pr_err("length: %u != %u\n", *len, size);
 			ret = -EINVAL;
@@ -2764,8 +2763,7 @@ do_ip_vs_get_ctl(struct sock *sk, int cmd, void __user *user, int *len)
 		int size;
 
 		get = (struct ip_vs_get_dests *)arg;
-		size = sizeof(*get) +
-			sizeof(struct ip_vs_dest_entry) * get->num_dests;
+		size = struct_size(get, entrytable, get->num_dests);
 		if (*len != size) {
 			pr_err("length: %u != %u\n", *len, size);
 			ret = -EINVAL;
-- 
2.11.0
