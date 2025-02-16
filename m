Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE363186287
	for <netfilter-devel@vger.kernel.org>; Sun, 16 Feb 2025 14:05:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739714706; cv=none; b=NoPv6YR+46NbUohLHL4QUGDKOowypUb3iKf5pDlp757QHDB+DAMTHGBk2gJ7DHB6bEScPIlxHmGjfRIA8bT6AZLVPofnWhEDrguFXrVbLsFVDntYhrR+SerejkpIK31sADkrR95oPc/N+nHFFEC2XZ56GuXHZqvW/pI0wOZs+/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739714706; c=relaxed/simple;
	bh=mGtly71Myr5PWeq4SdKxTakJQcqbEftSqaxPTsy/N8w=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=AbYnZX/hDJtnvHuzKt2CU8LMB7kxizXaYqBIYGhyszosghSnJILei0iHcVydC/zLQm9Qj/DJL4EtGIEIYPkLLaSQs9wDdhGBBiovAhkHkn6sLpnKuz/TqepUJAw5qBAOjHvCctj4Ac5BoFfUF7Qu0dZ+k0UeLhz5I/JASsjThto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b=oTFDJ29+; arc=none smtp.client-ip=212.227.17.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b="oTFDJ29+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1739714702; x=1740319502; i=corubba@gmx.de;
	bh=T7zLWzK2NJDz/LmUt7vNcfkNoyneR1yVtEPBnoH+zQk=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:From:To:
	 References:In-Reply-To:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=oTFDJ29++Dyc11SdYPuCrKX1CbgqbWaPe0NxeOkbwZFeUdmp5GcJy13S34p6cIvN
	 hROCCCktK+5LEBvtXQ/8rxQdlv7FWjh0UVX3VyNDGbqcAafTX33PDm4f2tzUsQQgJ
	 IrZRxST0np+pPwUuuPDgbYmQ+ZAxkCeWZ9KYRswEfmlP2n/JvgojWWQI5dFa8Nx6M
	 BvqHPFtbDiLwMLfWeGKayO3YV2JTL2tiSAP3Kci6qmzYDthw7zlpaExXfz06KqOHe
	 JDNibJttI/nLlPvHPUQnuQ5Yk4ixEbpGtpoHdbJUIJLCqujEkCe+KPHI+/Awf5bbV
	 dfCxMdYOmJP2sAJNOQ==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.44.3] ([83.135.91.182]) by mail.gmx.net (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MD9XF-1taYb10Hr7-001zO8 for
 <netfilter-devel@vger.kernel.org>; Sun, 16 Feb 2025 15:05:02 +0100
Message-ID: <c1966494-383b-4003-ac1a-aa566fb428a8@gmx.de>
Date: Sun, 16 Feb 2025 15:05:01 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH ulogd2 v2 3/3] ipfix: re-arm send timer
From: Corubba Smith <corubba@gmx.de>
To: netfilter-devel@vger.kernel.org
References: <6b8f641d-7ed2-4e1a-8ecc-c77488f71f00@gmx.de>
Content-Language: de-CH
In-Reply-To: <6b8f641d-7ed2-4e1a-8ecc-c77488f71f00@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:gj8i7vJaEqhQcu9t8iImraoF1t1bGUbaEVx4fhNkfosYOQUV8VO
 YcIVOvZshy4jMthxj5SuMgveb0H+OLt1brUBxr9nXIUe9a+A8JOeONyn8S15PG1eaCxnWzL
 pA5Wzb7VvTLadm767uJyxa1yuKLHmej3NpACU0AVTNgM7qxxitHNt+V9rTLvjV2fazhOIJ4
 2y+rWUlX+cRtHA3FJ3pvg==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:STvhOf/oWgM=;jr10hE/sZ19xd3pzJmnxLn2/qhG
 N7Eb++Gyadh3Nys6m33zmVLPgYUJCnPbUECxemsK3X79PoEwjmq6BJ0VeS+aAff3/PkYcb7eV
 YclQa/zyf2d9CBK28hoLcykO66vpuVsr0Y50uLRVpTslXR8QSlYYK+d9A7e/xEIH57zabGi8n
 c/5BvLx6zlJUN3caqgOSt+hiiaPvw+Xx32qAYa5Fnu0nRpevwweLVx17fNRwzmbLH0veWPNP2
 1HW/2jXD+oAIoTHy2tHFYzlNvK0DJ619lvdfHUNjCtaayom0sM6EezxAXG0BiQ9nemTLfaHYA
 nXjYL5IIqzRAq5ljE3kGZLsDJ79w6tHaqO5Qb3omLJ7nUQvHWe8ToFEq8F2MQf6e6i57sMxUz
 MNYCx3lS1q5JptnxmLJb43tIOtLCnMkCA/MLJXtGYUuXhiVRVqaxVQCDHAgSgoDKmUQ0sJPTy
 ydTWOSw71bZtTcU7HKZiHnLFSZiYRWNXciQiJUsM0kpFgCYpQQ+6WKF1ErgvWCVeRrq4hHJte
 oJTt3zIFQWjHcCdtxeid7ef8fWV6LpViJRdqImZnNWG/E7OOYsBigsRd/RIKi4QSLuWNbc2cb
 6SFpzWhmLyP/ZDOqNmVtQxFfJDDFTW1DL/jwYLMAGsXxU2o66JT7g5vp2oK43jNAV2c1zx4Cl
 Pj3eYfOsuvjv27l1/KZ39hD01cz04PHalD8h1OGzcvDgbbqIjglQYPYv2nWYSpfBrz/z88YuC
 Y6i8jDZnCdDyIQFRHdEmfdAzYrpYGtUFSHSP7MDea3CNlsH1jYLYnjMDOGH1ie6oZYCMdE5Lx
 GCiKI7yTC9ARsQiCm2dpSq98WqPj/wmFGYQGNP5GnMASlv5eVpr7Af5iQ2+a4UIrWcjihh1XH
 21JmTGiyqrkWLdhj5mFvVINmu8mcRHrFVn5hH9WyQOU2pZ6hrBItyw9VcqczKZslvY7EKlmGA
 d2u7W1W8WCSxuZkQO8qQa8DG7CMDZ25GH9ZY3ta6kcsxEQFI4YaqzJxJ7GLeUh0OHQ27KAhI0
 YfhydbZWzyn4JPwWIc/vq0MPt4/L3XLXJaTN2C7aeBb++xw2MWraj6Yphdll6Cqua4czNSNfK
 csXIZKlkUbOg0WZYz4hZYv7VT5loFtps03x+2esEVBb44tOzPjCseMZFlknH35kKCzIu4NhMI
 WNor8jVU3mukYFq6nyoSrWthWgkAV0D35vQRTkIDpKPo9xrwlqtm00qaxvay0pKuC9I29VHYE
 QnER+bjrOYB7un2e6/YNb1UyVBTpYJtloWNLyNSb61JPx/oWdmxsRLGMC1FmoxUA9kyPnW4dM
 TLLS7NSaRLFOo3A2YUx4OTwsL5pCM0w+ohLM4lbD7NfefgWH2O5aUMlekWzBp4OehgUiLe0m5
 gSpf1S5Bm0Q2QoaFcC7wYTg4xZBWo0/3ciI2gz7Q4y1J3JIwCB6zHvCFH1tgFZ38vlltc38Tx
 1PFQ+jA==

I am not sure what this timer was meant to do. My best guess is to send
an ipfix message every second if there is data, as to make sure reports
go out in a timely manner. Otherwise a message is only sent when adding
another flow would go past the max mtu, which may take a while if there
isn't much (filtered) traffic.

Timers in ulogd only fire once; if they should fire repeatedly (which I
guess was the intention here), they need to be re-armed in the callback.
Because that wasn't done, the timer only fired once 1 second after
starting the plugin (when there is unlikely any data yet), and then
never again.

The timer is now re-armed in the callback to make it fire repeatedly
every second(ish). A macro is used to make sure the initial and re-arm
time interval is the same.

Fixes: 4f639231c83b ("IPFIX: Add IPFIX output plugin")
Signed-off-by: Corubba Smith <corubba@gmx.de>
=2D--
 output/ipfix/ulogd_output_IPFIX.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/output/ipfix/ulogd_output_IPFIX.c b/output/ipfix/ulogd_output=
_IPFIX.c
index 1c0f730..88e0035 100644
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

