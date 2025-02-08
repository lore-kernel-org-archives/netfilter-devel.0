Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D2F19F104
	for <netfilter-devel@vger.kernel.org>; Sat,  8 Feb 2025 13:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739022675; cv=none; b=eNhP4bSa2tkkikRWbFl0UbG4XF/0jm2A9x2Nr7h9lDLUfirahC+fA0/e4UkscEEsNaBVwypQsQqJxxvJfk7KDg7SACTkKKkrSCe7eeMtCRis8jZIpWkHeGcDmnGQbpxnfYnvwrQXfxAuTCEuNolZd4HU+5daOztzO/3l9Hurgh8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739022675; c=relaxed/simple;
	bh=ntngLyZy4JbpXc9h0zxQKiIyvty0EKkgr1T86+r0JhA=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=ZjJ0xAlXDK2opAbYoEOl4o6TovfTI8FRhDrvLRzojfHKn4gNVpcuGccAWeYZZjKHfE1ED/SeCZMNGWGf2srH2oibESjzJ+1YkO2wF8IlHlvzXDdM/5VU79cFQ2SBly/RUsYhp+fYgFGur93xJivWS3eV4xWGRDP7aDRk0wvgHEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b=FsrlHUT1; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b="FsrlHUT1"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1739022671; x=1739627471; i=corubba@gmx.de;
	bh=vs13kRK1ShTc6Ofp+zTrvcLzbZiNlanL8YgYqx/Y+3s=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:From:To:
	 References:In-Reply-To:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=FsrlHUT1q+5C9F9Is4r13gHajHJbx86GhjmqlEInuSGqVsklI/aeSZr0jNw+r8QL
	 VP4lWQSZuS2cpJcJ7BBS0G+yWlp0KQupy+hJbB65KLkmhu04pOgQsoyINwaHqrbxG
	 8hUF8ykPkeKzgr/pN1f8sIyT/6PrVlBKSCPCOJH7YJ1duV3kw0DHoAJq5OWc9mGjG
	 NQaCmwCAqmGR+vqDvDYFAaiAqwiD1Uex/UhAxr98C2gvVUsA7At3jm0PA64BsSrMY
	 0NuoqqQZaPa4uxNwUbzDYDyXgUPxYXvAbypKv0TcXuRg/c7KUjPC00KFD9j1gweZa
	 Mjc0Qa/9gI8NglZKag==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.44.3] ([83.135.91.92]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M5fMY-1tmq2u3wok-00Bio5 for
 <netfilter-devel@vger.kernel.org>; Sat, 08 Feb 2025 14:51:11 +0100
Message-ID: <a7e44c53-0629-4053-b989-748fc0e0e6cb@gmx.de>
Date: Sat, 8 Feb 2025 14:51:10 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH ulogd2 3/3] ipfix: re-arm send timer
From: corubba <corubba@gmx.de>
To: netfilter-devel@vger.kernel.org
References: <0a983b51-9a51-47a7-bbdc-9bf163a88bbd@gmx.de>
Content-Language: de-CH
In-Reply-To: <0a983b51-9a51-47a7-bbdc-9bf163a88bbd@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:3h8b5/MY+DS+FcY7CbxUDS0VbgCLw5U/DpHTNBehyflR4Pr54yl
 EFz33Gm4reyptKCNBHTw0CrSLubZgtV32672SHSK+ug8K84OqMWUwHEeaZUtqS4lKHVdLKK
 r+qk6X5c5b85p5Silz0sZlkuZBX/Uiu3O6WUzw0oGZORyyAL5Gf13pzpgnaAiriVUqL8Icg
 DZxFUebAVegWuovz/BVkA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:RqwDIf1z+gw=;JOcPxt4+9egOHA6Nu5o1oW0V/U4
 lMBZyQRZ7XWjZa583mdnjuK9SIxa7AVwlhYieqynvvbY0txaIePosoCkPWpYcImW0rXZZjV1W
 kd1iYyIPKLJPgZXFfYIGrOYbTxnldn21+P4Hh0YFNKxd5D4PglD6IaiZhgJQmZipq9bTVi1or
 pJn6oaXZ72/rwtqbMlFlN9nKUSVXPdT0CFETzjy0JZpfGFsW7LbNfz0nW+vtwbJ/7fxBHGQub
 zxaiP/7CIOjgYbTQpyrtJLAesZKB+SQgzscE1qt7XI5HAMJlmwyzfFwDPwDJuowozL/mOWeRs
 y9Kej4uDg3lFFHSeMktLkPg+oG7aF3xbP2WUSiNDQVNzf14vmmwiEEj0JD6ukE1Z/RKaGhSTw
 f61/m9LbM8V5/pQH86mfYRP+/HgL15Xw5jbCBuohW8e+DTEnOrOzQLF/ky87h4oW/oM5ZVBsm
 FaaG565+QLPnyXD8VXsI4dqLCPs3gqAq4FUas0PitzC5suAItQL24sLdzFStquB/o3skAwJ/t
 UDwBldS1gQLE1zlbmxR65T+8Y/T/uL9Ko/r3js8xP73dR3e/olvaRHvVMPUtxWymtMFwjacBS
 TVJaGbsoPIoYC9M85r1pDLg2N0S9d+IxKrVeItE1aWK+K7b/ub9J/8/DgTgVbbyLSYr82o7OF
 APVV1LOxZhkKPLJ4j9noBrFHnugP8O5JxLY5SnB/RnPkoGc3Xld35JuDmrRPkeVxajFAZnUGr
 tC8INtwBAIv5S67uPV4JDlqoQiQT8v5N2fzMAiKyJay9FpD28r/aazB/ERYdxdYHdWPhQILFM
 KtPNxusvBxMuvRfrNwWfUeXQRCRPQfo3Eq2pasyh96W0TrnFf46a87EHmvbyWmkxOXaB2th3t
 Wl9ed0H3m142WQovN0N6VU7mffe0zDhqhvet504GqPHO0jS2s4ZHzIRntQ3eEB84ucbnIpCqn
 I8sGLSEN8cTDEDWYeX4Uk2YP+uJBTHHFKvaNIu3qfGPYfIinQiIasouUlSUfnxioawP3/hjMc
 N5j8+XQtFY7sAO9XWEic8y9n+QxGtPwb5CjP2rHuvhuYN1h3gQGkkMnauSYZXi5Zi6yDIm34E
 7Pn76WQZgJJBEcF8tmRpd/5q2EyC6kXRjNManxK3CUBX9StNu46/z4QiGaLjGNyJsrjZFIJNo
 wtl9xKSFxnxTgiqu+Pq3VBbqlZUqb4OKs9BazR0qbD0SEkonx2Dz2/rXCx7tCs8eibks3QhgD
 RkeXT4MaLlvFe0N8M4Ur1lv8BP4so19mtbYdYBRj+mf8zyZk+YNYpFmsk7VIYx+/+H8Chtq9L
 koLQrb6lrV4O5NpSVgbiuGHFCXDFA5fnph9ZvYuenKHjxYGUTpSZ/92lq8HBgNWIsPcq7/gHM
 YmIHsP3rMCRp+laCXGPmHe0ewxJJwodW6qFlZrx0lePSl31q2I06Ikv2XJcLwTdTVz1ejQjvM
 SeaaZ0w==

