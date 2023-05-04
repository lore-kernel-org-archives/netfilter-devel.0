Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00AF2C77B78
	for <netfilter-devel@archiver.kernel.org>; Thu,  4 May 2023 08:54:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230307AbjEDIyl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 4 May 2023 04:54:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229516AbjEDIyF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 4 May 2023 04:54:05 -0400
Received: from mail-lj1-x233.google.com (mail-lj1-x233.google.com [IPv6:2a00:1450:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F4013AB0
        for <netfilter-devel@vger.kernel.org>; Thu,  4 May 2023 01:54:04 -0700 (PDT)
Received: by mail-lj1-x233.google.com with SMTP id 38308e7fff4ca-2a8b1b51dbdso2544681fa.0
        for <netfilter-devel@vger.kernel.org>; Thu, 04 May 2023 01:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1683190443; x=1685782443;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lBbV9lwhYy22TxUMcFPEGb6nVEuZUkjPvWr0QIRjwlk=;
        b=d8hZtBZe+0adk+gHT2PUu1slnHSBoe8Euusxu6bR2fuTgHXI00fLT2iAS0sCTEBn9q
         u34CopuswnwyB6Y/wZLHZbpSm7MUThwLzN8VLr8pVDK4jt9+sJ1D0V5GE43rpHYVmkS6
         Fv9UFW2/P1HzMyP9JKkDdeAperczJtjVrUli4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683190443; x=1685782443;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lBbV9lwhYy22TxUMcFPEGb6nVEuZUkjPvWr0QIRjwlk=;
        b=IdZ2dfRUGJP/N8j3wjJYcDQbVPnDmXaHBR7J+DbB0hdLvEl+ZeEenQNeDk09fcmdB5
         xBcplunXlVjprAkZ2n0BpFYZ7MG7i7AHkaB2GX4nHC67uemaAIgLjHL8RYFGIhSHRhBl
         uQXWiZsBeEEOvaqHPXJ+fQXQSpdQk4JA5G6f+uAGwQ3Hcz1YMM2u8PXHLzieEsKZRUe1
         Ddboe6JlmFXpNJtxUDzVl8iofgXhJFERmxcu0i90WlCOKEdukVKyXFaoasxb53y5e2EU
         L9j/8z2a+GzFLyWM1JtnTgjg9cyCqKCd0Fy+i/19IAtSqcaW+bstz405lNcBNWGV16I3
         u3AA==
X-Gm-Message-State: AC+VfDx7RQ5T3UCwn0FKjWSzqqXvplrS9N5PSNIpalBxCGPUFaZqFYa8
        uXBuiBF1OHn34ROi190ru7TeFjARUx8ElbePDmcezg==
X-Google-Smtp-Source: ACHHUZ7LD+X+FGZvC7qnSOXr9I5dP6ZSQnTzYv5SLDcs4NnJrsHi6uEQJ3+8pM3WOxDX9XGuJ5PbzQ3hEIbZYoDJTZk=
X-Received: by 2002:a2e:9612:0:b0:2a8:ea26:607f with SMTP id
 v18-20020a2e9612000000b002a8ea26607fmr684117ljh.31.1683190442732; Thu, 04 May
 2023 01:54:02 -0700 (PDT)
MIME-Version: 1.0
References: <20230503125552.41113-1-boris.sukholitko@broadcom.com>
 <20230503125552.41113-2-boris.sukholitko@broadcom.com> <20230503184708.GC28036@breakpoint.cc>
In-Reply-To: <20230503184708.GC28036@breakpoint.cc>
From:   Boris Sukholitko <boris.sukholitko@broadcom.com>
Date:   Thu, 4 May 2023 11:53:16 +0300
Message-ID: <CADuVC7gWArHL=9gKBP3a64j_hZKH4cjiRynrz74S_ZhYhX=5tw@mail.gmail.com>
Subject: Re: [PATCH nf-next 01/19] selftest: netfilter: use /proc for pid checking
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org,
        Ilya Lifshits <ilya.lifshits@broadcom.com>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="00000000000072cf9305fada5022"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

--00000000000072cf9305fada5022
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, May 3, 2023 at 9:47=E2=80=AFPM Florian Westphal <fw@strlen.de> wrot=
e:
>
> Boris Sukholitko <boris.sukholitko@broadcom.com> wrote:
> > Some ps commands (e.g. busybox derived) have no -p option. Use /proc fo=
r
> > pid existence check.
> >
> > Signed-off-by: Boris Sukholitko <boris.sukholitko@broadcom.com>
> > ---
> >  tools/testing/selftests/netfilter/nft_flowtable.sh | 4 ++--
> >  1 file changed, 2 insertions(+), 2 deletions(-)
> >
> > diff --git a/tools/testing/selftests/netfilter/nft_flowtable.sh b/tools=
/testing/selftests/netfilter/nft_flowtable.sh
> > index 7060bae04ec8..4d8bc51b7a7b 100755
> > --- a/tools/testing/selftests/netfilter/nft_flowtable.sh
> > +++ b/tools/testing/selftests/netfilter/nft_flowtable.sh
> > @@ -288,11 +288,11 @@ test_tcp_forwarding_ip()
> >
> >       sleep 3
> >
> > -     if ps -p $lpid > /dev/null;then
> > +     if test -d /proc/"$lpid"/; then
> >               kill $lpid
>
> I'd shorten both to
>
> kill $lpid 2>/dev/null

I don't like the kill here because it may fail silently should we run
with "set -e" in the future.

I took the liberty to leave the test as is in v2.

Thanks,
Boris.

--00000000000072cf9305fada5022
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
ydoyIjshhiv/IkUwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIOa10Ree/2C6hPWI
scpQSOG7Wb+3dVh4EEQUNPS8grqyMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcN
AQkFMQ8XDTIzMDUwNDA4NTQwM1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZI
AWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEH
MAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAgc+wVz9NOLevbj9QUJUlvC05lMUo3shjv
WcJiVeP4PEdkYa1BawS03dqDtGbxf/I1SQ3BV8tOYEABhLRsG09iRhxm7ki3DiFaUHzDT61LANTm
8iHbHdtVNVL5o1x34GcFWE1q+aiJIJQNt/w5RLwxRcWpLNWIAy0sq3Tp447sWbaoyHxvIRl1VaVB
77EjrFppbWWJqjzpwAxAyoWDYHJG7R64sUG+AtvHdFQ6QiKfA4kmbbyqHFxR5Msuk2pC8ipL7p31
JYaF+SdSwfxvwvdVG8RSEu2c8weoq2+Xy6DeoJIDJd2qCTn1XIzwzP3sYDMzAFGzbhz0mqtHU1ox
LVYl
--00000000000072cf9305fada5022--
