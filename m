Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CD97C77B7C
	for <netfilter-devel@archiver.kernel.org>; Thu, 11 May 2023 15:59:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238263AbjEKP7o (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 11 May 2023 11:59:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232006AbjEKP7o (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 11 May 2023 11:59:44 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30FE0525C
        for <netfilter-devel@vger.kernel.org>; Thu, 11 May 2023 08:59:41 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id af79cd13be357-757807cb299so272194485a.2
        for <netfilter-devel@vger.kernel.org>; Thu, 11 May 2023 08:59:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1683820780; x=1686412780;
        h=in-reply-to:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qKte2CP+slfMYthSnA4Vrh+si2Yck9ezq+5QoatcvOg=;
        b=VYbEbk6z3xUf7Ym6dtcjpZ/e0KLCShZsfx2LemiHxPrEm4yTARUvPYLArVWdmeFpIU
         QLfgqd1hza67vG6sj0wKc1IC/KciJjbC0GAYr9skigwSm4gzEJ8rwm0euyBaMWXnyPMw
         tgaqnQWY0zXxbOLnYdxrpxRnC3Vdkzdl7wIh8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683820780; x=1686412780;
        h=in-reply-to:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qKte2CP+slfMYthSnA4Vrh+si2Yck9ezq+5QoatcvOg=;
        b=bEL4WbyPH6uMO1rUO70kJodw5mP2H1TNmr3ieinuYfEkgs6nKJMI1m0XA4lhqVkRGQ
         4oijGpFhJg6yTtKn9H/vtx1aF/e5WtVROgEghXpDa+egskBWloybLBLppkrb6Xf3Iryd
         S0RY9RJ7mfPa2//fm7Y6I6R0n9k+gEHPux9kuqcj9AMmXWv8/MQox4Pv/vkpHfwRd4UO
         xJxZkDEUYM0w3dFQpWKtPdMDGXmH1W/cTWjLvM6EFWHNjUeBhho6ewSEOJHWDwzl+8Oi
         jEXt4Wn18dD2vmqo/9k4eYmKjfpORp3hLuaXWx9twMdLOvWiW4bz2eGJdrtGPZvxDyr6
         IyEA==
X-Gm-Message-State: AC+VfDzPOjzmpUkRhIQ0fMYt6CzkvWl2Fb4jJSITnSVbJFb2dxAGMl+H
        CJuigG4CWqAT0dEoUi4jy8Zgeg==
X-Google-Smtp-Source: ACHHUZ7PIQZKciEmPw25KbfR/MJZzCfV2rYSRcniTfMLxP1KScaZxeiLfRD8nb6gQGSbTCpAE06Vew==
X-Received: by 2002:ac8:5c43:0:b0:3e4:e2bb:3297 with SMTP id j3-20020ac85c43000000b003e4e2bb3297mr35929889qtj.31.1683820779861;
        Thu, 11 May 2023 08:59:39 -0700 (PDT)
Received: from nixemu ([192.19.250.250])
        by smtp.gmail.com with ESMTPSA id 6-20020a05620a078600b007578622c861sm2605274qka.108.2023.05.11.08.59.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 May 2023 08:59:39 -0700 (PDT)
Date:   Thu, 11 May 2023 18:59:27 +0300
From:   Boris Sukholitko <boris.sukholitko@broadcom.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        Ilya Lifshits <ilya.lifshits@broadcom.com>
Subject: Re: [PATCH nf-next 00/19] netfilter: nftables: dscp modification
 offload
Message-ID: <ZF0Q37gucB2EiCxQ@nixemu>
References: <20230503125552.41113-1-boris.sukholitko@broadcom.com>
 <20230503184630.GB28036@breakpoint.cc>
 <CADuVC7imr-YL4aUKbrRSQbQ_2QY_A5zCiAfmqgz9o49-n8AkTg@mail.gmail.com>
 <20230507173758.GA25617@breakpoint.cc>
 <ZFj7PomKpCnLsDz2@noodle>
 <20230509094827.GA14758@breakpoint.cc>
 <ZFtMhcF4wvV3drx8@noodle>
 <20230510125544.GC21949@breakpoint.cc>
MIME-Version: 1.0
In-Reply-To: <20230510125544.GC21949@breakpoint.cc>
Content-Type: multipart/signed; protocol="application/pkcs7-signature"; micalg=sha-256;
        boundary="0000000000007bd16005fb6d1353"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

--0000000000007bd16005fb6d1353
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 10, 2023 at 02:55:44PM +0200, Florian Westphal wrote:
> Boris Sukholitko <boris.sukholitko@broadcom.com> wrote:
> > > table inet filter {
> > >         flowtable f1 {
> > >                 hook ingress priority filter
> > >                 devices = { veth0, veth1 }
> > >         }
> > > 
> > >         chain forward {
> > >                 type filter hook forward priority filter; policy accept;
> > >                 ip dscp set cs3
> > >                 ip protocol { tcp, udp, gre } flow add
> > >                 ct state established,related accept
> > >         }
> > > }
> > > ----------
> > > 
> > > This has a clearly defined meaning in all possible combinations.
> > > 
> > > Software:
> > > 1. It defines a bypass for veth0 <-> veth1
> > > 2. the way this specific ruleset is defined, all of tcp/udp/gre will
> > >    attempt to offload
> > 
> > OK.
> > 
> > > 3. once offload has happened, entire inet:forward may be bypassed
> > 
> > By bypassed, do you mean that chain forward ruleset body becomes
> > irrelevant?
> 
> Yes.  It becomes irrelevant because the entire ip forward stack
> becomes irrelevant. Prerouting and postrouting hooks get skipped
> too, would you restore those as well?
> 
> > If the unfortunate answer is yes, than as in the original
> > report, once we are in the software fast path we do not do dscp
> > modification, right?
> 
> Yes. Its expected.  Entire IP stack is bypassed, including MTU
> checks, xfrm policy lookups and so on.
> 
> > Then once we hit the NF_FLOW_TIMEOUT, some of the packets will have dscp
> > modified, because we've went out of software acceleration. I.e. some of
> > the packets will arrive with and some without dscp. As you can imagine,
> > this could be hard to debug. This is the scenario that the patch series
> > tries to fix.
> > 
> > > 4. User ruleset needs to cope with packets being moved back to
> > >    software: fragmented packets, tcp fin/rst, hw timeouts and so on.
> > 
> > Should we require our user to understand that some lines in their
> > forward table configuration may or may not be executed sporadically?
> 
> Yes.  They have to understand the packet is handled in a *completely
> different* way, the IP stack is bypassed, including ipsec/xfrm policies,
> icmp checks, mtu checks, and so on.
> 
> This is also why the fastpath *must* push some packets back to
> normal plane: so that packet passes through ip_forward() which does
> all this extra work.
> 
> Some packets cannot be added to flowtable either even if user asks
> for it, e.g. when ip options are enabled.
> 
> > Should we give the user at least some kind of warning regarding this
> > during the ruleset load?
> 
> You could try to do this for the 'nft -f' case, but I doubt its worth
> it, see below for an example.
> 
> > To be constructive, isn't it better to rephrase points 3 and 4 as:
> > 
> > 3. once offload has happened, entire inet:forward will be executed with
> > the same semantics but with better performance. Any difference between
> > fast and slow path is considered a bug.
> 
> Err. no.  Because its impossible to do unless you stick a
> nf_hook_slow() call into the "fastpath", otherwise you will diverge
> from what normal path is doing.  And its still not the same,
> feature-wise, because we e.g. cache route info rather than per-packet
> lookup.
> 
> Flowtable software path is the *fallback* for when we don't have offload
> capable hardware, it bypasses entire ip forward plane and packets take
> a different, shorter code path, iff possible.
> 
> > 4. If something in user ruleset (such as dscp rule now) precludes fast
> > path optimization then either error will be given or slow path will be
> > taken with a warning.
> 
> Yes, nftables userspace could be augmented so that 'nft -f' could
> display a warning if there is a rule other than 'conntrack
> established,related accept' or similar as first line.
> 
> But I don't think its worth doing, f.e. someone could be doing
> selective offload based on src/dst networks or similar.
> 
> Updating/expanding flowtable documentation would be welcome of course.
> 
> > > Lets now consider existing netdev:ingress/egress in this same picture:
> > > (Example from Pablo):
> > > ------
> > > table inet filter {
> > >         flowtable f1 {
> > >                 hook ingress priority filter
> > >                 devices = { veth0, veth1 }
> > >         }
> > > 
> > >         chain ingress {
> > >                 type filter hook ingress device veth0 priority filter; policy accept; flags offload;
> > >                 ip dscp set cs3
> > >         }
> > > 
> > >         chain forward {
> > >                 type filter hook forward priority filter; policy accept;
> > >                 meta l4proto { tcp, udp, gre } flow add @f1
> > >                 ct state established,related accept
> > >         }
> > > }
> > > 
> > > Again, this has defined meaning in all combinations:
> > > With HW offload: veth0 will be told to mangle dscp.
> > > This happens in all cases and for every matching packet,
> > > regardless if a flowtable exists or not.
> > > 
> > > Same would happen for 'egress', just that it would happen at xmit time
> > > rather at receive time.  Again, its not relevant if there is active
> > > flowtable or not, or if data path is offloaded to hardware, to software,
> > > handled by fallback or entirely without flowtables being present.
> > > 
> > > Its also clear that this is tied to 'veth0', other devices will
> > > not be involved and not do such mangling.
> > > 
> > 
> > As I've mentioned in my other reply to Pablo, our focus is exclusively
> > on the *software* fast path of the forward chain. In this scenario
> > getting into additional nftables VM path in the ingress or egress seems
> > like pessimization which we'd like to avoid.
> 
> You will have to add a call to nf_hook_slow, or at very least to
> nft_do_chain...
> 
> netdev:in/egress is the existing plumbing that we have that
> allows for this, and I think that this is what should be used
> here.
> 
> > > Now lets look at your proposal:
> > > ----------------
> > > table inet filter {
> > >         flowtable f1 {
> > >                 hook ingress priority filter
> > >                 devices = { veth0, veth1 }
> > >         }
> > > 
> > >         chain forward {
> > >                 type filter hook forward priority filter; policy accept;
> > >                 ip dscp set cs3 offload
> > >                 ip protocol { tcp, udp, gre } flow add
> > >                 ct state established,related accept
> > >         }
> > > }
> > > ----------------
> > > 
> > > This means that software flowtable offload
> > > shall do a 'ip dscp set cs3'.
> > > 
> > > What if the flowtable is offloaded to hardware
> > > entirely, without software fallback?
> > > 
> > > What if the devices listed in the flowtable definition can handle
> > > flow offload, but no payload mangling?
> > > 
> > > Does the 'offload' mean that the rule is only active for
> > > software path?  Only for hardware path? both?
> > > 
> > > How can I tell if its offloaded to hardware for one device
> > > but not for the other?  Or will that be disallowed?
> > > 
> > > What if someone adds another rule after or before 'ip dscp',
> > > but without the 'offload' keyword?  Now ordering becomes an
> > > issue.
> > > 
> > > Users now need to consider different control flows:
> > > 
> > >   jump exceptions
> > >   ip dscp set cs3 offload
> > > 
> > >   chain exceptions {
> > >     ip daddr 1.2.3.4 accept
> > >   }
> > > 
> > > This won't work as expected, because offloaded flows will not
> > > pass through 'forward' chain but somehow a few selected rules
> > > will be run anyway.
> > > 
> > > TL;DR: I think that for HW offload its paramount to make it crystal
> > > clear as to which device is responsible to handle such rules.
> > 
> > Your critique of my offload flag is well deserved and fully correct,
> > thanks! The reason for the dscp statement offload flag was to try to be
> > explicit about the need for payload modification capture.
> > 
> > What we've really wanted to do here is to make the payload capture
> > dependent on the chain flowtable acceleration status. I.e. if the
> > forward chain is supposed to be accelerated, than the payload
> > modification capture should happen. Being lazy, I've went through that
> > ugly keyword path. Apologies for that.
> 
> > Yes. But again hardware offload is irrelevant for the problem we have
> > here.
> 
> Unfortunately its not, we cannot make waters murkier and just pretend
> HW offloads don't exist.  Behavior for "flags offload;" presence or
> absence should be identical (in absence of bugs of course).
> 
> > > I don't think mixing software and hardware offload contexts as proposed
> > > is a good idea, both from user frontend syntax, clarity and error reporting
> > > (e.g. if hw rejects offload request) point of view.
> > > 
> > 
> > Frontend syntax and nft userspace should not be affected once we drop
> > the unneeded offload flag on dscp statement.
> 
> So you propose to software-offload all mangle statements and
> prune all other rules...?
> 
> How is that any better than what we do now?
> 
> > > I also believe that allowing payload mangling from *software* offload
> > > path sets a precedence for essentially allowing all other expressions
> > > again which completely negates the flowtable concept.
> > 
> > IMHO, the flowtable concept means transparent acceleration of packet
> > processing between the specified interfaces. If something in the ruleset
> > precludes such acceleration warnings/errors should be given.
> > 
> > Do you agree?
> 
> It would be nice to give a warning but I don't think its feasible.
> Consider something like
> 
>  chain forward {
>   ip dscp set cs3
>   ct state established,related accept
>   ip saddr @should_offload_nets flow add @ft
>  }
> 
> Should this generate a warning?
> 
> Also, because of forward path bypass even if the ruleset is just doing:
> 
> ct state established,related
> ip saddr @can_offload flow add @ft
> 
> Packet flow is not the same as without "flow add" for a large swath of
> packets, as no prerouting or postrouting hooks are executed either.
> 
> > Once the goal of significant performance gains is preserved, the
> > expansion of the universe of accelerated expressions is benign. And why
> > not? We are still being fast.
> 
> I still think that my critique stands, pruning other rules and
> magically considering some while completely disregarding their context
> is not a good idea.
> 

I think I finally understand your reasoning. May I summarise it as the
following:

nftables chain forward having a flow add clause becomes a request from
the user to skip parts of Linux network stack. The affected flows will
become special and unaffected by most of the rules of the "slowpath"
chain forward. This is a sharp tool and user gets to keep both pieces
if something breaks :)

I agree that this is a well-defined and defensible position. I concur.

> Now, theoretically, you could add this:
> 
> chain fast_fwd {
> 	hook flowtable @f1 prio 0
> 	ip dscp set cs3
> }
> 

Yes, I really like that. Here is what such chain will do:

1. On the slow path it will behave identical to the forward chain.
2. The only processing done on fast_fwd fast path is interpretation
   of struct flow_offload_entry list (.
3. Such fast path is done between devices defined in flowtable f1
4. Apart from the interpretation of flow offload entries no other
   processing will be done.
5. (4) means that no Linux IP stack is involved in the forwarding.
6. However (4) allows concatenation of other flow_offload_entry
   producers (e.g. TC, ingress, egress nft chains).
7. flow_offload_entry lists may be connection dependent.
8. Similar to chain forward now, flow_offload_entry lists will be passed
   to devices for hardware acceleration.
9. IOW, flow_offload_entry lists become connection specific programs.
   Therefore such lists may be compiled to EBPF and accelerated on XDP.
10. flow_action_entry interpreters should be prepared to deal with IP
    fragments and other strangeness that ensues on our networks.

> Where this chain is hooked into the flowtable fastpath *ONLY*.

I don't fully understand the ONLY part, but do my points above address
this?

> 
> However, I don't like it either because its incompatible with
> HW offloads and we can be sure that once we allow this people
> will want things like sets and maps too 8-(

I think that due to point (8) above the potential for hardware
acceleration is higher. The hardware (e.g. switch) is free to pass
the packets between flowtable ports and not involve Linux stack at all.
It may do such forwarding because of the promise (4) above.

sets and maps are welcome in chain fast_fwd :) EBPF and XDP already have
them. Once (9) becomes reality we'll be able to suport them, somehow :)

> 
> > > I still think that dscp mangling should be done via netdev:ingress/egress
> > > hooks, I don't see why this has to be bolted into flowtable sw offload.
> > > 
> > Because it can be made faster :)
> 
> If you want to make software fastpath fast(er), explore a XDP program
> that can handle the post-offload packet funneling via xdp_frames to get rid of
> sk_buff allocation overhead.
> 
> Program should make upcalls to stack (costly) to get back to software
> and otherwise appear like HW offload-capable device from flowtable point
> of view.  Some parts of the flowtable infrastructure could probably be exposed
> via kfuncs so that certain functionality such as NAT doesn't have to be
> (re)implemented.
> 
> Requires lots of code churn in flowtable support code to get rid
> of sk_buff * arguments whereever possible.
> 
> There is also pending xmit_more support (skb trains/aggregation),
> perhaps it will land in 6.5 cycle.

I've incorporated XDP into my suggestion above. It seems to fit.

What do you think? Is going chain fast_fwd direction is feasible and
desirable?

Thanks,
Boris.

--0000000000007bd16005fb6d1353
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
ydoyIjshhiv/IkUwDQYJYIZIAWUDBAIBBQCggdQwLwYJKoZIhvcNAQkEMSIEIPChFsJT2hWUrKeR
tkmxyHywNjXMBbFLcsLXcy5G+7dqMBgGCSqGSIb3DQEJAzELBgkqhkiG9w0BBwEwHAYJKoZIhvcN
AQkFMQ8XDTIzMDUxMTE1NTk0MFowaQYJKoZIhvcNAQkPMVwwWjALBglghkgBZQMEASowCwYJYIZI
AWUDBAEWMAsGCWCGSAFlAwQBAjAKBggqhkiG9w0DBzALBgkqhkiG9w0BAQowCwYJKoZIhvcNAQEH
MAsGCWCGSAFlAwQCATANBgkqhkiG9w0BAQEFAASCAQCGgoyws8hOoi8L8EWUxOTnU2jchr1CoqeL
aYjngcGU55Mi2Z3YjynX6/k4/6PTQe9MVdLMKyUWklSDCTCz0fjtIuc8SSB5TFfShPgrFkfYyY4g
FYMPit+3gda6jafBrH2sjvKSquoM7eKOYOKK2nhpcdDBm0D3H0rzDqCWsXcxMp8+DahduC9BUGED
YvyuZiwxJW2pILlHyj6a2QdJYhUtEF8Z5lSSXTk8hVWOQBgDKomfXdvfxhKdwcGqkgydw7Jm6wqW
dldXkD1QMo2hsNveZi+O1erHPeCO0zCuzBFzvMoO52RZEEeaIk92bTN5MciL/RRp265la2TgLbhp
DKj7
--0000000000007bd16005fb6d1353--
