Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76A01C433FE
	for <netfilter-devel@archiver.kernel.org>; Thu, 10 Nov 2022 18:28:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231938AbiKJS26 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 10 Nov 2022 13:28:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231794AbiKJS25 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 10 Nov 2022 13:28:57 -0500
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83E161CF
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Nov 2022 10:28:56 -0800 (PST)
Received: by mail-qt1-x833.google.com with SMTP id jr19so1420571qtb.7
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Nov 2022 10:28:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=foxtrot-research-com.20210112.gappssmtp.com; s=20210112;
        h=content-language:thread-index:mime-version:message-id:date:subject
         :in-reply-to:references:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vOC9HClltuoxUAT9BxBEI2PFm9E2yePNHpqSFWZ6etI=;
        b=ATVcfNb44oqVzkTbLZLPJy711LQRiWAD+/WKN1hlt5cUHe2sTcnz2alNswNKZBETGl
         /QBkoAALRjj/BM+ypRyjyUGMd/f/to87ALgJnRbZ7Xg3KbgwwYDlEvEglpKpIDBf8jjI
         fjpRwz+D/LQgE4Zj+pbO6AaXcCFCJ+mVyhWzLWxcYNthKcwT2YIPsWKsOEy1WDZnRHOb
         LDPH8ibVmDN6HcOE6m/Z8x8Keaei/Y3FcDB2/6YK6t+/lC8QwXlHYVd+z7vbZKL/k2EL
         l63LqhqbtD3X2gXk9QFWrUtDn9jHml1eu5UCL7pk5sCx5pXaSI+RD9BleBRlBYF3btsI
         W+yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-language:thread-index:mime-version:message-id:date:subject
         :in-reply-to:references:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vOC9HClltuoxUAT9BxBEI2PFm9E2yePNHpqSFWZ6etI=;
        b=aAgeh6UBxzKXcG14JyMQd+q95CPMsRhaS8tiRl6UWPFBQlNSJfdsYV0Y2aKQGW9fFn
         FrvjAAXK0kpiXxZ6s6YjGhjl/HP/mOOWZfhrstQB2Vv4PthRz1kqyidhq0PxLRHXr1ac
         RowYjN12sNF+ikgAQfRvsc21iCIz1Y2D0vd6iYPelGl0JarFviElpxoleeFFXdgBJFhp
         m3ObWBDt06cBkOM5QtCf/HVZqNmrg9YobkVFJocFnmwuOXvbIHcNj3Sqagkq61kD9jog
         LCGmpPcHYs9RK4LSPdLntYJKV7P6XI8yQPqWKMl5tLOKiAxbQhxfFH54OYwGQP14J4/c
         g7gg==
X-Gm-Message-State: ACrzQf21QtGhly17qLeeh6CUbFIeJPPCiuT3MjK9WvHk6uTUsN1gpV0o
        rSOBdRMfOSloPB5b1VRgf0N8D6DT9oWDuQ==
X-Google-Smtp-Source: AMsMyM53S/fRC5T3n5WdTdx9ExDNSuopSVLb4Q7bDUNiP9kcpF62xLX/iN6tM1IihJ2zK749rIhEpw==
X-Received: by 2002:a05:622a:1056:b0:3a5:7ba9:704f with SMTP id f22-20020a05622a105600b003a57ba9704fmr1255863qte.331.1668104934974;
        Thu, 10 Nov 2022 10:28:54 -0800 (PST)
Received: from robrienlt (static-47-206-165-165.tamp.fl.frontiernet.net. [47.206.165.165])
        by smtp.gmail.com with ESMTPSA id a9-20020ac85b89000000b003a54a19c550sm11822461qta.57.2022.11.10.10.28.53
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Nov 2022 10:28:54 -0800 (PST)
From:   "Robert O'Brien" <robrien@foxtrot-research.com>
To:     <netfilter-devel@vger.kernel.org>
References: <004301d8f531$bb2c60c0$31852240$@foxtrot-research.com>
In-Reply-To: <004301d8f531$bb2c60c0$31852240$@foxtrot-research.com>
Subject: RE: PATCH ulogd2 filter BASE ARP packet IP addresses
Date:   Thu, 10 Nov 2022 13:28:53 -0500
Message-ID: <005601d8f532$49cd7080$dd685180$@foxtrot-research.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;
        boundary="----=_NextPart_000_0057_01D8F508.60F7DDB0"
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQIqBV8VmspvNYO5UtuFnxy3osxCha2WWb+g
Content-Language: en-us
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is a multipart message in MIME format.

------=_NextPart_000_0057_01D8F508.60F7DDB0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit

I am developing for an embedded target and just recently deployed
libnetfilter and ulogd2 for logging packets which are rejected by rules in
ebtables. While performing this effort I discovered a bug which generates
incorrect values in the arp.saddr and arp.daddr fields in the OPRINT and
GPRINT outputs. I created a patch to resolve this issue in my deployment and
I believe it is a candidate for integration into the repository. The files
that this patch modifies have not changed in many years so I'm thinking that
the bug appeared due to changes in another codebase but I'm not sure. Please
review and provide feedback.

