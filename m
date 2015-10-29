From: Feng Gao <gfree.wind@outlook.com>
Subject: Re: [PATCH 1/1] netfilter: Add nf_conntrack_helpers_register to fix one kernel panic
Date: Thu, 29 Oct 2015 23:26:03 +0800
Message-ID: <BAY403-EAS38873A5D692190561F771FF95200@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: <netfilter-devel@vger.kernel.org>
To: "'Pablo Neira Ayuso'" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bay004-omc1s21.hotmail.com ([65.54.190.32]:51008 "EHLO
	BAY004-OMC1S21.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757167AbbJ2P0H convert rfc822-to-8bit
	(ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Oct 2015 11:26:07 -0400
Content-Language: zh-cn
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

Thanks you. I will commit the second patch according to your advices.
I will run the scripts/checkpatch.pl to check the coding style every ti=
me.
Is it ok if the script says no error?

I find there is one lost ")" in the last patch. The following diff fixe=
s it.
And I find there are some warnings when I compile the patch with latest=
 gcc,
I will fix them with the second patch.

When execute "insmod nf_conntrack_ftp.ko ports=3D76,76", the kernel cra=
shes
immediately.Because the old codes try to unregister the helper which is
not registered successfully.
Now add new function nf_conntrack_helpers_register to fix this bug.
It would unregister the right helpers automatically if someone fails.

Signed-off-by: Gao Feng <fgao@ikuai8.com>
---
 include/net/netfilter/nf_conntrack_helper.h |    5 ++++
 net/netfilter/nf_conntrack_ftp.c            |   33
++++++--------------------
 net/netfilter/nf_conntrack_helper.c         |   29 +++++++++++++++++++=
++++
 net/netfilter/nf_conntrack_irc.c            |   20 ++++++---------
 net/netfilter/nf_conntrack_sane.c           |   27 ++++++-------------=
--
 net/netfilter/nf_conntrack_sip.c            |   25 +++++--------------
 net/netfilter/nf_conntrack_tftp.c           |   22 +++++------------
 7 files changed, 72 insertions(+), 89 deletions(-)

diff --git a/include/net/netfilter/nf_conntrack_helper.h
b/include/net/netfilter/nf_conntrack_helper.h
index 6cf614b..a6be9da 100644
--- a/include/net/netfilter/nf_conntrack_helper.h
+++ b/include/net/netfilter/nf_conntrack_helper.h
@@ -62,6 +62,11 @@ struct nf_conntrack_helper
*nf_conntrack_helper_try_module_get(const char *name,
 int nf_conntrack_helper_register(struct nf_conntrack_helper *);
 void nf_conntrack_helper_unregister(struct nf_conntrack_helper *);
=20
+int nf_conntrack_helpers_register(struct nf_conntrack_helper *,
+				unsigned int);
+void nf_conntrack_helpers_unregister(struct nf_conntrack_helper *,
+				unsigned int);
+
 struct nf_conn_help *nf_ct_helper_ext_add(struct nf_conn *ct,
 					  struct nf_conntrack_helper
*helper,
 					  gfp_t gfp);
diff --git a/net/netfilter/nf_conntrack_ftp.c
b/net/netfilter/nf_conntrack_ftp.c
index b666959..06bedf6 100644
--- a/net/netfilter/nf_conntrack_ftp.c
+++ b/net/netfilter/nf_conntrack_ftp.c
@@ -580,19 +580,7 @@ static const struct nf_conntrack_expect_policy
ftp_exp_policy =3D {
 /* don't make this __exit, since it's called from __init ! */
 static void nf_conntrack_ftp_fini(void)
 {
-	int i, j;
-	for (i =3D 0; i < ports_c; i++) {
-		for (j =3D 0; j < 2; j++) {
-			if (ftp[i][j].me =3D=3D NULL)
-				continue;
-
-			pr_debug("nf_ct_ftp: unregistering helper for pf: %d
"
-				 "port: %d\n",
-				 ftp[i][j].tuple.src.l3num, ports[i]);
-			nf_conntrack_helper_unregister(&ftp[i][j]);
-		}
-	}
-
+	nf_conntrack_helpers_unregister(ftp, ports_c * 2);
 	kfree(ftp_buffer);
 }
=20
@@ -624,21 +612,16 @@ static int __init nf_conntrack_ftp_init(void)
 				sprintf(ftp[i][j].name, "ftp");
 			else
 				sprintf(ftp[i][j].name, "ftp-%d", ports[i]);
-
-			pr_debug("nf_ct_ftp: registering helper for pf: %d "
-				 "port: %d\n",
-				 ftp[i][j].tuple.src.l3num, ports[i]);
-			ret =3D nf_conntrack_helper_register(&ftp[i][j]);
-			if (ret) {
-				printk(KERN_ERR "nf_ct_ftp: failed to
register"
-				       " helper for pf: %d port: %d\n",
-					ftp[i][j].tuple.src.l3num,
ports[i]);
-				nf_conntrack_ftp_fini();
-				return ret;
-			}
 		}
 	}
=20
+	ret =3D nf_conntrack_helpers_register(ftp, ports_c * 2);
+	if (ret) {
+		pr_err("nf_ct_ftp: failed to register helpers\n");
+		kfree(ftp_buffer);
+		return ret;
+	}
+
 	return 0;
 }
=20
diff --git a/net/netfilter/nf_conntrack_helper.c
b/net/netfilter/nf_conntrack_helper.c
index bd9d315..8412963 100644
--- a/net/netfilter/nf_conntrack_helper.c
+++ b/net/netfilter/nf_conntrack_helper.c
@@ -456,6 +456,35 @@ void nf_conntrack_helper_unregister(struct
nf_conntrack_helper *me)
 }
 EXPORT_SYMBOL_GPL(nf_conntrack_helper_unregister);
