Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F55FC77B7C
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 May 2023 08:49:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbjEDItU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 4 May 2023 04:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230312AbjEDItL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 May 2023 04:49:11 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4308740EB
        for <netfilter-devel@vger.kernel.org>; Thu,  4 May 2023 01:48:54 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1aaf70676b6so1149685ad.3
        for <netfilter-devel@vger.kernel.org>; Thu, 04 May 2023 01:48:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1683190133; x=1685782133;
        h=mime-version:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=d7MG5csGudovN2K9j7+IrEpvGLaArE7Ff8eEY8XeQ5Y=;
        b=NY8f8ZPMa9j/AS3HcEJa5cYNcZDkCVXr8U7YeBYgxG6pKWDUu+UWy5xJogls2zRve5
         2HjwEV/VmgklbNyqvndOo7Eah3wwbpWiNvqDLIzP9Lq+iuckgXgdDO/XM+w8ps34I/d8
         G1otjQoCQC8cD/FnYAgWsSj+z1njt3/5f87/M=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683190133; x=1685782133;
        h=mime-version:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=d7MG5csGudovN2K9j7+IrEpvGLaArE7Ff8eEY8XeQ5Y=;
        b=ZOuXzI1fm4oqM+AfmcfYI1EtSuxvrFAed9gjhnf7CB+8GV2M7BwhsyGaxmpMDUxALN
         WLF51mUlvLM2Q3V9qq6Aqw0V+vmtQcWmVLYuQQHMPjydkcfoX5aQ81s8ePD4WsQ6vn/t
         6xubvDkvCfPhPyeyx62OvHH97qd0XW9m8Fnz5hUTZRPVDJehTA3GK+VMq6IjuW3s5LIR
         V12RQYCYwBd0U4n1X7W+UoJRceUBxIC0LpocTVNzN+qK7Wgw/gcFsBmLfzIo3wnftS2T
         lmQiM4GGzEw61gwVPkYbJb7VR64o1G+P+Xtda2GLwwqmcrVTf6NZQit22lLew9do5WfE
         fC2Q==
X-Gm-Message-State: AC+VfDwWIkJUmSEo8mfqBcFqJvdvnT/wlwiWibnm9IzIjM9MhDetA54S
        HEBt6LxQjANvvkcVaXRc236gKQNsTXm4Dl+kpQLVzmNdnvECpKhe49HQvPt6pdxYxDvuLqV1HCn
        nywDpS3NrulMjlX8n3vzPF/dL523qNX7fwvS+neiCHz6QZnLjgTz/N7oK8W50OC/fPZ70FxFFqG
        R6TTdq03u/Qd6zwLsAhJTFOA==
X-Google-Smtp-Source: ACHHUZ6biZeoTqseBeL5yoIYnQFxxlXb+wDcI1KzyXRd8kfJa5JG9MFc6EYgx6bOr2vSX8px+/htqQ==
X-Received: by 2002:a17:902:f807:b0:1aa:ea22:804e with SMTP id ix7-20020a170902f80700b001aaea22804emr2725695plb.19.1683190133179;
        Thu, 04 May 2023 01:48:53 -0700 (PDT)
Received: from localhost.localdomain ([192.19.250.250])
        by smtp.gmail.com with ESMTPSA id o3-20020a17090ad24300b00246be20e216sm2638936pjw.34.2023.05.04.01.48.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 May 2023 01:48:52 -0700 (PDT)
From:   Boris Sukholitko <boris.sukholitko@broadcom.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Ilya Lifshits <ilya.lifshits@broadcom.com>,
        Boris Sukholitko <boris.sukholitko@broadcom.com>
Subject: [PATCH nf-next v2 0/4] selftest: netfilter: small test tweaks
Date:   Thu,  4 May 2023 11:48:10 +0300
Message-Id: <20230504084814.41487-1-boris.sukholitko@broadcom.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000009d1b05fada3e61"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

--000000000000009d1b05fada3e61
Content-Transfer-Encoding: 8bit

Hi,

These patches allow nft_flowtable.sh test script to work in busybox environment
(patches 1-2).

More exact wait for netcat running in the background is in patch 3.

Small adaptive sleep optimization (patch 4) helps with running on busy servers
and cuts default sleep time a bit.

Thanks,
Boris.

- v2:
    - extracted from controversial dscp offload series
    - added Acked-by: Florian Westphal <fw.de> on patch 4

Boris Sukholitko (4):
  selftest: netfilter: use /proc for pid checking
  selftest: netfilter: no need for ps -x option
  selftest: netfilter: wait for specific nc pids
  selftest: netfilter: monitor result file sizes

 .../selftests/netfilter/nft_flowtable.sh      | 21 +++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)


base-commit: 19c60fdee5db881a99a9c39fb31942a530d20c63
-- 
2.32.0


--000000000000009d1b05fada3e61
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
ydoyIjshhiv/IkUwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIH9ubtGf9bFMwMJV
jDYPqhoENq3Z/87zBP8H6tfJxn8TMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcN
AQkFMQ8XDTIzMDUwNDA4NDg1M1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZI
AWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEH
MAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCqt7ms0+sZdqZDFv1vepcbto+SUMSxH6kg
KjHzL+ldG7pn907IuEP4/o3cKzViqxHgFJ4JIbInnGyYwziyvQpr4RnEZHBswCW/cAvEIN2+gQva
+an7XECOiXd0Z7xZgXcazs22GS7YOtxvm6vdzqjGAEZBhihj+ByZIkhgF0wwQd6ym2rcrC3QWCFb
ZDm12va9UoX6Xzsu8EsHQsSir3eNldhc9A0c45N29cX4bSExTOUTEKDfrJm0kJ0i7SQP74PcHKVF
8kq/UWHKcwaoW7jm4cSbemhKNsyyMdJi/v+/nvSBZ7tEW9S8xydAP/k1vqIyx3RCEcHS785G7VPP
QLlR
--000000000000009d1b05fada3e61--