P.S. I could not find a way to submit a patch via Patchwork so I am writing
this email and attaching the patch. If there is a better way to submit a
patch, please tell me and I will re-submit it that way.

Robert O'Brien
Foxtrot Research
6201 Johns Road, Suite 3
Tampa, FL 33634
mailto:robrien@foxtrot-research.com - 813-501-7961


------=_NextPart_000_0057_01D8F508.60F7DDB0
Content-Type: application/octet-stream;
	name="0002-filter-BASE-Fixed-IP-addresses-in-ARP-packets.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0002-filter-BASE-Fixed-IP-addresses-in-ARP-packets.patch"

From b9820800820dcefadf912f16c009e506a87a91dd Mon Sep 17 00:00:00 2001=0A=
From: Robert O'Brien <robrien@foxtrot-research.com>=0A=
Date: Thu, 10 Nov 2022 10:53:52 -0500=0A=
Subject: [PATCH] filter: BASE: Fixed IP addresses in ARP packets=0A=
=0A=
I noticed that the source and target IP addresses in the ARP header that=0A=
were printed by the GPRINT plugin were incorrect. I traced this down to=0A=
a type mismatch between the KEY_ARP_SPA and KEY_ARP_TPA keys (names=0A=
arp.saddr and arp.daddr) in ulogd_raw2packet_BASE.c:_interp_arp()=0A=
function and the ULOGD_RET_IPADDR key type. The _interp_arp function in=0A=
the BASE filter plugin was storing the ARP header IP addresses as a=0A=
pointer but all the plugins which use this key expect a u32 value.=0A=
=0A=
I updated the _interp_arp() function to store the value using the=0A=
okey_set_u32() macro instead of *_ptr() and changed the cast to handle=0A=
the u8[] type that the value is stored as in struct=0A=
ether_arp.arp_spa/tpa. I have a feeling that at one point the type in=0A=
struct ether_arp.arp_spa/tpa changed from a u32 to a u8[] but I couldn't=0A=
find a commit to prove this.=0A=
=0A=
I also updated the output plugin OPRINT as it was interpreting this=0A=
value in little endian when it should be big endian/network order.=0A=
---=0A=
 filter/raw2packet/ulogd_raw2packet_BASE.c | 4 ++--=0A=
 output/ulogd_output_OPRINT.c              | 2 +-=0A=
 2 files changed, 3 insertions(+), 3 deletions(-)=0A=
=0A=
diff --git a/filter/raw2packet/ulogd_raw2packet_BASE.c =
b/filter/raw2packet/ulogd_raw2packet_BASE.c=0A=
index 9117d27..9210131 100644=0A=
--- a/filter/raw2packet/ulogd_raw2packet_BASE.c=0A=
+++ b/filter/raw2packet/ulogd_raw2packet_BASE.c=0A=
@@ -905,9 +905,9 @@ static int _interp_arp(struct ulogd_pluginstance =
*pi, uint32_t len)=0A=
 	okey_set_u16(&ret[KEY_ARP_OPCODE], ntohs(arph->arp_op));=0A=
 =0A=
 	okey_set_ptr(&ret[KEY_ARP_SHA], (void *)&arph->arp_sha);=0A=
-	okey_set_ptr(&ret[KEY_ARP_SPA], (void *)&arph->arp_spa);=0A=
+	okey_set_u32(&ret[KEY_ARP_SPA], *(uint32_t *)arph->arp_spa);=0A=
 	okey_set_ptr(&ret[KEY_ARP_THA], (void *)&arph->arp_tha);=0A=
-	okey_set_ptr(&ret[KEY_ARP_TPA], (void *)&arph->arp_tpa);=0A=
+	okey_set_u32(&ret[KEY_ARP_TPA], *(uint32_t *)arph->arp_tpa);=0A=
 =0A=
 	return ULOGD_IRET_OK;=0A=
 }=0A=
diff --git a/output/ulogd_output_OPRINT.c b/output/ulogd_output_OPRINT.c=0A=
index 6fde445..4850a76 100644=0A=
--- a/output/ulogd_output_OPRINT.c=0A=
+++ b/output/ulogd_output_OPRINT.c=0A=
@@ -85,7 +85,7 @@ static int oprint_interp(struct ulogd_pluginstance =
*upi)=0A=
 				break;=0A=
 			case ULOGD_RET_IPADDR:=0A=
 				fprintf(opi->of, "%u.%u.%u.%u\n", =0A=
-					HIPQUAD(ret->u.value.ui32));=0A=
+					NIPQUAD(ret->u.value.ui32));=0A=
 				break;=0A=
 			case ULOGD_RET_NONE:=0A=
 				fprintf(opi->of, "<none>\n");=0A=
-- =0A=
2.25.1=0A=
=0A=

------=_NextPart_000_0057_01D8F508.60F7DDB0--

