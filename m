Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1E5EC77B7D
	for <netfilter-devel@archiver.kernel.org>; Wed, 10 May 2023 07:50:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236086AbjEJHuN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 10 May 2023 03:50:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236056AbjEJHuM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 10 May 2023 03:50:12 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AAFF10D
        for <netfilter-devel@vger.kernel.org>; Wed, 10 May 2023 00:50:10 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 5b1f17b1804b1-3f41dceb9c9so29040095e9.3
        for <netfilter-devel@vger.kernel.org>; Wed, 10 May 2023 00:50:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1683705008; x=1686297008;
        h=in-reply-to:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=NLEaJMptTUwVKem0FwaBM+pW/GBc0hIfm3gLytW3H0Q=;
        b=f30oayUwlalVxsISObt7WOKo/Yu1Hc49Vw7/Icced0dMbrjDxCe3o24eHA0Qd93RiK
         /+jp6YF34syNZZ8QV+7OhDWHIQdrTA8uWUoBz2S/FWxIGuO5K57xPwuuaWbQu6k55052
         BHwQJIbhMSBqt6NApEetBoa30xyJcmmNv0FmQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683705008; x=1686297008;
        h=in-reply-to:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NLEaJMptTUwVKem0FwaBM+pW/GBc0hIfm3gLytW3H0Q=;
        b=LcGZqS1k1mwJsFhzEoXuqDcCQWbQnGOTZHgeb78AtP2WD9HhM81nyeUP1JMxci6J09
         mINIq7QYgRkQYAwwoHJuPG1ZsE3TL8M5RICTk8AbDab+dUUaBNTpoYXblJITpw/gW75D
         qFJLiuhgZXJQ715Vwo2bxd9sjxJtydLatiK9Lo0ZrdNlqy7T+cWfsPQMGhGMCTzYoOgs
         /sALsWkeVzszsY9WOMitIvYCKujc+B/64+ucUZtWBsIlbdKvNrEpbL+r+Vh/8jnFxM3S
         uqI5iXCG+/LKfy/JiV5MdF3oO2FtWbHsndHH/zgQgsoP7dMYkc3PPpW5PI/qU2nBufYW
         zrIA==
X-Gm-Message-State: AC+VfDxbImOTgGimZTZKT/jlTfxI/3Dbddyqd1R/TmfWcL8+MXe/icSI
        XhXRUYJ6+CubcINXeC6ILo/yFQ==
X-Google-Smtp-Source: ACHHUZ62MXzKwQo5zrEfqcI9/ev27tiiI9knHZmiqSrRUWRiDmYNk7/qDi+neldvPt6ygQr/HWPAIA==
X-Received: by 2002:a05:600c:28f:b0:3f1:8430:523 with SMTP id 15-20020a05600c028f00b003f184300523mr11635076wmk.14.1683705008442;
        Wed, 10 May 2023 00:50:08 -0700 (PDT)
Received: from noodle ([192.19.250.250])
        by smtp.gmail.com with ESMTPSA id h8-20020a1ccc08000000b003f17eaae2c9sm22081165wmb.1.2023.05.10.00.50.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 May 2023 00:50:07 -0700 (PDT)
Date:   Wed, 10 May 2023 10:49:25 +0300
From:   Boris Sukholitko <boris.sukholitko@broadcom.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        Ilya Lifshits <ilya.lifshits@broadcom.com>
Subject: Re: [PATCH nf-next 00/19] netfilter: nftables: dscp modification
 offload
Message-ID: <ZFtMhcF4wvV3drx8@noodle>
References: <20230503125552.41113-1-boris.sukholitko@broadcom.com>
 <20230503184630.GB28036@breakpoint.cc>
 <CADuVC7imr-YL4aUKbrRSQbQ_2QY_A5zCiAfmqgz9o49-n8AkTg@mail.gmail.com>
 <20230507173758.GA25617@breakpoint.cc>
 <ZFj7PomKpCnLsDz2@noodle>
 <20230509094827.GA14758@breakpoint.cc>
MIME-Version: 1.0
In-Reply-To: <20230509094827.GA14758@breakpoint.cc>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="000000000000f7687105fb521eab"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

