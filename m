Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D30AEC433FE
	for <netfilter-devel@archiver.kernel.org>; Mon, 21 Nov 2022 11:31:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230407AbiKULbE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 21 Nov 2022 06:31:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231189AbiKULae (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 21 Nov 2022 06:30:34 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89DD9B406D
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Nov 2022 03:24:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669029849;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BjEw36bXi85sXmvx8WXvPA5S+SO2drdBDOhrdyLq1p4=;
        b=T0O9iJ630ff+TWw1BVVIfnRWxw4wfgwFkkhUlzmaA9G/pUSw4tclYOPbJ3c1T1ne+g09Sz
        XNkPA7eHS2+tngyxoKxiYxBe5/g4qCKakuhCp20EO/mZnUEqEHEr4EDFoJnbyXxWtNKf1Z
        6NMuiSlkTAq6w26T9quPYu1l+ImSGCs=
Received: from mail-il1-f198.google.com (mail-il1-f198.google.com
 [209.85.166.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-364-lsnhm8x2PBmQwErzVOrQlA-1; Mon, 21 Nov 2022 06:24:08 -0500
X-MC-Unique: lsnhm8x2PBmQwErzVOrQlA-1
Received: by mail-il1-f198.google.com with SMTP id i26-20020a056e021d1a00b003025434c04eso8386658ila.13
        for <netfilter-devel@vger.kernel.org>; Mon, 21 Nov 2022 03:24:08 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:in-reply-to
         :mime-version:references:from:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=BjEw36bXi85sXmvx8WXvPA5S+SO2drdBDOhrdyLq1p4=;
        b=h6B+IcSlY8AxPZiojFWAsPPhseEDsZNHJMHIhkSktmkHXbgaSAiAX+LhgcX8FPTCUL
         Ft4qGuEN38zlB21h/10dcL3z6QQ7CTAXEWpg5jhbb4wo4qM4NqjFuLuttVM2k8/V7+fk
         YwZY//AjCkvhaERF2xoYCdRrghj2OTFCXP5b3UhqF0VmCmKK1EKF1lOeM2YsD5t9JN3k
         lM/4czOUj7vT4yQVe0ZXg2KVUYF5oDCGjC9O6qqC07SkjmQd/NWFoSvf8pR5VVXCTGas
         5UQIrm1YQXd0H0IFKGkPLw8glBFhfYfPZ9xYloX/gizX4OyoB3RZ61zGeZvUrr+4iqJB
         NY7w==
X-Gm-Message-State: ANoB5plW4BB/6j1y5T9Nz5uY8cGqdXBxXa2ut83BGhAARF2H7d58c3Uw
        ZZZwoAofM3Y8AdIHinS+/nA2D03dUts73p3WnG7Qct7TcwprFRBMmTNp/8GfVVnPY0WcWVBZ3D6
        fK1oUT6yyB+XpoAeWcjxvxiG5iGnTt3dYa1jgb+18iwIB
X-Received: by 2002:a05:6638:1a98:b0:375:61b2:825a with SMTP id ce24-20020a0566381a9800b0037561b2825amr8275911jab.147.1669029847385;
        Mon, 21 Nov 2022 03:24:07 -0800 (PST)
X-Google-Smtp-Source: AA0mqf7xesGR7vWa3HrXHpa2GmhgOS3R/opRsNXU3vsIyJ31lZcK7BQdg4O3eaAYzDiuwFNeFBdKep57WxiZAvYVo2A=
X-Received: by 2002:a05:6638:1a98:b0:375:61b2:825a with SMTP id
 ce24-20020a0566381a9800b0037561b2825amr8275899jab.147.1669029847075; Mon, 21
 Nov 2022 03:24:07 -0800 (PST)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Mon, 21 Nov 2022 13:24:06 +0200
From:   Marcelo Ricardo Leitner <mleitner@redhat.com>
References: <20221030122541.31354-1-sriram.yagnaraman@est.tech>
 <20221030122541.31354-2-sriram.yagnaraman@est.tech> <20221031083858.GB5040@breakpoint.cc>
 <7c24bfe4-94be-6eab-d30a-6dc0500652da@est.tech> <20221102140025.GF5040@breakpoint.cc>
 <4ed54d0a-0e5e-0e58-7877-752b3b4ce3ab@est.tech>
MIME-Version: 1.0
In-Reply-To: <4ed54d0a-0e5e-0e58-7877-752b3b4ce3ab@est.tech>
Date:   Mon, 21 Nov 2022 13:24:06 +0200
Message-ID: <CALnP8ZaD5UEsf+4WT38p7Af62r4rk=-w17VzG24tZWv2TFBURw@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] netfilter: conntrack: introduce no_random_port
 proc entry
To:     Sriram Yagnaraman <sriram.yagnaraman@est.tech>
Cc:     Florian Westphal <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        kernel test robot <lkp@intel.com>,
        "claudio.porfiri@ericsson.com" <claudio.porfiri@ericsson.com>,
        lxin@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Nov 03, 2022 at 08:02:08PM +0000, Sriram Yagnaraman wrote:
> On 2022-11-02 15:00, Florian Westphal wrote:
>
> > Sriram Yagnaraman <sriram.yagnaraman@est.tech> wrote:
> >> On 2022-10-31 09:38, Florian Westphal wrote:
> >>
> >>> sriram.yagnaraman@est.tech <sriram.yagnaraman@est.tech> wrote:
> >>>> From: Sriram Yagnaraman <sriram.yagnaraman@est.tech>
> >>>>
> >>>> This patch introduces a new proc entry to disable source port
> >>>> randomization for SCTP connections.
> >>> Hmm.  Can you elaborate?  The sport is never randomized, unless eithe=
r
> >>> 1. User explicitly requested it via "random" flag passed to snat rule=
, or
> >>> 2. the is an existing connection, using the *same* sport:saddr -> dad=
dr:dport
> >>>    quadruple as the new request.
> >>>
> >>> In 2), this new toggle prevents communication.  So I wonder why ...
> >> Thank you so much for the detailed review comments.
> >>
> >> My use case for this flag originates from a deployment of SCTP client
> >> endpoints on docker/kubernetes environments, where typically there exi=
sts
> >> SNAT rules for the endpoints on egress. The *user* in this case are th=
e
> >> CNI plugins that configure the SNAT rules, and some of the most common
> >> plugins use --random-fully regardless of the protocol.
> >>
> >> Consider an SCTP association A -> B, which has two paths via NAT A and=
 B
> >> A: 1.2.3.4:12345
> >> B: 5.6.7.8/9:42
> >> NAT A: 1.2.31.4 (used for path towards 5.6.7.8)
> >> NAT B: 1.2.32.4 (used for path towards 5.6.7.9)
> >>
> >>               =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=90   =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=90
> >>            =E2=94=8C=E2=94=80=E2=94=80=E2=96=BA NAT A =E2=94=9C=E2=94=
=80=E2=94=80=E2=94=80=E2=96=BA   =E2=94=82
> >>  =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=90   =E2=
=94=82  =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=98   =E2=94=82   =E2=94=82
> >>  =E2=94=82  A  =E2=94=9C=E2=94=80=E2=94=80=E2=94=80=E2=94=A4          =
    =E2=94=82 B =E2=94=82
> >>  =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=98   =E2=
=94=82  =E2=94=8C=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=
=94=80=E2=94=90   =E2=94=82   =E2=94=82
> >>            =E2=94=94=E2=94=80=E2=94=80=E2=96=BA NAT B =E2=94=9C=E2=94=
=80=E2=94=80=E2=94=80=E2=96=BA   =E2=94=82
> >>               =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=80=E2=94=80=
=E2=94=80=E2=94=80=E2=94=98   =E2=94=94=E2=94=80=E2=94=80=E2=94=80=E2=94=98
> >>
> >> Let us assume in NAT A (1.2.31.4), the connections is setup as
> >> 	ORIGINAL TUPLE		    REPLY TUPLE
> >> 1.2.3.4:12345 -> 5.6.7.8:42, 5.6.7.8.42 -> 1.2.31.4:33333
> >>
> >> Let us assume in NAT B (1.2.32.4), the connections is setup as
> >> 	ORIGINAL TUPLE		    REPLY TUPLE
> >> 1.2.3.4:12345 -> 5.6.7.9:42, 5.6.7.8.42 -> 1.2.32.4:44444
> >>
> >> Since the port numbers are different when viewed from B, the associati=
on
> >> will not become multihomed, with only the primary path being active.
> >> Moreover, on a NAT/middlebox restart, we will end up getting new ports=
.
> >>
> >> I understand this is a problem in the way SNAT rules are configured, m=
y
> >> proposal was to have this flag as a means of preventing such a problem
> >> even if the user wanted to.
> > Ugh, sorry, but that sounds just wrong.
>
> Ok, I hear that. :)
>
> >
> >>>> As specified in RFC9260 all transport addresses used by an SCTP endp=
oint
> >>>> MUST use the same port number but can use multiple IP addresses. Tha=
t
> >>>> means that all paths taken within an SCTP association should have th=
e
> >>>> same port even if they pass through different NAT/middleboxes in the
> >>>> network.
> > Hmm, I don't understand WHY this requirement exists, since endpoints
> > cannot control source port (or source address) seen by the peer;
> > NAT won't go away.
> >
> > I read that snippet several times and its not clear to me if
> > "port number" refers to sport or dport.  Dport would make sense to me,
> > but sport...?  No, not really.
>
> I am just an interpreter of the standard but AFAIU, port means both sourc=
e
> and destination port. Section 1.3 of RFC 9260 defining an SCTP endpoint.
> In any case, running SCTP on UDP is probably the best way to workaround
> the SCTP NAT problem.
>
> >
> > Won't the endpoints notice that the path is down and re-create the flow=
?
> >
> > AFAIU the root cause of your problem is that:
> > 1. NAT middleboxes remap source port AND
> > 2. NAT middleboxes restart frequently
> >
> > ... so fixing either 1 or 2 would avoid the problem.
> >
> > I don't think adding sysctls to override 1) is a sane option.
>
> Yeah the endpoints does try to re-create the flows, but if we have
> multiple middle boxes remapping the source port, there is no guarantee
> that they will remap to the same source port.
> 1) is the main problem that I was trying to address with this patch.
>
> >> Since the flag is optional, the idea is to enable it only on hosts tha=
t
> >> are part of docker/kubernetes environments and use NAT in their datapa=
th.
> > We can't fix the ruleset but we can somehow cure it via sysctl in each =
netns?
> > I don't like this.
> >
> > NAT middlebox restart with --random is a problem in any case, not just
> > for SCTP, because the chosen "random port" is lost.
> >
> > I don't see a way to fix this, unless NOT using --random mode.
> > If connection is subject to sequence number rewrite (for tcp)
> > the connection won't survive either as the sejadj state is lost.
>
> Ok, I understand your point. I agree it doesn't make sense to have an
> alternative configuration option to avoid this problem. I will try to
> convince the "users" if --random-fully is not used for SCTP.

FWIW I share Florian's opinion here. With the explanations above, it
doesn't make sense to have an override in kernel for an option that
userspace is supplying at will.

  Marcelo

