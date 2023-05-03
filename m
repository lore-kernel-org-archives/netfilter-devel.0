Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3F01C77B75
	for <netfilter-devel@archiver.kernel.org>; Wed,  3 May 2023 12:56:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229601AbjECM4T (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 3 May 2023 08:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229754AbjECM4Q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 3 May 2023 08:56:16 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40F4D59CF
        for <netfilter-devel@vger.kernel.org>; Wed,  3 May 2023 05:56:13 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id 5b1f17b1804b1-3f315735514so22781695e9.1
        for <netfilter-devel@vger.kernel.org>; Wed, 03 May 2023 05:56:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1683118571; x=1685710571;
        h=mime-version:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5Ci7zWQ2KMgPFaDccNIAUdnzkTb5S94q6dvoxP2b3gA=;
        b=IYqugN+lfkEvHWc+kcN4DyUO55VGU6YBFhuCRDkCLf7Dx1SC4uVlLbGTlW16BzKUn1
         VlY0wUAHtN6OxtH1gkiBG9uIfIwSDEH8x8qCrRsy4BSm0Yh3M5GNRJrxToyXRYG0Lh0b
         lvYKYLejMYSQfIGELGh5jwWDLvBcT6wxcpa40=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683118571; x=1685710571;
        h=mime-version:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5Ci7zWQ2KMgPFaDccNIAUdnzkTb5S94q6dvoxP2b3gA=;
        b=MTYqqw2Xklcv60nqL3CyLbflBW5RogOxm12Aj49zcE1Z7zINtJwZ5h/H8r9ltaWdyj
         Dr93MAfJamgv511OlSA9gkMYtlFaW80J45PE5nvuRNMFwUcnsLuGs0uUuRde0Tidy98C
         Ves+7ZDanOY1G0u/9gdZRGabPyEUTT5v2N3Edc9FI954omY7KvoiwMZF0AvpijqdcFf6
         GUSvr0y3/Isz0fmjo7dH/139KNWaB+f0vLpf6VEbo+HYNtnqb6bKv5pQdgGYPwm+6eY8
         tLi+0dFs32dn5E3b85sfxcjD1BzrkkM+oDjYz+vNoxwiF9K1gPUlBx+h6wQgqTdqWNj1
         MiRw==
X-Gm-Message-State: AC+VfDxBSAMKEKHQBMajpiJhajTtXZ76/fojEab0+AKz5rvnxusCEpng
        RR+H+OcHSHlX5SPE43U2m4VizMZMlr7VcZ62sKO6kl36cMhWgEWt2p+Uo07DiQY9YN2tQC0AONX
        J6oWrnZ7qAK/4QbOUUEdudfwUDiEDbx41OzX1viwH0LKmXjnYYYptd3StyWzYKvHzmR4XAbw2XU
        IkjqoROUpY6zZ6duB3ZTqvsQ==
X-Google-Smtp-Source: ACHHUZ62mx4+JpZyKOlTZczs09UaFKWCn0ImcooI9XSugdrpj65Lq4eC2z10A8W5UBqh7eJxZEBm6g==
X-Received: by 2002:a5d:6148:0:b0:306:3881:d9ae with SMTP id y8-20020a5d6148000000b003063881d9aemr1530413wrt.26.1683118571354;
        Wed, 03 May 2023 05:56:11 -0700 (PDT)
Received: from localhost.localdomain ([192.19.250.250])
        by smtp.gmail.com with ESMTPSA id u6-20020a05600c00c600b003ee1b2ab9a0sm1855396wmm.11.2023.05.03.05.56.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 May 2023 05:56:10 -0700 (PDT)
From:   Boris Sukholitko <boris.sukholitko@broadcom.com>
To:     netfilter-devel@vger.kernel.org
Cc:     Ilya Lifshits <ilya.lifshits@broadcom.com>,
        Boris Sukholitko <boris.sukholitko@broadcom.com>
Subject: [PATCH nf-next 00/19] netfilter: nftables: dscp modification offload
Date:   Wed,  3 May 2023 15:55:33 +0300
Message-Id: <20230503125552.41113-1-boris.sukholitko@broadcom.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000094763c05fac99454"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

--00000000000094763c05fac99454
Content-Transfer-Encoding: 8bit

Hi,

Consider ruleset such as:

table inet filter {
        chain forward {
                type filter hook forward priority filter; policy accept;
                ip dscp set cs3
                ct state established,related accept
        }
}

As expected, all of the packets from 10.0.2.99 to 10.0.1.99 have IPv4 tos field
changed to 0x60:

...
13:36:42.474591 fe:dc:b3:e2:dc:3b > 5a:45:4d:2a:25:65, ethertype IPv4 (0x0800), length 1090: (tos 0x60, ttl 62, id 39855, offset 0, flags [none], proto TCP (6), length 1076)
    10.0.2.99.12345 > 10.0.1.99.44084: Flags [P.], cksum 0x1bec (incorrect -> 0x44c3), seq 1:1025, ack 1025, win 1987, options [nop,nop,TS val 2854899766 ecr 3249774499], length 1024
...

Now lets try to add flow offload:

table inet filter {
        flowtable f1 {
                hook ingress priority filter
                devices = { veth0, veth1 }
        }

        chain forward {
                type filter hook forward priority filter; policy accept;
                ip dscp set cs3
                ip protocol { tcp, udp, gre } flow add 
                ct state established,related accept
        }
}

Although some of the packets still have their TOS being correct, some are not:

...
13:41:17.138782 5e:d5:1f:a3:ba:d1 > d2:d2:73:e6:5b:92, ethertype IPv4 (0x0800), length 1090: (tos 0x0, ttl 62, id 20142, offset 0, flags [none], proto TCP (6), length 1076)
    10.0.2.99.12345 > 10.0.1.99.34230: Flags [P.], cksum 0x1bec (incorrect -> 0xc090), seq 1:1025, ack 1, win 2009, options [nop,nop,TS val 2855174430 ecr 3250049157], length 1024
...

The root cause for the bug seems to be that nft_payload_set_eval (which sets the
dscp tos field) isn't being called on the offload fast path in
nf_flow_offload_ip_hook.

The fix in this patch series is to have payload modifications recorded in the
new conntrack extension. Then we apply those modifications on the fast path.

To signal intent to record payload changes, we add offload flag to the nft
userspace tool (separate patches follow). For example the dscp set line becomes:

....
ip dscp set cs3 offload
...

Some high level description of the patches:

* patches 1-4 fix small but annoying infelicities in nft_flowtable.sh test script
* patches 5-7 export payload modification functionality from nft_payload.c
* patches 8-10 add new NFT_PAYLOAD_CAN_OFFLOAD flag being set by the userspace
* patches 11-13 are technical changes to add the new conntrack extension
* patches 14-16 add payload context to the conntrack and apply them on the fast path
* patches 17-18 save the payload context if NFT_PAYLOAD_CAN_OFFLOAD flag is set.
* patch 19 adds dscp modification offload test to the nft_payload.sh test script.

Thanks,
Boris.

Boris Sukholitko (19):
  selftest: netfilter: use /proc for pid checking
  selftest: netfilter: no need for ps -x option
  selftest: netfilter: wait for specific nc pids
  selftest: netfilter: monitor result file sizes
  netfilter: nft_payload: refactor mangle operation
  netfilter: nft_payload: publish nft_payload_set
  netfilter: nft_payload: export mangle
  netfilter: nft_payload: use flag for checksum need
  netfilter: nft_payload: add offload flag define
  netfilter: nft_payload: allow offload in the netlink
  netfilter: conntrack: nft extension Kconfig
  netfilter: nft: empty nft conntrack extension
  netfilter: conntrack: register nft extension
  netfilter: nft: add payload context into extension
  netfilter: nft: add payload application
  netfilter: nftables: fast path payload mangle
  netfilter: nftables: payload save mechanism
  netfilter: nft_payload: save payload if needed
  selftests: netfilter: dscp offload test

 include/net/netfilter/nf_conntrack_extend.h   |  3 +
 include/net/netfilter/nf_tables.h             | 68 +++++++++++++++++++
 include/uapi/linux/netfilter/nf_tables.h      |  1 +
 net/netfilter/Kconfig                         | 10 +++
 net/netfilter/Makefile                        |  2 +
 net/netfilter/nf_conntrack_core.c             |  2 +
 net/netfilter/nf_conntrack_extend.c           |  9 ++-
 net/netfilter/nf_conntrack_netlink.c          |  2 +
 net/netfilter/nf_flow_table_ip.c              |  3 +
 net/netfilter/nft_conntrack_ext.c             | 56 +++++++++++++++
 net/netfilter/nft_payload.c                   | 46 +++++++------
 .../selftests/netfilter/nft_flowtable.sh      | 61 +++++++++++++++--
 12 files changed, 237 insertions(+), 26 deletions(-)
 create mode 100644 net/netfilter/nft_conntrack_ext.c

-- 
2.32.0


--00000000000094763c05fac99454
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
ydoyIjshhiv/IkUwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIIh0dMpKnO6XSXty
MLMc58jQRi7q2VaoSI5OqDF/Fzm1MBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcN
AQkFMQ8XDTIzMDUwMzEyNTYxMVowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZI
AWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEH
MAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCROq0WyPmqP9+Ro4NG0djf1gsSsuhwVi1u
8Z6JVEUptDQxg/6TfSR7MgXl0clJkVcqNqdXOjp4iG0YpTWkDmEh+/lmIwS9kqWXLCYEsNdq1qdl
0DnHVwhcfbrapj5XynDp8Tv794M69UC9e05D1FqxxKL2KzuDz9TxETIrAypHYnFdzLFwD0m86c1/
fuoGbuQhb6EIhc3bdHU0GrilNNY+HDKRd5Sn+nxc8anZLE2HdjW3EP67GsOk0pjWRsuSuUFIKTL4
VYh2RcMQrP15tlVYFb9qK7GM5iT31OVXpLOr/NpGGfYBx2sChoyR7IBsmUfiAylXnQSffZ+L8FC4
hAJE
--00000000000094763c05fac99454--
