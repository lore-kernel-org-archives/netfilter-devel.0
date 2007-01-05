From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Bugfix: libnetfilter_conntrack getter and setter
Date: Fri, 05 Jan 2007 15:45:20 +0100
Message-ID: <459E6480.1010806@netfilter.org>
References: <200701041103.39580.victor.stinner@inl.fr>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080800090402070202030106"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Victor Stinner <victor.stinner@inl.fr>
In-Reply-To: <200701041103.39580.victor.stinner@inl.fr>
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
--------------080800090402070202030106
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi,

Victor Stinner wrote:
> Libnetfilter_conntrack getters and setters of new API are not complete:
>  * it's not possible to set counter attributes value

Because of ctnetlink, the kernel part of this whole thing, doesn't
support this. Anyway, as you pointed out below, I can't see how this
could be useful.

>  * it's not possible to set or read 'use' and 'id' attributes value

The 'use' attribute must be possible to be get, but not set. I'll commit
the patch for the getter mangled, I prefer dropping the 'id' support
since it's planned to be removed.

> I can understand that setting counter values is not very useful, but trying to 
> set them would lead to a crash (call NULL function). Same problem when trying 
> to read use/id attribute value.

OK, I think that the patch attached should be enough.

> An alternative for nfct_set_attr() is to do nothing if the getter in NULL (and 
> set an error?).

I prefer doing nothing and documenting this issue, perhaps doing some
kind of warning or assertion, although that would be too much I think.
Moreover, the error thing would pollute the code with tons of error
checkings in the set operations.

Thanks again Victor.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris

--------------080800090402070202030106
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 8bit
Content-Disposition: inline;
 filename="x"

Index: src/conntrack/api.c
===================================================================
--- src/conntrack/api.c	(revisión: 6716)
+++ src/conntrack/api.c	(copia de trabajo)
@@ -185,6 +185,12 @@
  * @ct: pointer to a valid conntrack
  * @type: attribute type
  * @value: pointer to the attribute value
+ *
+ * Note that certain attributes are unsettable:
+ * 	- ATTR_USE
+ * 	- ATTR_ID
+ * 	- ATTR_*_COUNTER_*
+ * The call of this function for such attributes do nothing.
  */
 void nfct_set_attr(struct nf_conntrack *ct,
 		   const enum nf_conntrack_attr type, 
@@ -196,8 +202,10 @@
 	if (type >= ATTR_MAX)
 		return;
 
-	set_attr_array[type](ct, value);
-	set_bit(type, ct->set);
+	if (set_attr_array[type]) {
+		set_attr_array[type](ct, value);
+		set_bit(type, ct->set);
+	}
 }
 
 /**
Index: src/conntrack/getter.c
===================================================================
--- src/conntrack/getter.c	(revisión: 6716)
+++ src/conntrack/getter.c	(copia de trabajo)
@@ -162,6 +162,11 @@
 	return &ct->status;
 }
 
+static const void *get_attr_use(const struct nf_conntrack *ct)
+{
+	return &ct->use;
+}
+
 get_attr get_attr_array[] = {
 	[ATTR_ORIG_IPV4_SRC]		= get_attr_orig_ipv4_src,
 	[ATTR_ORIG_IPV4_DST] 		= get_attr_orig_ipv4_dst,
@@ -193,5 +198,6 @@
 	[ATTR_ORIG_COUNTER_BYTES]	= get_attr_orig_counter_bytes,
 	[ATTR_REPL_COUNTER_PACKETS]	= get_attr_repl_counter_packets,
 	[ATTR_REPL_COUNTER_BYTES]	= get_attr_repl_counter_bytes,
+	[ATTR_USE]			= get_attr_use,
 	[ATTR_STATUS]			= get_attr_status,
 };

--------------080800090402070202030106--
