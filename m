Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8178AC77B75
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 May 2023 12:56:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbjECM4g (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 May 2023 08:56:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229948AbjECM4f (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 May 2023 08:56:35 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 726AC5592
        for <netfilter-devel@vger.kernel.org>; Wed,  3 May 2023 05:56:34 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 5b1f17b1804b1-3f173af665fso32874315e9.3
        for <netfilter-devel@vger.kernel.org>; Wed, 03 May 2023 05:56:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1683118592; x=1685710592;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=qIPweZyacKl9Ow62SZMFal8zTN9i58UlD4ks8f0xQ/A=;
        b=G+0cewOeDEzxj5wB6eL6XAPf7gvjYJq9VsJAX17CTxxg2TRGlEzwiDuD8HdSPR6XCl
         uCsfvcu0PECLk7uZYU1G1aDHMnllxoigUOi0f2KpaMLY0ea/PfsKmB51+nMyvhWcmZg4
         yqyX8DeUraYD0qRwk72ZJfuIqlIoGwseCeUfM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683118592; x=1685710592;
        h=mime-version:references:in-reply-to:message-id:date:subject:cc:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qIPweZyacKl9Ow62SZMFal8zTN9i58UlD4ks8f0xQ/A=;
        b=WFxWEPWl1jomZ3XWDlNA6tYVAatimOqblyJQat9d5eKh/dvaJJvO2ckFOTuU5p4szy
         /x/BFdsqBJDpWebbnp8bIESpeXOmgb0Si7WuCAsBfiBUc4U+X0xTTlrYf25rEnblFEXV
         hKrDyvpRt+ilOda126OK52oety/P4+Ui46E097LpA+gSP7xVHt4RO/aZS/+mkXYpmmQn
         7RjOK4w9diYess9ijmLuA3Td9tCgvGIlzr/kr3VROMDUeuTK9oONKG9cgI3YxFre7/c9
         yg5xFQBVxOQyaqA0VgOON6ohpmbv/cjiZiuyPOpxO+8nLL4vRrq38pcG7Y24T8EQuzWg
         gBfA==
X-Gm-Message-State: AC+VfDz3W3d0B8JOTmroW2t/sfgukHqUN1dQ43BQBOmwdWXmsbnuDo0z
        DKrw9FJnL6H2HIfvdyuoRpP1HEcrcesmce/5JBKZasn9Oid315PCT8cSR++Tl9Kdn/gFQY7RQJ+
        nziZ7JnfZ2xheiwJh0gKbjh8Om3vj7fmNthUWY2gMsv7msUFZZbbwtByjqNuNVVQrSANZ05Z/4e
        Sv02jgpZwDnrdhtlNMjiVfUw==
X-Google-Smtp-Source: ACHHUZ4BXS9V/NfNqTlhDdQyMXunXubIuI0dIWjAG8GWe4DNVkuAWg5+9dHOb/XI2iXxanlORpUJTQ==
X-Received: by 2002:a05:600c:2198:b0:3ee:4ff0:83d6 with SMTP id e24-20020a05600c219800b003ee4ff083d6mr13785323wme.40.1683118592646;
        Wed, 03 May 2023 05:56:32 -0700 (PDT)
Received: from localhost.localdomain ([192.19.250.250])
        by smtp.gmail.com with ESMTPSA id u6-20020a05600c00c600b003ee1b2ab9a0sm1855396wmm.11.2023.05.03.05.56.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 May 2023 05:56:32 -0700 (PDT)
From:   Boris Sukholitko <boris.sukholitko@broadcom.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Ilya Lifshits <ilya.lifshits@broadcom.com>,
        Boris Sukholitko <boris.sukholitko@broadcom.com>
Subject: [PATCH nf-next 14/19] netfilter: nft: add payload context into extension
Date:   Wed,  3 May 2023 15:55:47 +0300
Message-Id: <20230503125552.41113-15-boris.sukholitko@broadcom.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20230503125552.41113-1-boris.sukholitko@broadcom.com>
References: <20230503125552.41113-1-boris.sukholitko@broadcom.com>
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000d8601905fac9956f"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

--000000000000d8601905fac9956f
Content-Transfer-Encoding: 8bit

To apply the payload on both directions we need nft_payload_set struct
along with the source data.

There is also enum nft_ext_entry_type to signal the validity of the
context.

Signed-off-by: Boris Sukholitko <boris.sukholitko@broadcom.com>
---
 include/net/netfilter/nf_tables.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/net/netfilter/nf_tables.h b/include/net/netfilter/nf_tables.h
index 8f34571fe345..ffcbe25d6bd2 100644
--- a/include/net/netfilter/nf_tables.h
+++ b/include/net/netfilter/nf_tables.h
@@ -1735,7 +1735,19 @@ int nft_payload_mangle(const struct nft_payload_set *priv,
 		       const u32 *src);
 
 #if IS_ENABLED(CONFIG_NFT_CONNTRACK_EXT)
+enum nft_ext_entry_type {
+	NFT_EXT_UNDEFINED
+	, NFT_EXT_PAYLOAD_SET
+};
+
+struct nf_conn_nft_ext_entry {
+	enum nft_ext_entry_type nfte_type;
+	struct nft_payload_set nfte_payload;
+	u32 nfte_data;
+};
+
 struct nf_conn_nft_ext {
+	struct nf_conn_nft_ext_entry nfte_entries[IP_CT_DIR_MAX];
 };
 
 static inline void nfct_nft_ext_add(struct nf_conn *ct)
-- 
2.32.0


--000000000000d8601905fac9956f
Content-Type: application/pkcs7-signature; name="smime.p7s"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="smime.p7s"
Content-Description: S/MIME Cryptographic Signature

MIIQeQYJKoZIhvcNAQcCoIIQajCCEGYCAQExDzANBglghkgBZQMEAgEFADALBgkqhkiG9w0BBwGg
gg3QMIIFDTCCA/WgAwIBAgIQeEqpED+lv77edQixNJMdADANBgkqhkiG9w0BAQsFADBMMSAwHgYD
VQQLExdHbG9iYWxTaWduIFJvb3QgQ0EgLSBSMzETMBEGA1UEChMKR2xvYmFsU2lnbjETMBEGA1UE
AxMKR2xvYmFsU2lnbjAeFw0yMDA5MTYwMDAwMDBaFw0yODA5MTYwMDAwMDBaMFsxCzAJBgNVBAYT
AkJFMRkwFwYDVQQKExBHbG9iYWxTaWduIG52LXNhMTEwLwYDVQQDEyhHbG9iYWxTaWduIEdDQyBS
MyBQZXJzb25hbFNpZ24gMiBDQSAyMDIwMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEA
vbCmXCcsbZ/a0fRIQMBxp4gJnnyeneFYpEtNydrZZ+GeKSMdHiDgXD1UnRSIudKo+moQ6YlCOu4t
rVWO/EiXfYnK7zeop26ry1RpKtogB7/O115zultAz64ydQYLe+a1e/czkALg3sgTcOOcFZTXk38e
aqsXsipoX1vsNurqPtnC27TWsA7pk4uKXscFjkeUE8JZu9BDKaswZygxBOPBQBwrA5+20Wxlk6k1
e6EKaaNaNZUy30q3ArEf30ZDpXyfCtiXnupjSK8WU2cK4qsEtj09JS4+mhi0CTCrCnXAzum3tgcH
cHRg0prcSzzEUDQWoFxyuqwiwhHu3sPQNmFOMwIDAQABo4IB2jCCAdYwDgYDVR0PAQH/BAQDAgGG
MGAGA1UdJQRZMFcGCCsGAQUFBwMCBggrBgEFBQcDBAYKKwYBBAGCNxQCAgYKKwYBBAGCNwoDBAYJ
KwYBBAGCNxUGBgorBgEEAYI3CgMMBggrBgEFBQcDBwYIKwYBBQUHAxEwEgYDVR0TAQH/BAgwBgEB
/wIBADAdBgNVHQ4EFgQUljPR5lgXWzR1ioFWZNW+SN6hj88wHwYDVR0jBBgwFoAUj/BLf6guRSSu
TVD6Y5qL3uLdG7wwegYIKwYBBQUHAQEEbjBsMC0GCCsGAQUFBzABhiFodHRwOi8vb2NzcC5nbG9i
YWxzaWduLmNvbS9yb290cjMwOwYIKwYBBQUHMAKGL2h0dHA6Ly9zZWN1cmUuZ2xvYmFsc2lnbi5j
b20vY2FjZXJ0L3Jvb3QtcjMuY3J0MDYGA1UdHwQvMC0wK6ApoCeGJWh0dHA6Ly9jcmwuZ2xvYmFs
c2lnbi5jb20vcm9vdC1yMy5jcmwwWgYDVR0gBFMwUTALBgkrBgEEAaAyASgwQgYKKwYBBAGgMgEo
CjA0MDIGCCsGAQUFBwIBFiZodHRwczovL3d3dy5nbG9iYWxzaWduLmNvbS9yZXBvc2l0b3J5LzAN
BgkqhkiG9w0BAQsFAAOCAQEAdAXk/XCnDeAOd9nNEUvWPxblOQ/5o/q6OIeTYvoEvUUi2qHUOtbf
jBGdTptFsXXe4RgjVF9b6DuizgYfy+cILmvi5hfk3Iq8MAZsgtW+A/otQsJvK2wRatLE61RbzkX8
9/OXEZ1zT7t/q2RiJqzpvV8NChxIj+P7WTtepPm9AIj0Keue+gS2qvzAZAY34ZZeRHgA7g5O4TPJ
/oTd+4rgiU++wLDlcZYd/slFkaT3xg4qWDepEMjT4T1qFOQIL+ijUArYS4owpPg9NISTKa1qqKWJ
jFoyms0d0GwOniIIbBvhI2MJ7BSY9MYtWVT5jJO3tsVHwj4cp92CSFuGwunFMzCCA18wggJHoAMC
AQICCwQAAAAAASFYUwiiMA0GCSqGSIb3DQEBCwUAMEwxIDAeBgNVBAsTF0dsb2JhbFNpZ24gUm9v
dCBDQSAtIFIzMRMwEQYDVQQKEwpHbG9iYWxTaWduMRMwEQYDVQQDEwpHbG9iYWxTaWduMB4XDTA5
MDMxODEwMDAwMFoXDTI5MDMxODEwMDAwMFowTDEgMB4GA1UECxMXR2xvYmFsU2lnbiBSb290IENB
IC0gUjMxEzARBgNVBAoTCkdsb2JhbFNpZ24xEzARBgNVBAMTCkdsb2JhbFNpZ24wggEiMA0GCSqG
SIb3DQEBAQUAA4IBDwAwggEKAoIBAQDMJXaQeQZ4Ihb1wIO2hMoonv0FdhHFrYhy/EYCQ8eyip0E
XyTLLkvhYIJG4VKrDIFHcGzdZNHr9SyjD4I9DCuul9e2FIYQebs7E4B3jAjhSdJqYi8fXvqWaN+J
J5U4nwbXPsnLJlkNc96wyOkmDoMVxu9bi9IEYMpJpij2aTv2y8gokeWdimFXN6x0FNx04Druci8u
nPvQu7/1PQDhBjPogiuuU6Y6FnOM3UEOIDrAtKeh6bJPkC4yYOlXy7kEkmho5TgmYHWyn3f/kRTv
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
ydoyIjshhiv/IkUwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIPYh5Ht3mdxmI58C
cNALv7cTLpLGxgYudz0U/Evx1611MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcN
AQkFMQ8XDTIzMDUwMzEyNTYzMlowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZI
AWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEH
MAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCJixa8fiuLcWR1HC65f8hn4KuAuQgnBAk1
6/YuXZkwmc5sxVhCNaZtSAxkWxz7qcQW1l1ALec/0qdRN1iFNgBCrjEIUrtvrOe2oVMbLIxeWkhz
uf1VyT7fgIxQ7ZHNgyNzF2jYWfPo82uzb5FeqzIvO5S4IaaRj9N8EsHdnL/pj36TPg2bSQW6n1LG
3wZ+9WkBqvcqvAlzZ1aRGRJBDRgpbqe+la1fBTsheltBa9X9Za8q56Xj4KpTmzsvAx6Egnz+zuns
f/8XRsbEJJkOee3v9xE/PWXmE9wHDAqHd/faX+a2XZH3seO1rhAhXN2tREYlszjkrrFc+NVjdNq+
gCm1
--000000000000d8601905fac9956f--
