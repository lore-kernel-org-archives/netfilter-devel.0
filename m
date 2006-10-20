From: Eric Leblond <eric@inl.fr>
Subject: [Patch 2/2] queue_maxlen
Date: Fri, 20 Oct 2006 18:41:35 +0200
Message-ID: <1161362495.7529.4.camel@localhost.localdomain>
References: <2BDDB86A-ABD4-4C53-AE17-498AB0F52B28@cadvium.net>
	<1161125685.4002.33.camel@localhost.localdomain>
	<45389F0E.6000000@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-4bvp6P3/H1WcLoaG4jfW"
Cc: robert <rbscott@cadvium.net>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <45389F0E.6000000@trash.net>
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


--=-4bvp6P3/H1WcLoaG4jfW
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

Here's the userspace patch against libnetfilter_queue.

BR,

Le vendredi 20 octobre 2006 =E0 12:03 +0200, Patrick McHardy a =E9crit :
> Eric Leblond wrote:
> > Hi,
> >=20
> > Le mardi 17 octobre 2006 =E0 15:43 -0700, robert a =E9crit :
> >=20
> >>Does NFQUEUE use the value in /proc/sys/net/ip_queue_maxlen?  If not, =20
> >>is it possible to modify the maximum queue length for NFQUEUE?
> >=20
> >=20
> > Not with vanilla tree.
> >=20
> > I've post a patch to enable it some times ago but It has not been
> > incorporated into main tree :
> >=20
> > http://patchwork.netfilter.org/netfilter-devel/patch.pl?id=3D3628
> > http://patchwork.netfilter.org/netfilter-devel/patch.pl?id=3D3629
> >=20
> > With that patch it is possible to do so on a per-queue basis by using
> > the new function nfq_set_queue_maxlen.
>=20
> Please resend, I probably missed it.
>=20
>=20

--=-4bvp6P3/H1WcLoaG4jfW
Content-Disposition: attachment;
	filename*0=libnetfilter_queue-specify-queue-max-length-from-userspace.pa;
	filename*1=tch
Content-Type: text/x-vhdl;
	name=libnetfilter_queue-specify-queue-max-length-from-userspace.patch;
	charset=us-ascii
Content-Transfer-Encoding: quoted-printable

------------------------------------------------------------------------
=20
Signed-off-by: Eric Leblond <eric@inl.fr>
=20
=20
---


Index: include/libnetfilter_queue/linux_nfnetlink_queue.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- include/libnetfilter_queue/linux_nfnetlink_queue.h	(r=C3=A9vision 6470)
+++ include/libnetfilter_queue/linux_nfnetlink_queue.h	(copie de travail)
@@ -1,13 +1,13 @@
 #ifndef _NFNETLINK_QUEUE_H
 #define _NFNETLINK_QUEUE_H
=20
-#include <linux/types.h>
-#include <libnfnetlink/linux_nfnetlink.h>
-
 #ifndef aligned_u64
 #define aligned_u64 unsigned long long __attribute__((aligned(8)))
 #endif
=20
+#include <linux/types.h>
+#include <libnfnetlink/linux_nfnetlink.h>
+
 enum nfqnl_msg_types {
 	NFQNL_MSG_PACKET,		/* packet from kernel to userspace */
 	NFQNL_MSG_VERDICT,		/* verdict from userspace to kernel */
@@ -86,6 +86,7 @@
 	NFQA_CFG_UNSPEC,
 	NFQA_CFG_CMD,			/* nfqnl_msg_config_cmd */
 	NFQA_CFG_PARAMS,		/* nfqnl_msg_config_params */
+	NFQA_CFG_QUEUE_MAXLEN,		/* u_int32_t */
 	__NFQA_CFG_MAX
 };
 #define NFQA_CFG_MAX (__NFQA_CFG_MAX-1)
Index: include/libnetfilter_queue/libnetfilter_queue.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- include/libnetfilter_queue/libnetfilter_queue.h	(r=C3=A9vision 6470)
+++ include/libnetfilter_queue/libnetfilter_queue.h	(copie de travail)
@@ -49,6 +49,9 @@
 extern int nfq_set_mode(struct nfq_q_handle *qh,
 			  u_int8_t mode, unsigned int len);
=20
+int nfq_set_queue_maxlen(struct nfq_q_handle *qh,
+			u_int32_t queuelen);
+
 extern int nfq_set_verdict(struct nfq_q_handle *qh,
 			     u_int32_t id,
 			     u_int32_t verdict,
Index: src/libnetfilter_queue.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- src/libnetfilter_queue.c	(r=C3=A9vision 6470)
+++ src/libnetfilter_queue.c	(copie de travail)
@@ -288,6 +288,23 @@
 	return nfnl_talk(qh->h->nfnlh, nmh, 0, 0, NULL, NULL, NULL);
 }
=20
+int nfq_set_queue_maxlen(struct nfq_q_handle *qh,
+				u_int32_t queuelen)
+{
+	char buf[NFNL_HEADER_LEN
+		+NFA_LENGTH(sizeof(struct nfqnl_msg_config_params))];
+	u_int32_t queue_maxlen =3D htonl(queuelen);
+	struct nlmsghdr *nmh =3D (struct nlmsghdr *) buf;
+
+	nfnl_fill_hdr(qh->h->nfnlssh, nmh, 0, AF_UNSPEC, qh->id,
+			NFQNL_MSG_CONFIG, NLM_F_REQUEST|NLM_F_ACK);
+
+	nfnl_addattr_l(nmh, sizeof(buf), NFQA_CFG_QUEUE_MAXLEN, &queue_maxlen,
+			sizeof(queue_maxlen));
+
+	return nfnl_talk(qh->h->nfnlh, nmh, 0, 0, NULL, NULL, NULL);
+}
+
 static int __set_verdict(struct nfq_q_handle *qh, u_int32_t id,
 		u_int32_t verdict, u_int32_t mark, int set_mark,
 		u_int32_t data_len, unsigned char *data)

--=-4bvp6P3/H1WcLoaG4jfW--