=20
+int nf_conntrack_helpers_register(struct nf_conntrack_helper *me,
+			unsigned int n)
+{
+	unsigned int i;
+	int err =3D 0;
+
+	for (i =3D 0; i < n; ++i) {
+		err =3D nf_conntrack_helper_register(&me[i]);
+		if (err)
+			goto err;
+	}
+
+	return err;
+
+err:
+	if (i > 0)
+		nf_conntrack_helpers_unregister(me, i);
+	return err;
+}
+EXPORT_SYMBOL_GPL(nf_conntrack_helpers_register);
+
+void nf_conntrack_helpers_unregister(struct nf_conntrack_helper *me,
+			unsigned int n)
+{
+	while (n-- > 0)
+		nf_conntrack_helper_unregister(&me[n]);
+}
+EXPORT_SYMBOL_GPL(nf_conntrack_helpers_unregister);
+
 static struct nf_ct_ext_type helper_extend __read_mostly =3D {
 	.len	=3D sizeof(struct nf_conn_help),
 	.align	=3D __alignof__(struct nf_conn_help),
diff --git a/net/netfilter/nf_conntrack_irc.c
b/net/netfilter/nf_conntrack_irc.c
index 0fd2976..7c27575 100644
--- a/net/netfilter/nf_conntrack_irc.c
+++ b/net/netfilter/nf_conntrack_irc.c
@@ -264,16 +264,15 @@ static int __init nf_conntrack_irc_init(void)
 			sprintf(irc[i].name, "irc");
 		else
 			sprintf(irc[i].name, "irc-%u", i);
+	}
=20
-		ret =3D nf_conntrack_helper_register(&irc[i]);
-		if (ret) {
-			printk(KERN_ERR "nf_ct_irc: failed to register
helper "
-			       "for pf: %u port: %u\n",
-			       irc[i].tuple.src.l3num, ports[i]);
-			nf_conntrack_irc_fini();
-			return ret;
-		}
+	ret =3D nf_conntrack_helpers_register(irc, ports_c);
+	if (ret) {
+		pr_err("nf_ct_irc: failed to register helpers\n");
+		kfree(irc_buffer);
+		return ret;
 	}
