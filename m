From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER 02/05]: nf_conntrack: automatic sysctl registation
 for conntrack protocols
Date: Mon, 27 Nov 2006 11:30:45 +0100
Message-ID: <456ABE55.1050800@trash.net>
References: <20061126144447.4215.87216.sendpatchset@localhost.localdomain>	<20061126144450.4215.9710.sendpatchset@localhost.localdomain>
	<200611270517.kAR5HMV3029948@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050306080002090200080609"
Cc: netfilter-devel@lists.netfilter.org, kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200611270517.kAR5HMV3029948@toshiba.co.jp>
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
--------------050306080002090200080609
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Yasuyuki KOZAKAI wrote:
> From: Patrick McHardy <kaber@trash.net>
> Date: Sun, 26 Nov 2006 15:44:50 +0100 (MET)
> 
> 
>>[NETFILTER]: nf_conntrack: automatic sysctl registation for conntrack protocols
>>
>>Add helper functions for sysctl registration with optional instantiating
>>of common path elements (like net/netfilter) and use it for support for
>>automatic registation of conntrack protocol sysctls.
>>
>>Signed-off-by: Patrick McHardy <kaber@trash.net>
> 
> 
> The automatic registration is good idea. I expected only nf_ct_register_sysctl().

I had that at first, but since the shared sysctl table stuff is fairly
specific to the conntrack protocols I put it there. If we find other
users for this we can still move it.

>>+static int nf_ct_l3proto_register_sysctl(struct nf_conntrack_l3proto *l3proto)
>>+{
>>+	int err = 0;
>>+
>>+#ifdef CONFIG_SYSCTL
>>+	mutex_lock(&nf_ct_proto_sysctl_mutex);
>>+	if (l3proto->ctl_table != NULL) {
>>+		err = nf_ct_register_sysctl(&l3proto->ctl_table_header,
>>+					    l3proto->ctl_table_path,
>>+					    l3proto->ctl_table, NULL);
>>+	}
>>+	mutex_unlock(&nf_ct_proto_sysctl_mutex);
>>+#endif
>>+	return err;
>>+}
>>+
>>+static void nf_ct_l3proto_unregister_sysctl(struct nf_conntrack_l3proto *l3proto)
>>+{
>>+#ifdef CONFIG_SYSCTL
>>+	mutex_lock(&nf_ct_proto_sysctl_mutex);
>>+	if (l3proto->ctl_table != NULL)
>>+		nf_ct_unregister_sysctl(&l3proto->ctl_table_header,
>>+					l3proto->ctl_table, NULL);
>>+	mutex_unlock(&nf_ct_proto_sysctl_mutex);
>>+#endif
>>+}
> 
> 
> How about inline ?

Both are in really performance-uncritical paths, so I'll let the
compiler decide.

> 
> 
>>+
> 
> 
> (snip)
> 
> 
>> int nf_conntrack_l3proto_register(struct nf_conntrack_l3proto *proto)
>> {
>> 	int ret = 0;
>>@@ -139,6 +195,12 @@ int nf_conntrack_l3proto_register(struct
>> 		goto out_unlock;
>> 	}
>> 	nf_ct_l3protos[proto->l3proto] = proto;
>>+	write_unlock_bh(&nf_conntrack_lock);
>>+
>>+	ret = nf_ct_l3proto_register_sysctl(proto);
>>+	if (ret < 0)
>>+		nf_conntrack_l3proto_unregister(proto);
>>+	return ret;
> 
> 
> Is this safe ? The neither nf_ct_unregister_sysctl nor nf_unregister_sysctl
> doesn't have NULL check for header. nf_conntrack_l4proto_register() has
> same issue as well.

D'oh :) Good catch, I added this before adding the cleanup part in
unregister. I've changed the check in unregister_sysctl to check
for a non-NULL header.

>>+static struct ctl_table *
>>+path_dup(struct ctl_table *path, struct ctl_table *table)
>>+{
>>+	struct ctl_table *t, *last = NULL, *tmp;
>>+
>>+	for (t = path; t != NULL; t = t->child) {
>>+		tmp = kmemdup(t, 2 * sizeof(*t), GFP_KERNEL);
> 
> 
> Why twice space is necessary ?

Once for the element, once for the 0-terminator. I've added
a comment ..


--------------050306080002090200080609
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/net/netfilter/nf_conntrack_proto.c b/net/netfilter/nf_conntrack_proto.c
index 0afc298..941b5c3 100644
--- a/net/netfilter/nf_conntrack_proto.c
+++ b/net/netfilter/nf_conntrack_proto.c
@@ -173,7 +173,7 @@ static void nf_ct_l3proto_unregister_sys
 {
 #ifdef CONFIG_SYSCTL
 	mutex_lock(&nf_ct_proto_sysctl_mutex);
-	if (l3proto->ctl_table != NULL)
+	if (l3proto->ctl_table_header != NULL)
 		nf_ct_unregister_sysctl(&l3proto->ctl_table_header,
 					l3proto->ctl_table, NULL);
 	mutex_unlock(&nf_ct_proto_sysctl_mutex);
@@ -260,7 +260,8 @@ static void nf_ct_l4proto_unregister_sys
 {
 #ifdef CONFIG_SYSCTL
 	mutex_lock(&nf_ct_proto_sysctl_mutex);
-	if (l4proto->ctl_table != NULL)
+	if (l4proto->ctl_table_header != NULL &&
+	    *l4proto->ctl_table_header != NULL)
 		nf_ct_unregister_sysctl(l4proto->ctl_table_header,
 					l4proto->ctl_table,
 					l4proto->ctl_table_users);
diff --git a/net/netfilter/nf_sysctl.c b/net/netfilter/nf_sysctl.c
index 18e0186..82af0d9 100644
--- a/net/netfilter/nf_sysctl.c
+++ b/net/netfilter/nf_sysctl.c
@@ -24,6 +24,8 @@ path_dup(struct ctl_table *path, struct 
 	struct ctl_table *t, *last = NULL, *tmp;
 
 	for (t = path; t != NULL; t = t->child) {
+		/* twice the size since path elements are terminated by an
+		 * empty element */
 		tmp = kmemdup(t, 2 * sizeof(*t), GFP_KERNEL);
 		if (tmp == NULL) {
 			if (last != NULL)

--------------050306080002090200080609--
