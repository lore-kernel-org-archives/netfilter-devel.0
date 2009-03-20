From: Patrick McHardy <kaber@trash.net>
Subject: libnl: mark nl_data arguments const
Date: Fri, 20 Mar 2009 18:02:38 +0100
Message-ID: <49C3CC2E.8090005@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000108010302090308010100"
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Thomas Graf <tgraf@suug.ch>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33422 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756849AbZCTRCn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Mar 2009 13:02:43 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000108010302090308010100
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Hi Thomas,

following are two small patches from my nftables libnl tree. Please
apply, thanks.



--------------000108010302090308010100
Content-Type: text/x-patch;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

commit cad96e43817fca7c51268735d56388a0187e0031
Author: Patrick McHardy <kaber@trash.net>
Date:   Tue Mar 17 05:47:32 2009 +0100

    libnl: mark nl_data arguments const
    
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/include/netlink/data.h b/include/netlink/data.h
index 071159e..c6ad811 100644
--- a/include/netlink/data.h
+++ b/include/netlink/data.h
@@ -21,18 +21,19 @@ extern "C" {
 struct nl_data;
 
 /* General */
-extern struct nl_data *	nl_data_alloc(void *, size_t);
-extern struct nl_data * nl_data_alloc_attr(struct nlattr *);
-extern struct nl_data *	nl_data_clone(struct nl_data *);
+extern struct nl_data *	nl_data_alloc(const void *, size_t);
+extern struct nl_data * nl_data_alloc_attr(const struct nlattr *);
+extern struct nl_data *	nl_data_clone(const struct nl_data *);
 extern int		nl_data_append(struct nl_data *, void *, size_t);
 extern void		nl_data_free(struct nl_data *);
 
 /* Access Functions */
-extern void *		nl_data_get(struct nl_data *);
-extern size_t		nl_data_get_size(struct nl_data *);
+extern void *		nl_data_get(const struct nl_data *);
+extern size_t		nl_data_get_size(const struct nl_data *);
 
 /* Misc */
-extern int		nl_data_cmp(struct nl_data *, struct nl_data *);
+extern int		nl_data_cmp(const struct nl_data *,
+				    const struct nl_data *);
 
 #ifdef __cplusplus
 }
diff --git a/lib/data.c b/lib/data.c
index 03cd9fe..f0fa849 100644
--- a/lib/data.c
+++ b/lib/data.c
@@ -35,7 +35,7 @@
  * 
  * @return Newly allocated data handle or NULL
  */
-struct nl_data *nl_data_alloc(void *buf, size_t size)
+struct nl_data *nl_data_alloc(const void *buf, size_t size)
 {
 	struct nl_data *data;
 
@@ -69,7 +69,7 @@ errout:
  * @see nla_data_alloc
  * @return Newly allocated data handle or NULL
  */
-struct nl_data *nl_data_alloc_attr(struct nlattr *nla)
+struct nl_data *nl_data_alloc_attr(const struct nlattr *nla)
 {
 	return nl_data_alloc(nla_data(nla), nla_len(nla));
 }
@@ -80,7 +80,7 @@ struct nl_data *nl_data_alloc_attr(struct nlattr *nla)
  *
  * @return Cloned object or NULL
  */
-struct nl_data *nl_data_clone(struct nl_data *src)
+struct nl_data *nl_data_clone(const struct nl_data *src)
 {
 	return nl_data_alloc(src->d_data, src->d_size);
 }
@@ -141,7 +141,7 @@ void nl_data_free(struct nl_data *data)
  * @arg data		Abstract data object.
  * @return Data buffer or NULL if empty.
  */
-void *nl_data_get(struct nl_data *data)
+void *nl_data_get(const struct nl_data *data)
 {
 	return data->d_size > 0 ? data->d_data : NULL;
 }
@@ -151,7 +151,7 @@ void *nl_data_get(struct nl_data *data)
  * @arg data		Abstract data object.
  * @return Size of data buffer.
  */
-size_t nl_data_get_size(struct nl_data *data)
+size_t nl_data_get_size(const struct nl_data *data)
 {
 	return data->d_size;
 }
@@ -171,10 +171,10 @@ size_t nl_data_get_size(struct nl_data *data)
  *         a is found, respectively, to be less than, to match, or
  *         be greater than b.
  */
-int nl_data_cmp(struct nl_data *a, struct nl_data *b)
+int nl_data_cmp(const struct nl_data *a, const struct nl_data *b)
 {
-	void *a_ = nl_data_get(a);
-	void *b_ = nl_data_get(b);
+	const void *a_ = nl_data_get(a);
+	const void *b_ = nl_data_get(b);
 
 	if (a_ && b_)
 		return memcmp(a_, b_, nl_data_get_size(a));

--------------000108010302090308010100--