+
 	return 0;
 }
=20
@@ -281,10 +280,7 @@ static int __init nf_conntrack_irc_init(void)
  * it is needed by the init function */
 static void nf_conntrack_irc_fini(void)
 {
-	int i;
-
-	for (i =3D 0; i < ports_c; i++)
-		nf_conntrack_helper_unregister(&irc[i]);
+	nf_conntrack_helpers_unregister(irc, ports_c);
 	kfree(irc_buffer);
 }
=20
diff --git a/net/netfilter/nf_conntrack_sane.c
b/net/netfilter/nf_conntrack_sane.c
index 4a2134f..8fe6e8f 100644
--- a/net/netfilter/nf_conntrack_sane.c
+++ b/net/netfilter/nf_conntrack_sane.c
@@ -174,17 +174,7 @@ static const struct nf_conntrack_expect_policy
sane_exp_policy =3D {
 /* don't make this __exit, since it's called from __init ! */
 static void nf_conntrack_sane_fini(void)
 {
-	int i, j;
-
-	for (i =3D 0; i < ports_c; i++) {
-		for (j =3D 0; j < 2; j++) {
-			pr_debug("nf_ct_sane: unregistering helper for pf:
%d "
-				 "port: %d\n",
-				 sane[i][j].tuple.src.l3num, ports[i]);
-			nf_conntrack_helper_unregister(&sane[i][j]);
-		}
-	}
-
+	nf_conntrack_helpers_unregister(sane, ports_c * 2);
 	kfree(sane_buffer);
 }
=20
@@ -219,17 +209,16 @@ static int __init nf_conntrack_sane_init(void)
 			pr_debug("nf_ct_sane: registering helper for pf: %d
"
 				 "port: %d\n",
 				 sane[i][j].tuple.src.l3num, ports[i]);
-			ret =3D nf_conntrack_helper_register(&sane[i][j]);
-			if (ret) {
-				printk(KERN_ERR "nf_ct_sane: failed to "
-				       "register helper for pf: %d port:
%d\n",
-					sane[i][j].tuple.src.l3num,
ports[i]);
-				nf_conntrack_sane_fini();
-				return ret;
-			}
 		}
 	}
=20
+	ret =3D nf_conntrack_helpers_register(sane, ports_c * 2);
+	if (ret) {
+		pr_err("nf_ct_sane: failed to register helpers\n");
+		kfree(sane_buffer);
+		return ret;
+	}
+
 	return 0;
 }
=20
diff --git a/net/netfilter/nf_conntrack_sip.c
b/net/netfilter/nf_conntrack_sip.c
index 885b4ab..0606dc0 100644
--- a/net/netfilter/nf_conntrack_sip.c
+++ b/net/netfilter/nf_conntrack_sip.c
@@ -1614,15 +1614,7 @@ static const struct nf_conntrack_expect_policy
sip_exp_policy[SIP_EXPECT_MAX + 1
=20
 static void nf_conntrack_sip_fini(void)
 {
-	int i, j;
-
-	for (i =3D 0; i < ports_c; i++) {
-		for (j =3D 0; j < ARRAY_SIZE(sip[i]); j++) {
-			if (sip[i][j].me =3D=3D NULL)
-				continue;
-			nf_conntrack_helper_unregister(&sip[i][j]);
-		}
-	}
+	nf_conntrack_helpers_unregister(sip, ports_c * ARRAY_SIZE(sip[0]));
 }
=20
 static int __init nf_conntrack_sip_init(void)
@@ -1662,17 +1654,14 @@ static int __init nf_conntrack_sip_init(void)
 				sprintf(sip[i][j].name, "sip-%u", i);
=20
 			pr_debug("port #%u: %u\n", i, ports[i]);
-
-			ret =3D nf_conntrack_helper_register(&sip[i][j]);
-			if (ret) {
-				printk(KERN_ERR "nf_ct_sip: failed to
register"
-				       " helper for pf: %u port: %u\n",
-				       sip[i][j].tuple.src.l3num, ports[i]);
-				nf_conntrack_sip_fini();
-				return ret;
-			}
 		}
 	}
