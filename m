Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DC85C7EE2A
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 May 2023 12:56:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229873AbjECM41 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 May 2023 08:56:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbjECM40 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 May 2023 08:56:26 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5689F5262
        for <netfilter-devel@vger.kernel.org>; Wed,  3 May 2023 05:56:25 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id 5b1f17b1804b1-3f315712406so23292855e9.0
        for <netfilter-devel@vger.kernel.org>; Wed, 03 May 2023 05:56:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1683118583; x=1685710583;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=rzjoUJhi+nnA7NqLX07yjrMCST2tejGie4BUAIUiDk0=;
        b=LaAGoJUASGcfelzKkwlxd4FAztNyOkAEDQGCt/PyTPGDAB+st1JyGGEyZzrzwyjvGl
         i20VxPMpJkkzzGZnmvPXg+tN8SYuI0va+ZOUTN29FQd5kKjzTtqm/vM1JAVGeLtCaQcB
         SXGWSg2UkFc8YQTdqRnF83RvAdtIU4cYHrXHM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683118583; x=1685710583;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rzjoUJhi+nnA7NqLX07yjrMCST2tejGie4BUAIUiDk0=;
        b=Psn5YEoHG8JKRfZZOoXem0xQShX+AdMKoDn2OsmIyefxpxlnbMzG+C2X7g4RufXm58
         kmfVSYiJBaroZoGYAYwFGno/kqzPmQGMSROASi3eiFJZ1SlXonH6NQV+3dgjsNLQAaou
         teC+tiTCiqewwETGTFOA4YkSWYs1PU+8686gyithwSmupfksBEIZB4Id9b5ZbJvISYXC
         G5PdfaDzFG1V/AgfK6F9VXaCMjXThUC3lkkpuBixRkvBp4gyT3+BYyRbvbBw3Yr/a3c4
         7H708yF5/jmZ4Pxj7y0salzMWkzfcZG7UsXcF67JcCwE296YASGeN9w+B+giS2juDblz
         t0rg==
X-Gm-Message-State: AC+VfDyYG6CW7gthZlZOvs1At/mM72jcTP9QVeshHILUwymcUvkJ0yp2
        i93Ir6RIP3XwGCF/FcFpY6VoITqKP1i58hMkDsWpp2gE6TMyyf3XusIZmO8eY0ymJBvS532tGPB
        pwlhscaCWenna2JKiYcxYtZu5bb1lNiRxB8/WxQIHTKD7PdnN5zXSS4j7j3cE765+vjdzypzoTn
        4bur+Xh0IGqQEQ3mGpX1AL7Q==
X-Google-Smtp-Source: ACHHUZ4pPrTWYi8w5dQmfIub32aM4q+vzpW5F93PLWu8Ch6uCbQvMzRUbYPBQeGTXkXVHEM0ib+Vmg==
X-Received: by 2002:a05:600c:3112:b0:3f1:939e:2e3b with SMTP id g18-20020a05600c311200b003f1939e2e3bmr1456590wmo.19.1683118583429;
        Wed, 03 May 2023 05:56:23 -0700 (PDT)
Received: from localhost.localdomain ([192.19.250.250])
        by smtp.gmail.com with ESMTPSA id u6-20020a05600c00c600b003ee1b2ab9a0sm1855396wmm.11.2023.05.03.05.56.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 May 2023 05:56:23 -0700 (PDT)
From:   Boris Sukholitko <boris.sukholitko@broadcom.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Ilya Lifshits <ilya.lifshits@broadcom.com>,
        Boris Sukholitko <boris.sukholitko@broadcom.com>
Subject: [PATCH nf-next 06/19] netfilter: nft_payload: publish nft_payload_set
Date:   Wed,  3 May 2023 15:55:39 +0300
Message-Id: <20230503125552.41113-7-boris.sukholitko@broadcom.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20230503125552.41113-1-boris.sukholitko@broadcom.com>
References: <20230503125552.41113-1-boris.sukholitko@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000004d1da305fac9955a"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

--0000000000004d1da305fac9955a
Content-Transfer-Encoding: 8bit

Move struct nft_payload_set into nf_tables.h.

In conjunction with nft_payload_mangle function we can apply the
payload changes independent of nft_expr context.

Signed-off-by: Boris Sukholitko <boris.sukholitko@broadcom.com>
---
 include/net/netfilter/nf_tables.h | 10 ++++++++++
 net/netfilter/nft_payload.c       | 10 ----------
 2 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 1b8e305bb54a..b027200caf5b 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -863,6 +863,16 @@ static inline void nft_set_gc_batch_add(struct nft_set_gc_batch *gcb,
 	gcb->elems[gcb->head.cnt++] = elem;
 }
 
+struct nft_payload_set {
+	enum nft_payload_bases	base:8;
+	u8			offset;
+	u8			len;
+	u8			sreg;
+	u8			csum_type;
+	u8			csum_offset;
+	u8			csum_flags;
+};
+
 struct nft_expr_ops;
 /**
  *	struct nft_expr_type - nf_tables expression type
diff --git a/net/netfilter/nft_payload.c b/net/netfilter/nft_payload.c
index 2a41e7e0b3b7..ed4a65ac68d5 100644
--- a/net/netfilter/nft_payload.c
+++ b/net/netfilter/nft_payload.c
@@ -788,16 +788,6 @@ static int nft_payload_csum_inet(struct sk_buff *skb, const u32 *src,
 	return 0;
 }
 
-struct nft_payload_set {
-	enum nft_payload_bases	base:8;
-	u8			offset;
-	u8			len;
-	u8			sreg;
-	u8			csum_type;
-	u8			csum_offset;
-	u8			csum_flags;
-};
-
 static int nft_payload_mangle(const struct nft_payload_set *priv,
 			      const struct nft_pktinfo *pkt,
 			      const u32 *src)
-- 
2.32.0


--0000000000004d1da305fac9955a
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
ydoyIjshhiv/IkUwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIFa3Y6FaByHWXK63
3yG81OFHPl/TKpBvCiIZZ7KWvMMwMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcN
AQkFMQ8XDTIzMDUwMzEyNTYyM1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZI
AWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEH
MAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQDFE112RkSWoy9+87yQjWv+ZnN3Niq9wCLv
CbMhLBoIF3bQaY7dVT3pfCAX970vOspAVZWy0+9ui+7euMeNU6oiOTLyQ9SCjmhKG1twJhaMEuO8
PWTTsXmgxmGi+81Lf8Z2AKXx5he8K1T+eHB7yUBpZ6mQ5X3n8TvVsr2yuDxuWF3t7I7LdIIBsbhm
AWih/CQJzKezxPPB6cnzEeZfXs2Db8EectMb+3kpz1/4zoXlCQ4fS9ITgfaFyEf23OdbdrMGwmt3
nO+/ED5mHZobyyHOu88N9JQlNiTHq3eylerUEbo3NAHOIoyQld/ODcz2OSxq0jacB/cNIh7anij5
bHzo
--0000000000004d1da305fac9955a--