I am not sure what this timer was meant to do. My best guess is to send
an ipfix message every second if there is data, as to make sure reports
go out in a timely manner. Otherwise a message is only sent when adding
another flow would go past the max mtu, which may take a while if there
isn't much (filtered) traffic.

Timers in ulogd only fire once; if you want them to fire repeatedly
(which I guess was the intention here), you need to re-arm them in the
callback. Because that wasn't done, the timer only fired once 1 second
after starting the plugin (when there is unlikely any data yet), and
then never again.

The timer is now re-armed in the callback to make it fire repeatedly
every second(ish). A macro is used to make sure the initial and re-arm
time interval is the same.

Broken since 4f639231.

Signed-off-by: Corubba Smith <corubba@gmx.de>
=2D--
 output/ipfix/ulogd_output_IPFIX.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/output/ipfix/ulogd_output_IPFIX.c b/output/ipfix/ulogd_output=
_IPFIX.c
index 1c0f730..c1fe1ab 100644
=2D-- a/output/ipfix/ulogd_output_IPFIX.c
+++ b/output/ipfix/ulogd_output_IPFIX.c
@@ -83,6 +83,8 @@ static const struct config_keyset ipfix_kset =3D {
 	}
 };

+#define SEND_TIMER_INTERVAL_SEC	1
+
 struct ipfix_priv {
 	struct ulogd_fd ufd;
 	uint32_t seqno;
@@ -259,6 +261,8 @@ static void ipfix_timer_cb(struct ulogd_timer *t, void=
 *data)
 		priv->msg =3D NULL;
 		send_msgs(pi);
 	}
+
+	ulogd_add_timer(&priv->timer, SEND_TIMER_INTERVAL_SEC);
 }

 static int ipfix_configure(struct ulogd_pluginstance *pi, struct ulogd_pl=
uginstance_stack *stack)
@@ -394,8 +398,8 @@ static int ipfix_start(struct ulogd_pluginstance *pi)
 	if (ulogd_register_fd(&priv->ufd) < 0)
 		return ULOGD_IRET_ERR;

-	/* Add a 1 second timer */
-	ulogd_add_timer(&priv->timer, 1);
+	/* Start the repeating send timer */
+	ulogd_add_timer(&priv->timer, SEND_TIMER_INTERVAL_SEC);

 	return ULOGD_IRET_OK;
 }
=2D-
2.48.1