+
+	ret =3D nf_conntrack_helpers_register(sip, ports_c *
ARRAY_SIZE(sip[0]));
+	if (ret) {
+		pr_err("nf_ct_sip: failed to register helpers\n");
+		return ret;
+	}
 	return 0;
 }
=20
diff --git a/net/netfilter/nf_conntrack_tftp.c
b/net/netfilter/nf_conntrack_tftp.c
index e68ab4f..0d3b7ad 100644
--- a/net/netfilter/nf_conntrack_tftp.c
+++ b/net/netfilter/nf_conntrack_tftp.c
@@ -104,12 +104,7 @@ static const struct nf_conntrack_expect_policy
tftp_exp_policy =3D {
=20
 static void nf_conntrack_tftp_fini(void)
 {
-	int i, j;
-
-	for (i =3D 0; i < ports_c; i++) {
-		for (j =3D 0; j < 2; j++)
-			nf_conntrack_helper_unregister(&tftp[i][j]);
-	}
+	nf_conntrack_helpers_unregister(tftp, ports_c * 2);
 }
=20
 static int __init nf_conntrack_tftp_init(void)
@@ -135,17 +130,14 @@ static int __init nf_conntrack_tftp_init(void)
 				sprintf(tftp[i][j].name, "tftp");
 			else
 				sprintf(tftp[i][j].name, "tftp-%u", i);
-
-			ret =3D nf_conntrack_helper_register(&tftp[i][j]);
-			if (ret) {
-				printk(KERN_ERR "nf_ct_tftp: failed to
register"
-				       " helper for pf: %u port: %u\n",
-					tftp[i][j].tuple.src.l3num,
ports[i]);
-				nf_conntrack_tftp_fini();
-				return ret;
-			}
 		}
 	}
+
+	ret =3D nf_conntrack_helpers_register(tftp, ports_c * 2);
+	if (ret) {
+		pr_err("nf_ct_tftp: failed to register helpers\n");
+		return ret;
+	}
 	return 0;
 }



-----=D3=CA=BC=FE=D4=AD=BC=FE-----
=B7=A2=BC=FE=C8=CB: Pablo Neira Ayuso [mailto:pablo@netfilter.org]=20
=B7=A2=CB=CD=CA=B1=BC=E4: 2015=C4=EA10=D4=C227=C8=D5 3:54
=CA=D5=BC=FE=C8=CB: Feng Gao <gfree.wind@outlook.com>
=B3=AD=CB=CD: netfilter-devel@vger.kernel.org
=D6=F7=CC=E2: Re: [PATCH 1/1] netfilter: Add nf_conntrack_helpers_regis=
ter to fix
one kernel panic

Hi,

