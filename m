From: Jones Desougi <jones@ingate.com>
Subject: [PATCH]: ipset kernel memory allocations
Date: Fri, 18 Nov 2005 01:53:39 +0100
Message-ID: <200511180053.jAI0rd1S031000@usagi.ingate.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: kadlec@netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi,

The kernel ipset code in patch-o-matic-ng has code
like this in three places:

tmp = kmalloc(...);
if (!map) { ... }

i.e. checking the wrong variable. Map cannot be false
here, it is used in the size calculation for kmalloc.
Probably all of these originate from a single source.
The patch below fixes them.

   /Jones


Signed-off-by: Jones Desougi <jones@ingate.com>

Index: patchlets/set/linux/net/ipv4/netfilter/ip_set_iphash.c
===================================================================
--- patchlets/set/linux/net/ipv4/netfilter/ip_set_iphash.c	(revision 4540)
+++ patchlets/set/linux/net/ipv4/netfilter/ip_set_iphash.c	(working copy)
@@ -171,7 +171,7 @@
 
 	tmp = kmalloc(sizeof(struct ip_set_iphash) 
 		      + map->probes * sizeof(uint32_t), GFP_ATOMIC);
-	if (!map) {
+	if (!tmp) {
 		DP("out of memory for %d bytes",
 		   sizeof(struct ip_set_iphash)
 		   + map->probes * sizeof(uint32_t));
Index: patchlets/set/linux/net/ipv4/netfilter/ip_set_ipporthash.c
===================================================================
--- patchlets/set/linux/net/ipv4/netfilter/ip_set_ipporthash.c	(revision 4540)
+++ patchlets/set/linux/net/ipv4/netfilter/ip_set_ipporthash.c	(working copy)
@@ -270,7 +270,7 @@
 
 	tmp = kmalloc(sizeof(struct ip_set_ipporthash) 
 		      + map->probes * sizeof(uint32_t), GFP_ATOMIC);
-	if (!map) {
+	if (!tmp) {
 		DP("out of memory for %d bytes",
 		   sizeof(struct ip_set_ipporthash)
 		   + map->probes * sizeof(uint32_t));
Index: patchlets/set/linux/net/ipv4/netfilter/ip_set_nethash.c
===================================================================
--- patchlets/set/linux/net/ipv4/netfilter/ip_set_nethash.c	(revision 4540)
+++ patchlets/set/linux/net/ipv4/netfilter/ip_set_nethash.c	(working copy)
@@ -234,7 +234,7 @@
 
 	tmp = kmalloc(sizeof(struct ip_set_nethash) 
 		      + map->probes * sizeof(uint32_t), GFP_ATOMIC);
-	if (!map) {
+	if (!tmp) {
 		DP("out of memory for %d bytes",
 		   sizeof(struct ip_set_nethash)
 		   + map->probes * sizeof(uint32_t));
Index: patchlets/set/linux-2.6/net/ipv4/netfilter/ip_set_iphash.c
===================================================================
--- patchlets/set/linux-2.6/net/ipv4/netfilter/ip_set_iphash.c	(revision 4540)
+++ patchlets/set/linux-2.6/net/ipv4/netfilter/ip_set_iphash.c	(working copy)
@@ -170,7 +170,7 @@
 
 	tmp = kmalloc(sizeof(struct ip_set_iphash) 
 		      + map->probes * sizeof(uint32_t), GFP_ATOMIC);
-	if (!map) {
+	if (!tmp) {
 		DP("out of memory for %d bytes",
 		   sizeof(struct ip_set_iphash)
 		   + map->probes * sizeof(uint32_t));
Index: patchlets/set/linux-2.6/net/ipv4/netfilter/ip_set_ipporthash.c
===================================================================
--- patchlets/set/linux-2.6/net/ipv4/netfilter/ip_set_ipporthash.c	(revision 4540)
+++ patchlets/set/linux-2.6/net/ipv4/netfilter/ip_set_ipporthash.c	(working copy)
@@ -269,7 +269,7 @@
 
 	tmp = kmalloc(sizeof(struct ip_set_ipporthash) 
 		      + map->probes * sizeof(uint32_t), GFP_ATOMIC);
-	if (!map) {
+	if (!tmp) {
 		DP("out of memory for %d bytes",
 		   sizeof(struct ip_set_ipporthash)
 		   + map->probes * sizeof(uint32_t));
Index: patchlets/set/linux-2.6/net/ipv4/netfilter/ip_set_nethash.c
===================================================================
--- patchlets/set/linux-2.6/net/ipv4/netfilter/ip_set_nethash.c	(revision 4540)
+++ patchlets/set/linux-2.6/net/ipv4/netfilter/ip_set_nethash.c	(working copy)
@@ -233,7 +233,7 @@
 
 	tmp = kmalloc(sizeof(struct ip_set_nethash) 
 		      + map->probes * sizeof(uint32_t), GFP_ATOMIC);
-	if (!map) {
+	if (!tmp) {
 		DP("out of memory for %d bytes",
 		   sizeof(struct ip_set_nethash)
 		   + map->probes * sizeof(uint32_t));
