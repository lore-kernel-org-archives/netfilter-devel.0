From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: ASSERT ip_conntrack_core.c:622 &ip_conntrack_lock not
	readlocked
Date: 12 Mar 2003 23:45:49 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1047509148.824.53.camel@tux.rsn.bth.se>
References: <3E6F99C5.1050101@netland.nl>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-efwYsLVtZ8YarcPpvgQl"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: raarts@office.netland.nl
In-Reply-To: <3E6F99C5.1050101@netland.nl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-efwYsLVtZ8YarcPpvgQl
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Wed, 2003-03-12 at 21:34, Ron Arts wrote:
> I get this error on kernel 2.4.21pre4 when I boot. RH 2.4.18 didn't have this problem:
> 
> Mar 12 14:05:52 n000007 kernel: ASSERT ip_conntrack_core.c:622 &ip_conntrack_lock not readlocked
>
> Is this a known problem?

It looks like it's the NAT code that's abusing the locking a bit.
It calls a function in conntrack without taking the correct lock first.

I've attached a small patch that should fix it.
The patch is completely untested, not even testcompiled...
YMMV :)

It would be great if you could try it out and report back if it fixes
the problem or not. This patch will only fix the ASSERT warnings. Not
the actual error that ip_conntrack_ftp couldn't be loaded.

I havn't checked the RH 2.4.18 kernel but I doubt they have netfilter
compiled with debugging like you have. It's the debugging code that
prints out the ASSERT warnings.

Oh now I noticed one more thing. I believe you are trying something like
this:

modprobe ip_nat_ftp ports=121

This will fail unless ip_conntrack_ftp was loaded the same way:

modprobe ip_conntrack_ftp ports=121

The autoloading will not supply the correct arguments to
ip_conntrack_ftp when it tries to autoload it which happens when you
load ip_nat_ftp without having ip_conntrack_ftp loaded.

The error-message could be improved to say what exactly went wrong...
I've attached a small patch for that as well...
(not tested or testcompiled either)

Time to continue trying to get rid of the flu... good night.

-- 
/Martin

Never argue with an idiot. They drag you down to their level, then beat you with experience.

--=-efwYsLVtZ8YarcPpvgQl
Content-Disposition: attachment; filename=ip_ct_find_helper.patch
Content-Type: text/plain; name=ip_ct_find_helper.patch; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

--- linux-2.4.20/net/ipv4/netfilter/ip_conntrack_core.c.orig	2003-03-12 23:=
08:49.000000000 +0100
+++ linux-2.4.20/net/ipv4/netfilter/ip_conntrack_core.c	2003-03-12 23:12:05=
.000000000 +0100
@@ -617,13 +617,24 @@
 	return ip_ct_tuple_mask_cmp(rtuple, &i->tuple, &i->mask);
 }
=20
-struct ip_conntrack_helper *ip_ct_find_helper(const struct ip_conntrack_tu=
ple *tuple)
+struct ip_conntrack_helper *__ip_ct_find_helper(const struct ip_conntrack_=
tuple *tuple)
 {
 	return LIST_FIND(&helpers, helper_cmp,
 			 struct ip_conntrack_helper *,
 			 tuple);
 }
=20
+struct ip_conntrack_helper *ip_ct_find_helper(const struct ip_conntrack_tu=
ple *tuple)
+{
+	struct ip_conntrack_helper *helper;
+=09
+	READ_LOCK(&ip_conntrack_lock);
+	helper =3D __ip_ct_find_helper(tuple);
+	READ_UNLOCK(&ip_conntrack_lock);
+
+	return helper;
+}
+
 /* Allocate a new conntrack: we return -ENOMEM if classification
    failed due to stress.  Otherwise it really is unclassifiable. */
 static struct ip_conntrack_tuple_hash *
@@ -702,7 +713,7 @@
=20
 	/* Look up the conntrack helper for master connections only */
 	if (!expected)
-		conntrack->helper =3D ip_ct_find_helper(&repl_tuple);
+		conntrack->helper =3D __ip_ct_find_helper(&repl_tuple);
=20
 	/* If the expectation is dying, then this is a looser. */
 	if (expected

--=-efwYsLVtZ8YarcPpvgQl
Content-Disposition: attachment; filename=ip_nat_helper-request_module.patch
Content-Type: text/plain; name=ip_nat_helper-request_module.patch; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

--- linux-2.4.20/net/ipv4/netfilter/ip_nat_helper.c.orig	2003-03-12 23:33:5=
6.000000000 +0100
+++ linux-2.4.20/net/ipv4/netfilter/ip_nat_helper.c	2003-03-12 23:40:29.000=
000000 +0100
@@ -501,12 +501,14 @@
 			tmp +=3D 6;
 			sprintf(name, "ip_conntrack%s", tmp);
 #ifdef CONFIG_KMOD
-			if (!request_module(name)
-			    && (ct_helper =3D ip_ct_find_helper(&me->tuple))
+			if (request_module(name)) {
+				printk("unable to load module %s\n", name);
+				return -EBUSY;
+			} else if ((ct_helper =3D ip_ct_find_helper(&me->tuple))
 			    && ct_helper->me) {
 				__MOD_INC_USE_COUNT(ct_helper->me);
 			} else {
-				printk("unable to load module %s\n", name);
+				printk("unable to find sought helper from module %s\n", name);
 				return -EBUSY;
 			}
 #else

--=-efwYsLVtZ8YarcPpvgQl--
