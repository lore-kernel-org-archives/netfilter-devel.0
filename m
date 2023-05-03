Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69B40C7EE23
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 May 2023 12:56:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbjECM4i (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 May 2023 08:56:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbjECM4h (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 May 2023 08:56:37 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C170C5B8E
        for <netfilter-devel@vger.kernel.org>; Wed,  3 May 2023 05:56:35 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id 5b1f17b1804b1-3f19afc4fd8so31698475e9.2
        for <netfilter-devel@vger.kernel.org>; Wed, 03 May 2023 05:56:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1683118594; x=1685710594;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=xgKnXcaU15/AONOdPjcr4MbmPIhWn2/bRhQake1s5aY=;
        b=EqcfztSsM1zn/jyhnHEtT21PcIcORSj8HFgug2/vn0lOKMsktRIFLg8HtZQro1bwdb
         1i9esBaGBJwUoCxjovRZwWh4suTTxfZc2HjMLsLGHtcr6vixt4Y5ni0IQOUpbgsY0b/V
         aMvydz3n3lD68FMP6oCFog/09cmtcSGt/SR+k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683118594; x=1685710594;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xgKnXcaU15/AONOdPjcr4MbmPIhWn2/bRhQake1s5aY=;
        b=Egs+sDWqc/lgwVz2/wfy7oQ6uworCZ9TKtbj4uObZZhyzQErmcYFTDQWjYAvq1TTRc
         f/XAp7VBj86ESp5PXB/+lriMj4Qmi+SNmUU/Bfn0/ZmV+ZR6D+5EpTtfCCrHxkxYo5Tn
         HgUF4F615zNTUj0fd/2/5WhZAN7Os/InAnLNuFuBJadkU00LBs9y6gaPPfoKXvqyuAAw
         UF6bJw19Gv0YkNxjx24GJ0O+5/dtgccvY/FNfiAFDjncR+iENWq2oRxAlVUCbsYs4TqP
         H7xF+5p42/gocInPjyQbw09rHAuj91UgqrvPsWZQ0njfJs3gbdq/uI3USYu+FRAZwdQO
         hXZw==
X-Gm-Message-State: AC+VfDwhULSljda+zgoiKGNpzUF19cNjGNGye6dNHW7isRiG7hDPhXFR
        6OnockR60icqspsX735JBvphL1AgG3frs0yNV93jwZeKC6dZYg3d6Bb+19qYBLBlAKNjCl82/xU
        n40VEey767repgtdHHrJ89cT033OxaGn3d2M8BTnCX5tejlXxnkA9jAWOwjYo4On7mDsFIY6mAu
        okx4AKIyuzPf+SRQ2P0RwR/w==
X-Google-Smtp-Source: ACHHUZ7LvUJoVsJU2ZaAmPnk7zF7ek7uhYTtPKuSAPXBvW0bpvtEOfXvVXrUf6SB7Ck/YZ0nRfs6Kg==
X-Received: by 2002:a7b:c7d4:0:b0:3f1:8a5f:a6eb with SMTP id z20-20020a7bc7d4000000b003f18a5fa6ebmr14978579wmk.34.1683118593754;
        Wed, 03 May 2023 05:56:33 -0700 (PDT)
Received: from localhost.localdomain ([192.19.250.250])
        by smtp.gmail.com with ESMTPSA id u6-20020a05600c00c600b003ee1b2ab9a0sm1855396wmm.11.2023.05.03.05.56.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 May 2023 05:56:33 -0700 (PDT)
From:   Boris Sukholitko <boris.sukholitko@broadcom.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Ilya Lifshits <ilya.lifshits@broadcom.com>,
        Boris Sukholitko <boris.sukholitko@broadcom.com>
Subject: [PATCH nf-next 15/19] netfilter: nft: add payload application
Date:   Wed,  3 May 2023 15:55:48 +0300
Message-Id: <20230503125552.41113-16-boris.sukholitko@broadcom.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20230503125552.41113-1-boris.sukholitko@broadcom.com>
References: <20230503125552.41113-1-boris.sukholitko@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000ec368305fac99513"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

--000000000000ec368305fac99513
Content-Transfer-Encoding: 8bit

nf_flow_offload_apply_payload function is defined in the new
nft_conntrack_ext.c file. It applies payload changes using
nft_payload_mangle helper.

Signed-off-by: Boris Sukholitko <boris.sukholitko@broadcom.com>
---
 include/net/netfilter/nf_tables.h | 13 +++++++++++++
 net/netfilter/Makefile            |  2 ++
 net/netfilter/nft_conntrack_ext.c | 26 ++++++++++++++++++++++++++
 3 files changed, 41 insertions(+)
 create mode 100644 net/netfilter/nft_conntrack_ext.c

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index ffcbe25d6bd2..48357db14602 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1757,10 +1757,23 @@ static inline void nfct_nft_ext_add(struct nf_conn *ct)
 	if (ext)
 		memset(ext, 0, sizeof(*ext));
 }
+
+int nf_flow_offload_apply_payload(struct sk_buff *skb,
+				  struct nf_conn *ct,
+				  enum ip_conntrack_dir dir,
+				  unsigned int thoff);
 #else
 static inline void nfct_nft_ext_add(struct nf_conn *ct)
 {
 }
+
+static inline int nf_flow_offload_apply_payload(struct sk_buff *skb,
+						struct nf_conn *ct,
+						enum ip_conntrack_dir dir,
+						unsigned int thoff)
+{
+	return 0;
+}
 #endif
 
 #endif /* _NET_NF_TABLES_H */
diff --git a/net/netfilter/Makefile b/net/netfilter/Makefile
index d4958e7e7631..c28bf8eaa759 100644
--- a/net/netfilter/Makefile
+++ b/net/netfilter/Makefile
@@ -135,6 +135,8 @@ obj-$(CONFIG_NFT_SYNPROXY)	+= nft_synproxy.o
 
 obj-$(CONFIG_NFT_NAT)		+= nft_chain_nat.o
 
+obj-$(CONFIG_NFT_CONNTRACK_EXT)	+= nft_conntrack_ext.o
+
 # nf_tables netdev
 obj-$(CONFIG_NFT_DUP_NETDEV)	+= nft_dup_netdev.o
 obj-$(CONFIG_NFT_FWD_NETDEV)	+= nft_fwd_netdev.o
diff --git a/net/netfilter/nft_conntrack_ext.c b/net/netfilter/nft_conntrack_ext.c
new file mode 100644
index 000000000000..0dabd2a84422
--- /dev/null
+++ b/net/netfilter/nft_conntrack_ext.c
@@ -0,0 +1,26 @@
+// SPDX-License-Identifier: GPL-2.0
+#include <net/netfilter/nf_tables.h>
+
+int nf_flow_offload_apply_payload(struct sk_buff *skb,
+				  struct nf_conn *ct,
+				  enum ip_conntrack_dir dir,
+				  unsigned int thoff)
+{
+	struct nf_conn_nft_ext_entry *en;
+	struct nf_conn_nft_ext *ncft;
+	struct nft_pktinfo pkt;
+
+	ncft = nf_ct_ext_find(ct, NF_CT_EXT_NFT_EXT);
+	if (!ncft)
+		return 0;
+
+	en = &ncft->nfte_entries[dir];
+	if (en->nfte_type != NFT_EXT_PAYLOAD_SET)
+		return 0;
+
+	memset(&pkt, 0, sizeof(pkt));
+	pkt.skb = skb;
+	pkt.thoff = thoff;
+	return nft_payload_mangle(&en->nfte_payload, &pkt, &en->nfte_data);
+}
+EXPORT_SYMBOL_GPL(nf_flow_offload_apply_payload);
-- 
2.32.0


--000000000000ec368305fac99513
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

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
riBJ/K1AFUjRAjFhGV64l++td7dkmnq/X8ET75ti+w1s4FRpFqkD2m7pg5NxdsZphYIXAgMBAAGj
QjBAMA4GA1UdDwEB/wQEAwIBBjAPBgNVHRMBAf8EBTADAQH/MB0GA1UdDgQWBBSP8Et/qC5FJK5N
UPpjmove4t0bvDANBgkqhkiG9w0BAQsFAAOCAQEAS0DbwFCq/sgM7/eWVEVJu5YACUGssxOGhigH
M8pr5nS5ugAtrqQK0/Xx8Q+Kv3NnSoPHRHt44K9ubG8DKY4zOUXDjuS5V2yq/BKW7FPGLeQkbLmU
Y/vcU2hnVj6DuM81IcPJaP7O2sJTqsyQiunwXUaMld16WCgaLx3ezQA3QY/tRG3XUyiXfvNnBB4V
14qWtNPeTCekTBtzc3b0F5nCH3oO4y0IrQocLP88q1UOD5F+NuvDV0m+4S4tfGCLw0FREyOdzvcy
a5QBqJnnLDMfOjsl0oZAzjsshnjJYS8Uuu7bVW/fhO4FCU29KNhyztNiUGUe65KXgzHZs7XKR1g/
XzCCBVgwggRAoAMCAQICDADJ2jIiOyGGK/8iRTANBgkqhkiG9w0BAQsFADBbMQswCQYDVQQGEwJC
RTEZMBcGA1UEChMQR2xvYmFsU2lnbiBudi1zYTExMC8GA1UEAxMoR2xvYmFsU2lnbiBHQ0MgUjMg
UGVyc29uYWxTaWduIDIgQ0EgMjAyMDAeFw0yMjA5MTAxMTU2MDBaFw0yNTA5MTAxMTU2MDBaMIGW
MQswCQYDVQQGEwJJTjESMBAGA1UECBMJS2FybmF0YWthMRIwEAYDVQQHEwlCYW5nYWxvcmUxFjAU
BgNVBAoTDUJyb2FkY29tIEluYy4xGTAXBgNVBAMTEEJvcmlzIFN1a2hvbGl0a28xLDAqBgkqhkiG
9w0BCQEWHWJvcmlzLnN1a2hvbGl0a29AYnJvYWRjb20uY29tMIIBIjANBgkqhkiG9w0BAQEFAAOC
AQ8AMIIBCgKCAQEA1uKd0fo+YWpPYs389dpHW5vbrVQvwiWI4VGPHISUMVVVcCwrVXMcmoEi1AMN
t+KhIYltFzX7vj+SjHzSWLGrXUX/DW2tDJRYRXdc8+lVAu1wBO4WIhcYCMY8BDPfpxkMoY4w/qIa
1rC9tzBPzIGAdrBfdEzjjqblnqi+sIG7bakS6h7njOPNf9HuyLSQOs+Qq3kK8A8pX6t6KtAdq4iP
td/fua/xzT9yf7xQ0v0AVUPd9O3rahX4kX4sHlUcEVb6eXSNRwdyirUgDaJkDPrhIPKFapov5OeK
9BR0SGqf9JnBbAcQrigtBfEwkeDY+dJprju7HLWVNFkaW9u8vvvbiwIDAQABo4IB3jCCAdowDgYD
VR0PAQH/BAQDAgWgMIGjBggrBgEFBQcBAQSBljCBkzBOBggrBgEFBQcwAoZCaHR0cDovL3NlY3Vy
ZS5nbG9iYWxzaWduLmNvbS9jYWNlcnQvZ3NnY2NyM3BlcnNvbmFsc2lnbjJjYTIwMjAuY3J0MEEG
CCsGAQUFBzABhjVodHRwOi8vb2NzcC5nbG9iYWxzaWduLmNvbS9nc2djY3IzcGVyc29uYWxzaWdu
MmNhMjAyMDBNBgNVHSAERjBEMEIGCisGAQQBoDIBKAowNDAyBggrBgEFBQcCARYmaHR0cHM6Ly93
d3cuZ2xvYmFsc2lnbi5jb20vcmVwb3NpdG9yeS8wCQYDVR0TBAIwADBJBgNVHR8EQjBAMD6gPKA6
hjhodHRwOi8vY3JsLmdsb2JhbHNpZ24uY29tL2dzZ2NjcjNwZXJzb25hbHNpZ24yY2EyMDIwLmNy
bDAoBgNVHREEITAfgR1ib3Jpcy5zdWtob2xpdGtvQGJyb2FkY29tLmNvbTATBgNVHSUEDDAKBggr
BgEFBQcDBDAfBgNVHSMEGDAWgBSWM9HmWBdbNHWKgVZk1b5I3qGPzzAdBgNVHQ4EFgQUB46dIlYd
tkC0osZXFEatb5Hu+C8wDQYJKoZIhvcNAQELBQADggEBAE/WXEAo/TOHDort0zhfb2Vu7BdK2MHO
7LVlNc5DtQqFW4S0EA+f5oxpwsTHSzqf5FVY3S3TeMGTGssz2y/nGWwznbP+ti0SmO13EYKODFao
6fOqaW6dPraTx2lXgvMYXn/VZ+bxpnyKcFwC4qVssadK6ezPvrCVszHmO7MNvpH2vsfE5ulVdzbU
zPffqO2QS6e4oXzmoYuX9sCNfol1TaQgCYgYoC4rexOBLLtYbwdKWi3/ttntZ2PHS1QRaDzrBSuw
L39zqstTC0LC/YoSKC/cU9igMELugG/Twy9uVlg2XXTY1wUYSWMsYlpydsrVyG18UScp7FlGFbWX
EWKS7pkxggJtMIICaQIBATBrMFsxCzAJBgNVBAYTAkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52
LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBSMyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwAgwA
ydoyIjshhiv/IkUwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIGDAzvZbLYwiLT2m
mnEGpJ53RtgkbWVeuMN2x0tmoCOUMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcN
AQkFMQ8XDTIzMDUwMzEyNTYzNFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZI
AWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEH
MAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQDRlo3GLDWu1pACi01ZGuyofZ9IIT6bK5DJ
rVJTVC7orBESeRKiICc57Td7NU+sSs90x2P+P9tn14o/u7JfG77ceKJvuoXR6roInZcYtZ5H0/QH
yyA6QDjgzaFQRGfNNxKQJPZJ9xfjb2mdjchFnkNftd2NjMHsj9NYmZFuRe36z8GM8YyW5jRfWHVd
PfugaJIkAgcLA3X39mH5T7nXR9CZFV6KBBLJgjEdslT8GIRoY73QEGJNCB+81YGlwa+TPHWfTbwb
VqotwsKe0dfSsDzDyOjJyw6led+WjQvxd7mMGiocIZ+xdk7wCOsqeLy8Z6t6+zklKMbPtjZtInHl
vjbj
--000000000000ec368305fac99513--
