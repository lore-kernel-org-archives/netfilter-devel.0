Received: from mout.gmx.net (mout.gmx.net [212.227.17.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 931431A3031
	for <netfilter-devel@vger.kernel.org>; Sat,  8 Mar 2025 21:30:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741469409; cv=none; b=acRhf56gxcFXfxrOkVNXbbLR9yEJfoF/lkbDjTg+A/3YEOfWfQS6wR9pBx5Qu68T8MRBUZRavuNZm8AYGnuTsro/936n2RxfC4T6YKYLRakaUUaxX0udBHy8n7PPbFztUu6XMe4UNlsXsxsa5kf5OMRsQGBpnyj8o3HdpMuQKaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741469409; c=relaxed/simple;
	bh=josyPVSDxuV1aGDiBOaITuc3NwiSlLky1m/3b+BQnSQ=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=RdSZXHSxw/c9s2UTBgfZzn5U6RzL8pCbP2ekGsa5rW8tiavEcvk5GEnlL+695d8rHjm+9quaUw8Lr0s7YzbXyocHJTFFxGV6pIyTdSeKz5zJinM1PE6KPLKncXm3PxMsH7PbgqBrKZksciVLNV3wb7uv9wLTC+N2JrtUIwuNANg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de; spf=pass smtp.mailfrom=gmx.de; dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b=cgfdr0EV; arc=none smtp.client-ip=212.227.17.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gmx.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmx.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmx.de header.i=corubba@gmx.de header.b="cgfdr0EV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=gmx.de;
	s=s31663417; t=1741469405; x=1742074205; i=corubba@gmx.de;
	bh=p/vskVoajySsLYS8XyNj3mokB1Nyse+ZyQPXKQX+g8w=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:From:To:
	 References:In-Reply-To:Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=cgfdr0EVkW96+xb2wyB5R7MuS6g4M2UmIeUmp/C5LswGcDHGIKGNpGlLkaC2R1xX
	 Tq9lnPErzWWwlSpgMWkEJVcYwZvAspl67H5z7kRfG1qHMJaEP2Aqn6QKNANYiCieD
	 7QFSK4/gsu7GefW+zZHUutULP6AKriH0RnCKI5/6JjwlsExhVefu0dgphapAHIc+v
	 AEjj3gwVus5Og1x/+H6ue2pKRJTYvtW2nszjAyyw8w6Ncqxu1TUcy8SadRvj98/xP
	 LKTCqfxIgNBoFjl9Ypqb1MIf2vV821pr9gOGvnqORwtBdz5EotO3yCOMWLqUmrr22
	 fPZFWYyKIuR/iSN/Tg==
X-UI-Sender-Class: 724b4f7f-cbec-4199-ad4e-598c01a50d3a
Received: from [192.168.44.3] ([83.135.91.164]) by mail.gmx.net (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1M5QFB-1tqCOe2TyP-00Eluv for
 <netfilter-devel@vger.kernel.org>; Sat, 08 Mar 2025 22:30:05 +0100
Message-ID: <62c6a4c2-7679-4f89-b0be-c5090293e5a7@gmx.de>
Date: Sat, 8 Mar 2025 22:30:05 +0100
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: [PATCH ulogd2 2/2] nfct: add icmpv6
From: Corubba Smith <corubba@gmx.de>
To: netfilter-devel@vger.kernel.org
References: <2710a46a-f5d9-4b0a-853c-4a53d68e3486@gmx.de>
Content-Language: en-GB
In-Reply-To: <2710a46a-f5d9-4b0a-853c-4a53d68e3486@gmx.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:p+AdKQLpIY8QczYvygOVwr+aJi1U4tghggUWfEiUClGKJIMHBIo
 46QRpibBc0uNf4XIJYL4OsWjZmCLrVf6Y5HZ6yEvRNsQjqtJXJuc9p1XP0DmLyBaDYxwzKY
 GXWSIgM1XI4Sm1oN2t0NA1UK4JkrM1WyQeP/9QodU+8GHutzOS9AiJ0vGzzQcyJo1HypA0N
 AvkMrM/n30IS2QUVCgXaQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:dKx3TbVtEio=;sNzNHHIOWgpV/KAq23vnGCVzmqR
 Ty5e5h+RArcldlIUm5bQLZuZLAtLsxnOZPdesNHd9+Uo6HScrKiwAVcdtPqsOvXV86rxBdjXH
 bCOS6f+V3K8YQTieHZwLmIDWKdpo6ZvIPbTeZRk3KCSg3eil8N26ixHJmGazNiTGOYLWXPYKJ
 hxfIyGDVi5sTsDQ4I2nTnHtvOYy8PHcy+HhZUHyloyMKipjyAz7WNMtbxvIDpbZkqNC4kB19p
 3cDRvFa5e53oZIPlSIty3REYaXUhT1Jr5xqYvgNI7/K/rytvU2Lifkfa4CGSwrS5tASClSkVh
 ZrOnDjJHS/Kf6j6a7OXu6SRdZpYNBBJH1ygltp22mE8GipyPq8vurMLIS2LUYL8nPogj8N/IH
 MoncNNu/MHsW8ehaBM+r+0G4CHJG6A8hS8P1anlUSUJ0vUstLW9erK77LpFbfvwYBvuRQC+M7
 cg4XPUc/HAxHt3GEoK8ODv6eo+46QPISFBjtJ/zEyPk2LDxQ0ARdSNaoTtU91DwezS037YHxY
 9ed8l77yuiiuCkwLnyb3o2HIVkX3OntvmNlr8vfaG4rzLf9K1k3Uv1fgXbQpQLe2riFR1I/dL
 wnu93KvUkcCz5hq9kmxIOrxPSnPlMFaMdrQVwWhwZL1gAZRzKhhmz2hKvwiP6VEY28Mtk+KiC
 jrtJSxo1xkUnq1VSuhqg9NCotOvWXkGEH+vYBIoliZLf9jcb87BXckRYAfYEvrQVqeShtDqBi
 fRL3Ka8YWy7RaX9i6NzUNwuzVBEeM465NBpz/5blYCYjD8afG545KXQMboPHfaRZyAMFAu1Bx
 DKPYjtnkIu5nl+Om3y0pBI6zSnZVNA+zHWBmiPM8moH5olbvmvfkxcGCBIQgp33JRfdKxniI2
 Xw/ZRQ3FWNmufX3AttYvGVsdNWFcl1DB05XhnPqnYHwBTKWna+SPlqNLXNt5602Z0qhzS0gJZ
 aN0c4AzxZFf4tzeuTykYtgYPBHvS5004puLJTmJrIIYkf8EUwMcTT32DFuMFyzjbmLYQmleIL
 liyDFdJneeJecdpaBiTR/CJRsQWLCa823Xew9LfLKKkOR/ObSLgOXTfMWO9ns8S1evVWxVvsJ
 RDRWn6875yj9yHqsp6q/iPkib01TkO5N8yKirKtVJGJMOnrz9tGKwTuNYNjpZJm9NtIFG1rtt
 GLUHeON9Rv5Os7fgj0HHSLxbbJ7I/AJL6LSsByLIgGq1y3Dghz9MjLjmNaRIDdz3nYBfjkKdH
 isI3IFrgdQ2dXzidYHDwiOCi6chuwybRWglAqRB4UkSz0Y6Z6cBfMzTm5ahCCtH06hCFGhBrR
 pgna4AEL5vG0jcDZSBkXUgxlIrp1garNsuAjvHPsCUkxK7w2JgkINFIjVvKzOENkikw9vUpWZ
 FpmQqoyrsigEAnxVM29ZvwSo6O+VXdkC8W5U57u/FCoAwmaqoFzjRIWFw4

Add two new dedicated fields to provide the ICMPv6 code and type. While
libnetfilter_conntrack uses the same attribute for both ICMPv4 and v6,
there are no version-agnostic ICMP IEs in IPFIX.

The fields are annotated with the appropriate IPFIX metadata, which is
currently not actually used anywhere. You may call it consistency,
future-proofing or cargo-culting.

Signed-off-by: Corubba Smith <corubba@gmx.de>
=2D--
 input/flow/ulogd_inpflow_NFCT.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/input/flow/ulogd_inpflow_NFCT.c b/input/flow/ulogd_inpflow_NF=
CT.c
index 5ac24e5..a4a8f15 100644
=2D-- a/input/flow/ulogd_inpflow_NFCT.c
+++ b/input/flow/ulogd_inpflow_NFCT.c
@@ -181,6 +181,8 @@ enum nfct_keys {
 	NFCT_REPLY_RAW_PKTCOUNT,
 	NFCT_ICMP_CODE,
 	NFCT_ICMP_TYPE,
+	NFCT_ICMPV6_CODE,
+	NFCT_ICMPV6_TYPE,
 	NFCT_CT_MARK,
 	NFCT_CT_ID,
 	NFCT_CT_EVENT,
@@ -342,6 +344,24 @@ static struct ulogd_key nfct_okeys[] =3D {
 			.field_id	=3D IPFIX_icmpTypeIPv4,
 		},
 	},
+	{
+		.type	=3D ULOGD_RET_UINT8,
+		.flags	=3D ULOGD_RETF_NONE,
+		.name	=3D "icmpv6.code",
+		.ipfix	=3D {
+			.vendor		=3D IPFIX_VENDOR_IETF,
+			.field_id	=3D IPFIX_icmpCodeIPv6,
+		},
+	},
+	{
+		.type	=3D ULOGD_RET_UINT8,
+		.flags	=3D ULOGD_RETF_NONE,
+		.name	=3D "icmpv6.type",
+		.ipfix	=3D {
+			.vendor		=3D IPFIX_VENDOR_IETF,
+			.field_id	=3D IPFIX_icmpTypeIPv6,
+		},
+	},
 	{
 		.type	=3D ULOGD_RET_UINT32,
 		.flags	=3D ULOGD_RETF_NONE,
@@ -547,6 +567,12 @@ static int propagate_ct(struct ulogd_pluginstance *ma=
in_upi,
 		okey_set_u16(&ret[NFCT_ICMP_TYPE],
 			     nfct_get_attr_u8(ct, ATTR_ICMP_TYPE));
 		break;
+	case IPPROTO_ICMPV6:
+		okey_set_u16(&ret[NFCT_ICMPV6_CODE],
+			     nfct_get_attr_u8(ct, ATTR_ICMP_CODE));
+		okey_set_u16(&ret[NFCT_ICMPV6_TYPE],
+			     nfct_get_attr_u8(ct, ATTR_ICMP_TYPE));
+		break;
 	}

 	switch (nfct_get_attr_u8(ct, ATTR_REPL_L4PROTO)) {
=2D-
2.48.1