On Wed, Oct 21, 2015 at 11:22:41PM +0800, Feng Gao wrote:
> When execute "insmod nf_conntrack_ftp.ko ports=3D76,76", the kernel=20
> crashes immediately.Because the old codes try to unregister the helpe=
r=20
> which is not registered successfully.
> Now add new function nf_conntrack_helpers_register to fix this bug.
> It would unregister the right helpers automatically if someone fails.
>
> Signed-off-by: Gao Feng <fgao@ikuai8.com>
> ---
>  include/net/netfilter/nf_conntrack_helper.h |    5 ++++
>  net/netfilter/nf_conntrack_ftp.c            |   33
> ++++++--------------------
>  net/netfilter/nf_conntrack_helper.c         |   29
+++++++++++++++++++++++
>  net/netfilter/nf_conntrack_irc.c            |   20 ++++++---------
>  net/netfilter/nf_conntrack_sane.c           |   27 ++++++-----------=
----
>  net/netfilter/nf_conntrack_sip.c            |   25 +++++------------=
--
>  net/netfilter/nf_conntrack_tftp.c           |   22 +++++------------
>  7 files changed, 72 insertions(+), 89 deletions(-)
>
> diff --git a/include/net/netfilter/nf_conntrack_helper.h
> b/include/net/netfilter/nf_conntrack_helper.h
> index 6cf614b..a6be9da 100644
> --- a/include/net/netfilter/nf_conntrack_helper.h
> +++ b/include/net/netfilter/nf_conntrack_helper.h
> @@ -62,6 +62,11 @@ struct nf_conntrack_helper=20
> *nf_conntrack_helper_try_module_get(const char *name,  int=20
> nf_conntrack_helper_register(struct nf_conntrack_helper *);  void=20
> nf_conntrack_helper_unregister(struct nf_conntrack_helper *);
>
> +int nf_conntrack_helpers_register(struct nf_conntrack_helper *,
> +								unsigned
> int);

Thanks for following up on this. Please, get familiarized with the Linu=
x
kernel coding style:

http://lxr.free-electrons.com/source/Documentation/CodingStyle

On top of that, it would be great if you can add a nf_ct_helper_init()
generic function that we can reuse to configure the helper in first pla=
ce.
This initialization happens over and over again, it would help to
consolidate the existing infrastructure.

Then, we can untangle the existing code by using a unidimensional array
instead.

Upon that initial patch to add nf_ct_helper_init() you can cook a secon=
d
patch to add the new nf_conntrack_helpers_register() functions.

I didn't compile tested this, but I would expect that the result looks
similar to the code snippet below.

-o-

static struct nf_conntrack_helper sip[MAX_PORTS * 4] __read_mostly;

static int __init nf_conntrack_sip_init(void) {
        struct nf_conntrack_helper tmpl[4];
        int i, j, ret;

        if (ports_c =3D=3D 0)
                ports[ports_c++] =3D SIP_PORT;

        memset(tmpl, 0, sizeof(tmpl));
        nf_ct_helper_init(&tmpl[0], AF_INET, IPPROTO_UDP, sip_help_udp,
                          sizeof(struct nf_ct_sip_master),
                          sip_exp_policy, SIP_EXPECT_MAX, THIS_MODULE);
        nf_ct_helper_init(&tmpl[1], AF_INET, IPPROTO_TCP, sip_help_tcp,
                          sizeof(struct nf_ct_sip_master),
                          sip_exp_policy, SIP_EXPECT_MAX, THIS_MODULE);
        nf_ct_helper_init(&tmpl[2], AF_INET6, IPPROTO_UDP, sip_help_udp=
,
                          sizeof(struct nf_ct_sip_master),
                          sip_exp_policy, SIP_EXPECT_MAX, THIS_MODULE);
        nf_ct_helper_init(&tmpl[3], AF_INET6, IPPROTO_TCP, sip_help_tcp=
,
                          sizeof(struct nf_ct_sip_master),
                          sip_exp_policy, SIP_EXPECT_MAX, THIS_MODULE);

        for (i =3D 0; i < ARRAY_SIZE(sip); i +=3D ARRAY_SIZE(tmpl)) {
                memcpy(&sip[i], tmpl, sizeof(tmpl));
                for (j =3D 0; j < ARRAY_SIZE(tmpl); j++) {
                        if (sip[i + j] =3D=3D SIP_PORT)
                                sprintf(sip[i][j].name, "sip");
                        else
                                sprintf(sip[i][j].name, "sip-%u", i);
        }

        return nf_conntrack_helpers_register(sip, ARRAY_SIZE(sip)); }

-o-

The only variable part is the name, the remaining (most of it) can be
arranged in the template form above.

Thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