--000000000000f7687105fb521eab
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Tue, May 09, 2023 at 11:48:27AM +0200, Florian Westphal wrote:
> Boris Sukholitko <boris.sukholitko@broadcom.com> wrote:
> > On Sun, May 07, 2023 at 07:37:58PM +0200, Florian Westphal wrote:
> > > Boris Sukholitko <boris.sukholitko@broadcom.com> wrote:
> > > > On Wed, May 3, 2023 at 9:46 PM Florian Westphal <fw@strlen.de> wrote:
> > > > >
> > > > > Boris Sukholitko <boris.sukholitko@broadcom.com> wrote:
> > > > [... snip to non working offload ...]
> > > > 
> > > > > > table inet filter {
> > > > > >         flowtable f1 {
> > > > > >                 hook ingress priority filter
> > > > > >                 devices = { veth0, veth1 }
> > > > > >         }
> > > > > >
> > > > > >         chain forward {
> > > > > >                 type filter hook forward priority filter; policy accept;
> > > > > >                 ip dscp set cs3 offload
> > > > > >                 ip protocol { tcp, udp, gre } flow add @f1
> > > > > >                 ct state established,related accept
> > > > > >         }
> > > > > > }
> > > > 
> > > > [...]
> > > > 
> > > > >
> > > > > I wish you would have reported this before you started to work on
> > > > > this, because this is not a bug, this is expected behaviour.
> > > > >
> > > > > Once you offload, the ruleset is bypassed, this is by design.
> > > > 
> > > > From the rules UI perspective it seems possible to accelerate
> > > > forward chain handling with the statements such as dscp modification there.
> > > > 
> > > > Isn't it better to modify the packets according to the bypassed
> > > > ruleset thus making the behaviour more consistent?
> > > 
> > > The behaviour is consistent.  Once flow is offloaded, ruleset is
> > > bypassed.  Its easy to not offload those flows that need the ruleset.
> > > 
> > > > > Lets not make the software offload more complex as it already is.
> > > > 
> > > > Could you please tell which parts of software offload are too complex?
> > > > It's not too bad from what I've seen :)
> > > > 
> > > > This patch series adds 56 lines of code in the new nf_conntrack.ext.c
> > > > file. 20 of them (nf_flow_offload_apply_payload) are used in
> > > > the software fast path. Is it too high of a price?
> > > 
> > > 56 lines of code *now*.
> > > 
> > > Next someone wants to call into sets/maps for named counters that
> > > they need.  Then someone wants limit or quota to work.  Then they want fib
> > > for RPF.  Then xfrm policy matching to augment acccounting.
> > > This will go on until we get to the point where removing "fast" path
> > > turns into a performance optimization.
> > 
> > OK. May I assume that you are concerned with the eventual performance impact
> > on the software fast path (i.e. nf_flow_offload_ip_hook)?
> 
> Yes, but I also dislike the concept, see below.
> 
> > Obviously the performance of the fast path is very important to our
> > customers. Otherwise they would not be requiring dscp fast path
> > modification. :)
> > 
> > One of the things we've thought about regarding the fast path
> > performance is rewriting nf_flow_offload_ip_hook to work with
> > nf_flowtable->flow_block instead of flow_offload_tuple.
> 
> Sorry, I should have expanded on my reservations towards this concept.
> 
> Let me explain.
> Lets consider your original example first:
> 
> ----------
> table inet filter {
>         flowtable f1 {
>                 hook ingress priority filter
>                 devices = { veth0, veth1 }
>         }
> 
>         chain forward {
>                 type filter hook forward priority filter; policy accept;
>                 ip dscp set cs3
>                 ip protocol { tcp, udp, gre } flow add
>                 ct state established,related accept
>         }
> }
> ----------
> 
> This has a clearly defined meaning in all possible combinations.
> 
> Software:
> 1. It defines a bypass for veth0 <-> veth1
> 2. the way this specific ruleset is defined, all of tcp/udp/gre will
>    attempt to offload

OK.

> 3. once offload has happened, entire inet:forward may be bypassed

By bypassed, do you mean that chain forward ruleset body becomes
irrelevant? If the unfortunate answer is yes, than as in the original
report, once we are in the software fast path we do not do dscp
modification, right?

Then once we hit the NF_FLOW_TIMEOUT, some of the packets will have dscp
modified, because we've went out of software acceleration. I.e. some of
the packets will arrive with and some without dscp. As you can imagine,
this could be hard to debug. This is the scenario that the patch series
tries to fix.

> 4. User ruleset needs to cope with packets being moved back to
>    software: fragmented packets, tcp fin/rst, hw timeouts and so on.

Should we require our user to understand that some lines in their
forward table configuration may or may not be executed sporadically?
Should we give the user at least some kind of warning regarding this
during the ruleset load?

To be constructive, isn't it better to rephrase points 3 and 4 as:

3. once offload has happened, entire inet:forward will be executed with
the same semantics but with better performance. Any difference between
fast and slow path is considered a bug.

4. If something in user ruleset (such as dscp rule now) precludes fast
path optimization then either error will be given or slow path will be
taken with a warning.

> 5. User can control via 'offload' keyword if HW offload should be
>    attempted or not
> 
> Hardware:
> even 'nf_flow_offload_ip_hook' may be bypassed.  But nothing changes
> compared to 'no hw offload' case from a conceptual point of view.
> 

Agreed.

> Lets now consider existing netdev:ingress/egress in this same picture:
> (Example from Pablo):
> ------
> table inet filter {
>         flowtable f1 {
>                 hook ingress priority filter
>                 devices = { veth0, veth1 }
>         }
> 
>         chain ingress {
>                 type filter hook ingress device veth0 priority filter; policy accept; flags offload;
>                 ip dscp set cs3
>         }
> 
>         chain forward {
>                 type filter hook forward priority filter; policy accept;
>                 meta l4proto { tcp, udp, gre } flow add @f1
>                 ct state established,related accept
>         }
> }
> 
> Again, this has defined meaning in all combinations:
> With HW offload: veth0 will be told to mangle dscp.
> This happens in all cases and for every matching packet,
> regardless if a flowtable exists or not.
> 
> Same would happen for 'egress', just that it would happen at xmit time
> rather at receive time.  Again, its not relevant if there is active
> flowtable or not, or if data path is offloaded to hardware, to software,
> handled by fallback or entirely without flowtables being present.
> 
> Its also clear that this is tied to 'veth0', other devices will
> not be involved and not do such mangling.
> 

