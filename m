From: Eric Leblond <eric@inl.fr>
Subject: [Patch 1/2] queue_maxlen
Date: Fri, 20 Oct 2006 18:40:21 +0200
Message-ID: <1161362421.7529.1.camel@localhost.localdomain>
References: <2BDDB86A-ABD4-4C53-AE17-498AB0F52B28@cadvium.net>
	<1161125685.4002.33.camel@localhost.localdomain>
	<45389F0E.6000000@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-aPoGKQDE6b/rjyDjblWZ"
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


--=-aPoGKQDE6b/rjyDjblWZ
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

Hi,

Here's the kernel patch for queue_maxlen settings.

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

--=-aPoGKQDE6b/rjyDjblWZ
Content-Disposition: attachment;
	filename=specify-queue-max-length-from-userspace.patch
Content-Type: text/x-vhdl; name=specify-queue-max-length-from-userspace.patch;
	charset=us-ascii
Content-Transfer-Encoding: 7bit

------------------------------------------------------------------------
 
Signed-off-by: Eric Leblond <eric@inl.fr>
 
 
---
diff --git a/include/linux/netfilter/nfnetlink_queue.h b/include/linux/netfilter/nfnetlink_queue.h
index 9e77437..22ffac0 100644
--- a/include/linux/netfilter/nfnetlink_queue.h
+++ b/include/linux/netfilter/nfnetlink_queue.h
@@ -82,6 +82,7 @@ enum nfqnl_attr_config {
 	NFQA_CFG_UNSPEC,
 	NFQA_CFG_CMD,			/* nfqnl_msg_config_cmd */
 	NFQA_CFG_PARAMS,		/* nfqnl_msg_config_params */
+	NFQA_CFG_QUEUE_MAXLEN,		/* u_int32_t */
 	__NFQA_CFG_MAX
 };
 #define NFQA_CFG_MAX (__NFQA_CFG_MAX-1)
diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_queue.c
index 86a4ac3..936c86b 100644
--- a/net/netfilter/nfnetlink_queue.c
+++ b/net/netfilter/nfnetlink_queue.c
@@ -939,6 +939,14 @@ nfqnl_recv_config(struct sock *ctnl, str
 				ntohl(params->copy_range));
 	}
 
+	if (nfqa[NFQA_CFG_QUEUE_MAXLEN-1]) {
+		u_int32_t *queue_maxlen;
+		queue_maxlen = NFA_DATA(nfqa[NFQA_CFG_QUEUE_MAXLEN-1]);
+		spin_lock_bh(&queue->lock);
+		queue->queue_maxlen = ntohl(*queue_maxlen);
+		spin_unlock_bh(&queue->lock);
+	}
+
 out_put:
 	instance_put(queue);
 	return ret;

--=-aPoGKQDE6b/rjyDjblWZ--
