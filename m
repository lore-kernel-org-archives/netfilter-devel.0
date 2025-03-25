Received: from mout.gmx.net (mout.gmx.net [212.227.17.20])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 318A62E3381
	for <netfilter-devel@vger.kernel.org>; Tue, 25 Mar 2025 01:07:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.20
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742864850; cv=none; b=eUajhw/R4/KhHAfH7mDhwzVmCiD3qpvlV4UG41rWNavdE+7D/JbMqe/ZfX4rJ8kIIQjh9nUE7Oltj6M7++KcI3eQCN4NKaIgX4wmRKWLwVqKdLygXTL7EdoUM88lfXL90ucJ0owHLfXA2NT+Gt1cozOPxpcdAUfVGeSrpmJe4IM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742864850; c=relaxed/simple;
	bh=0Y46eX/Yt0t5LtaM6bXCKfX7zJxoQ4q/o8P2wkb1tac=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=GuxmlYB0imO7IzQE3JsZ3PRDXIMKn+xhIvRdkTJZy1BJpVjxoEbI1THjWFKgIQMPqAQiGaNAU41mmgMXZ+RO40ZP7TWcDL8vhV43ReZF4NhHZkQB0XZgDl7XWYGctrknHSypa9/e94pg14bQShys1Sbk6fggc88tbHUVInKfWBA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b=bSUW0MZJ; arc=none smtp.client-ip=212.227.17.20
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b="bSUW0MZJ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1742864846; x=1743469646; i=corubba@gmx.de;
	bh=jIUvvmjvcxQ9rhy0bXoxgsfLvfBz8E12MMsxbQvB9To=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:From:To:
	 References:In-Reply-To:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=bSUW0MZJeyi4TDX2HUJ+ZLod2rgH+UA0rOjgIDqOMXOSt4di9PfYrBygbiCp6OEz
	 duSR7vECFl4JsmVy6M1V1eyld2/dQqjzTRdcKXZmRl8H6UzLZ1lPLBXt9T9CyD5/f
	 jqdqXLZWz/MsAG4prAFFofW1JqmVtnZnkPdaZQ4GIuo8MuPkHU3lubzHjgNZJxvjq
	 zcIxMNhRSMeCs4Jh/qnJpwA+08+Eslaulsokz+4oNqB2NIdeAhm8O3HiUYClD4MgU
	 nGTP7G7aCYI7Erlu6BO28gJmSKobsoGBuGohLXVib0ns1zo14n53P5X1ydWPaZc2D
	 2bS90CuK5vRGPh5DNA==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from 127.0.0.1 ([83.135.90.83]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MSbx3-1tZ4MB0kqP-00PWXq for
 <netfilter-devel@vger.kernel.org>; Tue, 25 Mar 2025 02:07:26 +0100
Message-ID: <4c328ab1-b799-4e8b-a786-4329b40043a9@gmx.de>
Date: Tue, 25 Mar 2025 02:07:25 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: [PATCH ulogd2,v2 2/4] nfct: add network namespace support
From: Corubba Smith <corubba@gmx.de>
To: netfilter-devel@vger.kernel.org
References: <c5cd1c3a-3875-4352-8181-5081103f96f6@gmx.de>
Content-Language: de-CH
In-Reply-To: <c5cd1c3a-3875-4352-8181-5081103f96f6@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:hkGsRaxOjxRroPBN37x81nRAgmvjsrb+e5NaHYDKsG+QMMmcSkQ
 9iG4BeW898XMgj8Z5h108cVyl+IuYGhnuGyiArQOKo8kBC6t2OLkqchjC6QaW/7PY9+3hAo
 96zrcwfwM9+xeV+TV8H5euOPHNIrpurVXSJQWjA5ss3vzTo9QQHo8hUipoaQkJ/cxVdnEyY
 vfUkFOFc7iHLGtyY281VQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:9p1Urj5OQyo=;a+D+kwZe5gBktUDl2lUh/kvqpA6
 VoMGBHuijlfdej9e1Hei3siPZoV+Y7sbuwUk6IXpyUxrlsp+ECJ9D28Wh8s7aZhs6zLMOtZsj
 u98A6Is9c94sSglcYqEnIjBJtt4oGaV5ZrhEvf8ARGZJ3WaM29aMZcFkCtY8zyp4u+CxquQXj
 Hz975ZcEiyZwfcYq0ulNkeNM4MqORw90oeDVNygXDudpNOOJA240eS834oOb0bgnRPL5ZHDOO
 j3xfswfY3gV19X7t1Pf9IQOEf76dIm5tfGH3BbVpwCpMzOd6bDLFeY8K7o0MQnAnYLYZleiyI
 fgpUTsOUX7RHbMVFZ+CtPW5BFzPtq/yFhmuPetTYcOi40qAAOqchyu4//BW9pfPLBuzgAbx1+
 vmnvw/1vOjCWlE/oeFqFH/6R+LUlNo8EjRIMWzO8bdmYJ0kjxKAVpXwk7IqOk9VVTIcDVxAco
 gyARjJs1ST7xvvZN9P5AhawOILh2FAAE6bCOXn0wgxZl9n1VUiDT6UJwByar7SypjQV1GawMw
 1JVFTUQv7556n9bU9NUFyC2aSyO7br+7FJSGvCE4WimmYnwiO3yRECoNH3ndhCFb92KdMH2/w
 Nz/3VkUFDMpsDbHnS5YP1QoeA07cOxy+Bn7QmBZ2/QLppQYfgMnEe/cqu7W/xm6BmMWqMMSg1
 b8dl2yC2yd04zDsSaLuoU45uAhWkKKRpFs+P4osk5WgxDTOQg9BmdH4+aOIXUrInmLeayVFqM
 xdKQ6a0KyelpLv7Q+EK0w1ilKq+q0B1XsHN6jt1rPyVVmjPQdbAD7X/0RSXn7skAzJjeYnief
 +nCmdoB7oiYVvI70q4t1NG++eyfADYsiLKC19U6rtGjCps8+PFxJI8gzHyUlz5DjSgDXgrx6x
 ouMzKeAOF8vyiYmAAVze/k/AZ936OsBD7UnEAOHvHl/MXVkE16sFTfS7KHau6enrLDief0NnH
 GRuW9e6d1mMwuqpbIPcuzuNyhWXaXnvqMegHsNYD0m6SUljdN7TG0n8uEwV4oHuxIoJQNjbH5
 EVJk0TyKoESvN3ijC6X97V8vi05bSkAOpqgXQXLDxspzftlUObCLoKIHcn9C/TJ5k/pQvD3yp
 gZCJ4981b2S7EVKqF2NzFZIobp0aTRM8PfAPno138S133ec7zMNpokrancfqGFN3XNBqq1/Ts
 feVHHyI1TNqfaYOQYzAzba+WsVCM6BVYK3j917t5dSO8ehrbYReV1PyFZo/E4+qTOBYBvyA/K
 znrNvu8842Wdu+EfSAMWmiPaWByP2gH98qkj9ZcoOEkkcoH76wlUp9SP/trLlG0QdR12i95j/
 ZFzponu1gZWxKdbNYJ3topa7aCgq1+UEMXoC0p+0xetJG4A955hB0eiIKXx6Ymp6u42GqcLjF
 Mc+rPYOJOBjvg9ol8UGPt980JYwcwvkvUA3pKxMgZZqPsA40aDInuxkbSGERqpG4I/7WMFWfx
 JN+SoZg7Mrgw4VOOX3VcYOQ9kGiw=

Allow the plugin to fetch data from a different network namespace. This
is possible by changing the network namespace before opening the netlink
socket, and immediately changing back to the original network namespace
once the socket is open. The number of nfct_open usages here warranted a
dedicated wrapper function.

If changing back to the original network namespace fails, ulogd will
log an error, but continue to run in a different network namespace than
it was started in, which may cause unexpected behaviour. But I don't see
a way to properly "escalate" it such that ulogd aborts entirely.

Also slightly adjust the error log messages to specify which socket
failed to open.

Signed-off-by: Corubba Smith <corubba@gmx.de>
=2D--
 input/flow/ulogd_inpflow_NFCT.c | 81 +++++++++++++++++++++++++++------
 ulogd.conf.in                   |  1 +
 2 files changed, 69 insertions(+), 13 deletions(-)

diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NF=
CT.c
index 93edb76..7168b24 100644
=2D-- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -45,6 +45,7 @@
 #include <ulogd/timer.h>
 #include <ulogd/ipfix_protocol.h>
 #include <ulogd/addr.h>
+#include <ulogd/namespace.h>

 #include <libnetfilter_conntrack/libnetfilter_conntrack.h>

@@ -78,7 +79,7 @@ struct nfct_pluginstance {
 #define EVENT_MASK	NF_NETLINK_CONNTRACK_NEW | NF_NETLINK_CONNTRACK_DESTRO=
Y

 static struct config_keyset nfct_kset =3D {
-	.num_ces =3D 12,
+	.num_ces =3D 13,
 	.ces =3D {
 		{
 			.key	 =3D "pollinterval",
@@ -149,6 +150,11 @@ static struct config_keyset nfct_kset =3D {
 			.type	 =3D CONFIG_TYPE_STRING,
 			.options =3D CONFIG_OPT_NONE,
 		},
+		{
+			.key     =3D "network_namespace_path",
+			.type    =3D CONFIG_TYPE_STRING,
+			.options =3D CONFIG_OPT_NONE,
+		},
 	},
 };
 #define pollint_ce(x)	(x->ces[0])
@@ -163,6 +169,7 @@ static struct config_keyset nfct_kset =3D {
 #define src_filter_ce(x)	((x)->ces[9])
 #define dst_filter_ce(x)	((x)->ces[10])
 #define proto_filter_ce(x)	((x)->ces[11])
+#define network_namespace_path_ce(x)	((x)->ces[12])

 enum nfct_keys {
 	NFCT_ORIG_IP_SADDR =3D 0,
@@ -979,6 +986,54 @@ static int read_cb_ovh(int fd, unsigned int what, voi=
d *param)
 	return 0;
 }

+/**
+ * nfct_open_in_netns() - Open conntrack netlink socket in a namespace
+ * @subscriptions: ctnetlink groups to subscribe to events
+ * @target_netns_path: path to the network namespace, can be NULL
+ *
+ * On error, NULL is returned and errno is explicitly set.
+ */
+struct nfct_handle *nfct_open_in_netns(unsigned int subscriptions,
+                                       const char *const target_netns_pat=
h)
+{
+	struct nfct_handle *result =3D NULL;
+	int source_netns_fd =3D -1;
+
+	if ((target_netns_path !=3D NULL) &&
+	    (strlen(target_netns_path) > 0) &&
+	    (join_netns_path(target_netns_path, &source_netns_fd) !=3D ULOGD_IRE=
T_OK)) {
+		ulogd_log(ULOGD_FATAL, "error joining target network "
+		                       "namespace\n");
+		goto err_tns;
+	}
+
+	result =3D nfct_open(NFNL_SUBSYS_CTNETLINK, subscriptions);
+	if (result =3D=3D NULL) {
+		ulogd_log(ULOGD_FATAL, "error opening ctnetlink: %s\n",
+		                       strerror(errno));
+		goto err_nfct;
+	}
+
+	if ((target_netns_path !=3D NULL) &&
+	    (strlen(target_netns_path) > 0) &&
+	    (join_netns_fd(source_netns_fd, NULL) !=3D ULOGD_IRET_OK)) {
+		ulogd_log(ULOGD_FATAL, "error joining source network "
+		                       "namespace\n");
+		goto err_sns;
+	}
+	source_netns_fd =3D -1;
+
+	return result;
+
+err_sns:
+	nfct_close(result);
+err_nfct:
+	if (source_netns_fd >=3D 0)
+		close(source_netns_fd);
+err_tns:
+	return NULL;
+}
+
 static int
 dump_reset_handler(enum nf_conntrack_msg_type type,
 		   struct nf_conntrack *ct, void *data)
@@ -1025,7 +1080,7 @@ static void get_ctr_zero(struct ulogd_pluginstance *=
upi)
 	struct nfct_handle *h;
 	int family =3D AF_UNSPEC;

-	h =3D nfct_open(CONNTRACK, 0);
+	h =3D nfct_open_in_netns(0, network_namespace_path_ce(upi->config_kset).=
u.string);
 	if (h =3D=3D NULL) {
 		ulogd_log(ULOGD_FATAL, "Cannot dump and reset counters\n");
 		return;
@@ -1301,10 +1356,10 @@ static int constructor_nfct_events(struct ulogd_pl=
uginstance *upi)
 			(struct nfct_pluginstance *)upi->private;


-	cpi->cth =3D nfct_open(NFNL_SUBSYS_CTNETLINK,
-			     eventmask_ce(upi->config_kset).u.value);
+	cpi->cth =3D nfct_open_in_netns(eventmask_ce(upi->config_kset).u.value,
+	                              network_namespace_path_ce(upi->config_kset=
).u.string);
 	if (!cpi->cth) {
-		ulogd_log(ULOGD_FATAL, "error opening ctnetlink\n");
+		ulogd_log(ULOGD_FATAL, "error opening event netlink socket\n");
 		goto err_cth;
 	}

@@ -1372,9 +1427,9 @@ static int constructor_nfct_events(struct ulogd_plug=
instance *upi)
 		/* populate the hashtable: we use a disposable handler, we
 		 * may hit overrun if we use cpi->cth. This ensures that the
 		 * initial dump is successful. */
-		h =3D nfct_open(CONNTRACK, 0);
+		h =3D nfct_open_in_netns(0, network_namespace_path_ce(upi->config_kset)=
.u.string);
 		if (!h) {
-			ulogd_log(ULOGD_FATAL, "error opening ctnetlink\n");
+			ulogd_log(ULOGD_FATAL, "error opening initial-fill netlink socket\n");
 			goto err_ovh;
 		}
 		nfct_callback_register(h, NFCT_T_ALL,
@@ -1384,9 +1439,9 @@ static int constructor_nfct_events(struct ulogd_plug=
instance *upi)

 		/* the overrun handler only make sense with the hashtable,
 		 * if we hit overrun, we resync with ther kernel table. */
-		cpi->ovh =3D nfct_open(NFNL_SUBSYS_CTNETLINK, 0);
+		cpi->ovh =3D nfct_open_in_netns(0, network_namespace_path_ce(upi->confi=
g_kset).u.string);
 		if (!cpi->ovh) {
-			ulogd_log(ULOGD_FATAL, "error opening ctnetlink\n");
+			ulogd_log(ULOGD_FATAL, "error opening overrun-read netlink socket\n");
 			goto err_ovh;
 		}

@@ -1403,9 +1458,9 @@ static int constructor_nfct_events(struct ulogd_plug=
instance *upi)
 		ulogd_register_fd(&cpi->nfct_ov);

 		/* we use this to purge old entries during overruns.*/
-		cpi->pgh =3D nfct_open(NFNL_SUBSYS_CTNETLINK, 0);
+		cpi->pgh =3D nfct_open_in_netns(0, network_namespace_path_ce(upi->confi=
g_kset).u.string);
 		if (!cpi->pgh) {
-			ulogd_log(ULOGD_FATAL, "error opening ctnetlink\n");
+			ulogd_log(ULOGD_FATAL, "error opening overrun-purge netlink socket\n")=
;
 			goto err_pgh;
 		}
 	}
@@ -1438,9 +1493,9 @@ static int constructor_nfct_polling(struct ulogd_plu=
ginstance *upi)
 		goto err;
 	}

-	cpi->pgh =3D nfct_open(NFNL_SUBSYS_CTNETLINK, 0);
+	cpi->pgh =3D nfct_open_in_netns(0, network_namespace_path_ce(upi->config=
_kset).u.string);
 	if (!cpi->pgh) {
-		ulogd_log(ULOGD_FATAL, "error opening ctnetlink\n");
+		ulogd_log(ULOGD_FATAL, "error opening polling netlink socket\n");
 		goto err;
 	}
 	nfct_callback_register(cpi->pgh, NFCT_T_ALL, &polling_handler, upi);
diff --git a/ulogd.conf.in b/ulogd.conf.in
index 9a04bf7..f7e3fa3 100644
=2D-- a/ulogd.conf.in
+++ b/ulogd.conf.in
@@ -139,6 +139,7 @@ logfile=3D"/var/log/ulogd.log"
 #netlink_socket_buffer_size=3D217088
 #netlink_socket_buffer_maxsize=3D1085440
 #reliable=3D1 # enable reliable flow-based logging (may drop packets)
+#network_namespace_path=3D/run/netns/other # import flows from a differen=
t network namespace
 hash_enable=3D0

 # Logging of system packet through NFLOG
=2D-
2.49.0