As I've mentioned in my other reply to Pablo, our focus is exclusively
on the *software* fast path of the forward chain. In this scenario
getting into additional nftables VM path in the ingress or egress seems
like pessimization which we'd like to avoid.

> Now lets look at your proposal:
> ----------------
> table inet filter {
>         flowtable f1 {
>                 hook ingress priority filter
>                 devices = { veth0, veth1 }
>         }
> 
>         chain forward {
>                 type filter hook forward priority filter; policy accept;
>                 ip dscp set cs3 offload
>                 ip protocol { tcp, udp, gre } flow add
>                 ct state established,related accept
>         }
> }
> ----------------
> 
> This means that software flowtable offload
> shall do a 'ip dscp set cs3'.
> 
> What if the flowtable is offloaded to hardware
> entirely, without software fallback?
> 
> What if the devices listed in the flowtable definition can handle
> flow offload, but no payload mangling?
> 
> Does the 'offload' mean that the rule is only active for
> software path?  Only for hardware path? both?
> 
> How can I tell if its offloaded to hardware for one device
> but not for the other?  Or will that be disallowed?
> 
> What if someone adds another rule after or before 'ip dscp',
> but without the 'offload' keyword?  Now ordering becomes an
> issue.
> 
> Users now need to consider different control flows:
> 
>   jump exceptions
>   ip dscp set cs3 offload
> 
>   chain exceptions {
>     ip daddr 1.2.3.4 accept
>   }
> 
> This won't work as expected, because offloaded flows will not
> pass through 'forward' chain but somehow a few selected rules
> will be run anyway.
> 
> TL;DR: I think that for HW offload its paramount to make it crystal
> clear as to which device is responsible to handle such rules.

Your critique of my offload flag is well deserved and fully correct,
thanks! The reason for the dscp statement offload flag was to try to be
explicit about the need for payload modification capture.

What we've really wanted to do here is to make the payload capture
dependent on the chain flowtable acceleration status. I.e. if the
forward chain is supposed to be accelerated, than the payload
modification capture should happen. Being lazy, I've went through that
ugly keyword path. Apologies for that.
 
> 
> The existing netdev:ingress/egress hooks provide the needed
> chain/rules/expression:device mapping.  User can easily
> tell if HW is responsible or SW by looking for 'offload' flag
> presence.
> 

Yes. But again hardware offload is irrelevant for the problem we have
here.

> I don't think mixing software and hardware offload contexts as proposed
> is a good idea, both from user frontend syntax, clarity and error reporting
> (e.g. if hw rejects offload request) point of view.
> 

Frontend syntax and nft userspace should not be affected once we drop
the unneeded offload flag on dscp statement.

> I also believe that allowing payload mangling from *software* offload
> path sets a precedence for essentially allowing all other expressions
> again which completely negates the flowtable concept.

IMHO, the flowtable concept means transparent acceleration of packet
processing between the specified interfaces. If something in the ruleset
precludes such acceleration warnings/errors should be given.

Do you agree?

Once the goal of significant performance gains is preserved, the
expansion of the universe of accelerated expressions is benign. And why
not? We are still being fast.

My suggestion regarding doing the software fast path through the
flow_block tries to decouple the performance of the fast path from the
size of such universe. The basic idea is that you don't pay for what you
don't use.

> 
> I still think that dscp mangling should be done via netdev:ingress/egress
> hooks, I don't see why this has to be bolted into flowtable sw offload.
> 

Because it can be made faster :)

Thanks,
Boris.

--000000000000f7687105fb521eab
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
ydoyIjshhiv/IkUwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEILdpGfrIv3lm9SCB
a/Gvw39pBsjwetbPSuJYYQ0ynPpkMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcN
AQkFMQ8XDTIzMDUxMDA3NTAwOFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZI
AWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEH
MAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQBCPbiMWCurB0ZcVg1E1+/SNaTR07fCqa0y
4+fR4VfwJB8p3ajXuOQVzkMswVFJQJ9nnabquKNWS9/EJorD3EGM9cUD9H8aVAEA/rVku6QgFtPD
Q0GiPFdvXps91LSIx6Wl7jvbDE9x3ZoCg3BJMasTxgZAeajhrBlItE5wkl/UWoJU0uVC6hc4Vi6+
epCY7klMbrVzsKCeoaZ4yuBayEKu8XZnfrwXq9zEi28kXjJqDhYhze1sdnFjnA2J3mHoaRcwod63
i5fPi01BZOEDfRQ9pN++OF1eRXbbmT6vZ/WQmyDLcLr0n4WpgV+q+VIyx2mvCy1btDXFmg0822NZ
WPA6
--000000000000f7687105fb521eab--
