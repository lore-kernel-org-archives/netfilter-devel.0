From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: [PATCH v2 net] netfilter: x_tables: avoid out-of-bounds reads in
 xt_request_find_{match|target}
Date: Wed, 24 Jan 2018 17:16:09 -0800
Message-ID: <1516842969.3715.41.camel@gmail.com>
References: <1516834188.3715.35.camel@gmail.com>
         <20180124231952.GC14192@breakpoint.cc>
         <20180124235056.ahubcyqostttvtbx@salvia>
         <20180125001336.ilboagwlcpck54ip@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Cc: netdev <netdev@vger.kernel.org>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180125001336.ilboagwlcpck54ip@salvia>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

It looks like syzbot found its way into netfilter territory.

Issue here is that @name comes from user space and might
not be null terminated.

Out-of-bound reads happen, KASAN is not happy.

v2 added similar fix for xt_request_find_target(),
as Florian advised.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: syzbot <syzkaller@googlegroups.com>
---
No Fixes: tag, bug seems to be a day-0 one.

 net/netfilter/x_tables.c |    6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 55802e97f906d1987ed78b4296584deb38e5f876..ecffc51ce83b07c063a0db67cdb33d9bf48a75ac 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -210,6 +210,9 @@ xt_request_find_match(uint8_t nfproto, const char *name, uint8_t revision)
 {
 	struct xt_match *match;
 
+	if (strnlen(name, XT_EXTENSION_MAXNAMELEN) == XT_EXTENSION_MAXNAMELEN)
+		return ERR_PTR(-EINVAL);
+
 	match = xt_find_match(nfproto, name, revision);
 	if (IS_ERR(match)) {
 		request_module("%st_%s", xt_prefix[nfproto], name);
@@ -252,6 +255,9 @@ struct xt_target *xt_request_find_target(u8 af, const char *name, u8 revision)
 {
 	struct xt_target *target;
 
+	if (strnlen(name, XT_EXTENSION_MAXNAMELEN) == XT_EXTENSION_MAXNAMELEN)
+		return ERR_PTR(-EINVAL);
+
 	target = xt_find_target(af, name, revision);
 	if (IS_ERR(target)) {
 		request_module("%st_%s", xt_prefix[af], name);
