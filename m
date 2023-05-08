Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8157BC77B73
	for <netfilter-devel@archiver.kernel.org>; Mon,  8 May 2023 13:39:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233973AbjEHNjW (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 8 May 2023 09:39:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233847AbjEHNjU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 8 May 2023 09:39:20 -0400
Received: from mail-pf1-x42e.google.com (mail-pf1-x42e.google.com [IPv6:2607:f8b0:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 960D636119
        for <netfilter-devel@vger.kernel.org>; Mon,  8 May 2023 06:38:57 -0700 (PDT)
Received: by mail-pf1-x42e.google.com with SMTP id d2e1a72fcca58-643990c5319so3007991b3a.2
        for <netfilter-devel@vger.kernel.org>; Mon, 08 May 2023 06:38:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1683553137; x=1686145137;
        h=in-reply-to:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nKfrH62szHd5/TOOp35t+D0iAwbvmgnb//2M6bdIzYQ=;
        b=ckFs5yWANlysd8yzAMat8mHyFnnSrNTx2tXmZrj0cxtnnEVuaK06M1BaKeicRC/AaU
         gcmu1DAzxa1V6hCWtoqiaECOJErQQzK44bWvLFmpXRQbphCFM8cDqFSPe+Au+azJfmTk
         HbLbTLJ53IlIf6gDQUD0NMz0mu1fbL0UYaoSk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683553137; x=1686145137;
        h=in-reply-to:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nKfrH62szHd5/TOOp35t+D0iAwbvmgnb//2M6bdIzYQ=;
        b=lTktLZFSzhIr6urYeLFnmSuAx8iH33BNg9Q1Gc64paEwSQ8jrMmSoQF+aN2zTnyF+C
         kV8BOb29JQaMvArlknJaFBhn4DKDrM6SrjvsaX9DB0PGpKoR4at+KNfKM+37aSF+asN0
         j6O05n+msOsul0Zc6x8tg3fr0CgObYsuWeY0B17o24G16kBVszPA8ShnMW5qgbBhVyGe
         SYSl2D1xhFEoJHUvxt0wp1cne1Cn6WJNq7oFF1WGHDkRaGLTUgz3ryOWjUZ3b3cGJ79e
         goz6nSew9zMDpflnl202Q+NDFQK6DCSS74MyDOKlU0eXzK0M2ixxAn+M9GFm5u667mKA
         aVNQ==
X-Gm-Message-State: AC+VfDzmSM8/Pn45Hb9zM5fDniAj1rnhxZctuMdfDz0oWwYn4d08hIfG
        rayCknU8szj+ysUIy266axw3SDE9xGuqtRqnti0=
X-Google-Smtp-Source: ACHHUZ4eKaDnCNhUlF0qr+JXPh2+/NRVwiZStN9RMyzAuEZHlyREjVKzWyW9iw15v3OdfhxmmPeAxA==
X-Received: by 2002:a05:6a00:240b:b0:639:28de:a91e with SMTP id z11-20020a056a00240b00b0063928dea91emr12711250pfh.17.1683553136651;
        Mon, 08 May 2023 06:38:56 -0700 (PDT)
Received: from noodle ([192.19.250.250])
        by smtp.gmail.com with ESMTPSA id c13-20020aa7880d000000b0063d2bb0d10asm6079249pfo.113.2023.05.08.06.38.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 May 2023 06:38:55 -0700 (PDT)
Date:   Mon, 8 May 2023 16:38:06 +0300
From:   Boris Sukholitko <boris.sukholitko@broadcom.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        Ilya Lifshits <ilya.lifshits@broadcom.com>
Subject: Re: [PATCH nf-next 00/19] netfilter: nftables: dscp modification
 offload
Message-ID: <ZFj7PomKpCnLsDz2@noodle>
References: <20230503125552.41113-1-boris.sukholitko@broadcom.com>
 <20230503184630.GB28036@breakpoint.cc>
 <CADuVC7imr-YL4aUKbrRSQbQ_2QY_A5zCiAfmqgz9o49-n8AkTg@mail.gmail.com>
 <20230507173758.GA25617@breakpoint.cc>
MIME-Version: 1.0
In-Reply-To: <20230507173758.GA25617@breakpoint.cc>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000b18b4705fb2ec20e"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

--000000000000b18b4705fb2ec20e
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Sun, May 07, 2023 at 07:37:58PM +0200, Florian Westphal wrote:
> Boris Sukholitko <boris.sukholitko@broadcom.com> wrote:
> > On Wed, May 3, 2023 at 9:46 PM Florian Westphal <fw@strlen.de> wrote:
> > >
> > > Boris Sukholitko <boris.sukholitko@broadcom.com> wrote:
> > [... snip to non working offload ...]
> > 
> > > > table inet filter {
> > > >         flowtable f1 {
> > > >                 hook ingress priority filter
> > > >                 devices = { veth0, veth1 }
> > > >         }
> > > >
> > > >         chain forward {
> > > >                 type filter hook forward priority filter; policy accept;
> > > >                 ip dscp set cs3 offload
> > > >                 ip protocol { tcp, udp, gre } flow add @f1
> > > >                 ct state established,related accept
> > > >         }
> > > > }
> > 
> > [...]
> > 
> > >
> > > I wish you would have reported this before you started to work on
> > > this, because this is not a bug, this is expected behaviour.
> > >
> > > Once you offload, the ruleset is bypassed, this is by design.
> > 
> > From the rules UI perspective it seems possible to accelerate
> > forward chain handling with the statements such as dscp modification there.
> > 
> > Isn't it better to modify the packets according to the bypassed
> > ruleset thus making the behaviour more consistent?
> 
> The behaviour is consistent.  Once flow is offloaded, ruleset is
> bypassed.  Its easy to not offload those flows that need the ruleset.
> 
> > > Lets not make the software offload more complex as it already is.
> > 
> > Could you please tell which parts of software offload are too complex?
> > It's not too bad from what I've seen :)
> > 
> > This patch series adds 56 lines of code in the new nf_conntrack.ext.c
> > file. 20 of them (nf_flow_offload_apply_payload) are used in
> > the software fast path. Is it too high of a price?
> 
> 56 lines of code *now*.
> 
> Next someone wants to call into sets/maps for named counters that
> they need.  Then someone wants limit or quota to work.  Then they want fib
> for RPF.  Then xfrm policy matching to augment acccounting.
> This will go on until we get to the point where removing "fast" path
> turns into a performance optimization.

OK. May I assume that you are concerned with the eventual performance impact
on the software fast path (i.e. nf_flow_offload_ip_hook)?

Obviously the performance of the fast path is very important to our
customers. Otherwise they would not be requiring dscp fast path
modification. :)

One of the things we've thought about regarding the fast path
performance is rewriting nf_flow_offload_ip_hook to work with
nf_flowtable->flow_block instead of flow_offload_tuple.

We hope that iterating over flow_action_entry list similar to what the
hardware acceleration does, will be more efficient also in software.

Nice side-effect of such optimization would be that the amount of
feature bloat (such as dscp modification!) will not affect your typical
connection unless the user actually uses them.

For example, for dscp payload modification we'll generate
FLOW_ACTION_MANGLE entry. This entry will appear on flow_block's of
the only connections which require it. Others will be uneffected.

Would you be ok with such direction (with performance tests of
course)? 

Thanks,
Boris.

> 
> Existing rule hw offload via netdev:ingress makes it clear
> what rules are offloaded and to which device and it augments
> flowtable feature regardless if thats handled by software fastpath,
> software fallback/slowpath or by hardware offload.
> 
> > > If you want to apply dscp payload modification, do not use flowtable
> > > offload or hook those parts at netdev:ingress, it will be called before the
> > > software offload pipeline.
> > >
> > 
> > The problem is that our customers need to apply dscp modification in
> > more complex scenarios, e.g. after NAT.
> > Therefore I am not sure that ingress chain is enough for them.
> 
> I don't understand why this would have to occur after nat, but
> netdev:egress exists as well.

--000000000000b18b4705fb2ec20e
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
ydoyIjshhiv/IkUwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIMznzYSqORXGXZfk
26VGS8u9JAHIRz1m0SX5UeWu/S4yMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcN
AQkFMQ8XDTIzMDUwODEzMzg1N1owaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZI
AWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEH
MAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQAHiIBHO1z+2EyP6k5K7PMmdmb6N5XJ8r8L
IrSUpjcIBL9G6qZDqbxgInLdEZpTU3kEfWQZ8sYs/Y1WTnLw6dQrubex0Mbey4m70ewgSQE+RS+7
6fvXsYfMeyfcRmKklravIcJjZEmHNiyX5LM6T2slxQ0ZVRodz89KUFQAFLhgySu47AFe/vmNcH6x
DTLn/0WixFvh+B9vgKoZLsBpCtnHIQHro6m2XVE+Bn/Vajqq/Vf66G4gX/Eq8/NiIrZQ9+enB5nF
hx11z2dAkASTb56vU7CMhu3p9Q15swVYdogCxkh0hwCJ41l3P7XD3HvIJB//x/eAY7PSynUkTSvM
j1cp
--000000000000b18b4705fb2ec20e--
