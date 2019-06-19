Return-Path: <SRS0=ZPov=US=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 635EEC31E49
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Jun 2019 06:50:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 28C0B2084A
	for <netfilter-devel@archiver.kernel.org>; Wed, 19 Jun 2019 06:50:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MTaw1kZV"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730758AbfFSGug (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 19 Jun 2019 02:50:36 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:36964 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbfFSGug (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 19 Jun 2019 02:50:36 -0400
Received: by mail-ed1-f68.google.com with SMTP id w13so25532709eds.4
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Jun 2019 23:50:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+Qxmv6bTThH3GiHUEdHkY0cM3KiIKB6WcAc/1NTj1r4=;
        b=MTaw1kZVbix4K7cLc5VG0oNdzLqMDC/FikHI/HlCYQKsaSdboirrAuo/uIXU2awBDk
         ZvJ0q2Y5kylOJV/mmuYFD5stObkhv8YpXAODCJIUS/grE9fvr3baRTZ7Gopacl5ztUHi
         88wASog1vpvm/m3/LviTLYi6Ev1+11+nRZYTUWwoxYVlp07Pt8QjEBYvZDkXdOhOk4QV
         +5DudxWWhm5DV9n9A2TmVAsBA+f5+F6HY0rlmR4bFBcSB7FTW55QqljUFujYZgvpHaS4
         LKug2bXDuZNeKla2Eyr/0Lwm+jctYiUtBjlRsPOZPEqYbKDF/lQQKDs6evrtYsaUGRW2
         bFcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+Qxmv6bTThH3GiHUEdHkY0cM3KiIKB6WcAc/1NTj1r4=;
        b=oqHhP3WtdERCOsXDN9G3KYyO5PgtQELCDLiusFWG2s8xe6AJJ3uBLVBL2xlimJf3K2
         DIEm01ExNsjzPBu1aC0t/zfHBKBS7O92WjpWe7X3KqYEvDf7hZ+GK876LL5k22lAsI4w
         GKg5GF9Hg9sSXPDMqJzSTBj6IG9Xz8hM45WZL0iaktHIaLoaYqxNbAEIpwrHMhs+9PKL
         8MMgDarkeeMhl1Shg9JjyzGqFkY4YpMC6WRUfAXMrpgMuCVpImeCsvAjhFX7ptZyESgw
         z1TqvsKd3opRUPQrYQrn8Mu/8MZGlPFLf8tyo7tQNEfUorCSjwsfUMEBVYjY6wh548IC
         dCLQ==
X-Gm-Message-State: APjAAAXnB0jGYe/cG4gMginDQ63C0kg2xHOYWSVc+hgbdOHgGqi0dhiW
        eIe/NCfmOV3anaEjRd8+5VFUgjHtgw+RMF2U5h5RmR2mtvU=
X-Google-Smtp-Source: APXvYqyMSnESCVf/6bXKTfsJgaFk/YZQDl9fscMtTgzoRVGXWUat2Ku2Vyk8GGm+b8uQH9mK7ZMWQXn9rC1J3+40KuQ=
X-Received: by 2002:a50:92e1:: with SMTP id l30mr37606150eda.141.1560927034607;
 Tue, 18 Jun 2019 23:50:34 -0700 (PDT)
MIME-Version: 1.0
References: <CABVi_Eyws89e+y_4tGJNybGRdL4AarHG6GkNB0d0MGgLABuv3w@mail.gmail.com>
 <20190618095021.doh6pc7gzah3bnra@breakpoint.cc> <CABVi_EyyV6jmB8SxuiUKpHzL9NwMLUA1TPk3X=SOq58BFdG9vA@mail.gmail.com>
 <20190618105613.qgfov6jmnov2ba3e@breakpoint.cc> <CABVi_ExMpOnaau6sroSXd=Zzc4=F6t0Hv5iCm16q0jxqp5Tjkg@mail.gmail.com>
 <20190618132350.phtpv2vhteplfj32@breakpoint.cc> <CABVi_Ey3cHVdnpzRFo_yPFKkPveXeia7WBV4S9iPxPotLkCpuQ@mail.gmail.com>
 <20190618140036.ydorhtj5mvjfwemz@breakpoint.cc>
In-Reply-To: <20190618140036.ydorhtj5mvjfwemz@breakpoint.cc>
From:   Mojtaba <mespio@gmail.com>
Date:   Wed, 19 Jun 2019 11:20:22 +0430
Message-ID: <CABVi_Ex=NiC-XmJz5FRuRp919eivwhjvSL3_k-PV-+F_2zd9ZA@mail.gmail.com>
Subject: Re: working with libnetfilter_queue and linbetfilter_contrack
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello,
Absolutely of course, i used exactly the same way in my test-case. I
added 200 entry in libnetfilter_conntrack for 200 concurrent call. In
reality i have to extract the address of media stream for both
endpoints in SIP-Proxy server then send them to user-space project in
another machine over TCP connection. Here is what i do in test-case
project. I have to change conntrack_create_nat.c like below:

int i = 10000;
int end = 30000
int MAX_CALL = 200;
int j = 10000 + (MAX_CALL*4-4);
while(i<=j) {

   nfct_set_attr_u8(ct, ATTR_L3PROTO, AF_INET);
   nfct_set_attr_u32(ct, ATTR_IPV4_SRC, inet_addr("192.168.133.140"));
         //endpoint A
   nfct_set_attr_u32(ct, ATTR_IPV4_DST, inet_addr("192.168.133.108"));

   //nfct_set_attr_u8(ct, ATTR_L4PROTO, IPPROTO_TCP);
   nfct_set_attr_u8(ct, ATTR_L4PROTO, IPPROTO_UDP);
   nfct_set_attr_u16(ct, ATTR_PORT_SRC, htons(6000));
   nfct_set_attr_u16(ct, ATTR_PORT_DST, htons(i));

   nfct_setobjopt(ct, NFCT_SOPT_SETUP_REPLY);

   //nfct_set_attr_u8(ct, ATTR_TCP_STATE, TCP_CONNTRACK_SYN_SENT);
   nfct_set_attr_u32(ct, ATTR_TIMEOUT, 200);

   nfct_set_attr_u32(ct, ATTR_SNAT_IPV4, inet_addr("192.168.133.108"));
   nfct_set_attr_u32(ct, ATTR_DNAT_IPV4,
inet_addr("192.168.133.150"));               //endpoint B

        nfct_set_attr_u16(ct, ATTR_SNAT_PORT, htons(i+2));
        nfct_set_attr_u16(ct, ATTR_DNAT_PORT, htons(6000));

   ret = nfct_query(h, NFCT_Q_CREATE, ct);
   i+=4;
   printf("TEST: create conntrack ");
   if (ret == -1)
      printf("(%d)(%s)\n", ret, strerror(errno));
   else
      printf("(OK)\n");
}

But I have to add  a rule in IPTABLE to not add any conntrack entry by
kernel, because as soos as the callee answer the call(received 200OK
SIP MESSAGE), it will start to send it's media (RTP).In this regards
it would create conntrack entry sooner than user-space.
iptables -A INPUT -p udp --dport 10000:30000 -j DROP
Is it right table to deny adding any conntrack entry or not?
Anyway i appreciate your guide. I was in dilemma to used
libnetfilter_conntrack or libnetfilter_queue. Thanks
WIth Best Regards.Mojtaba



On Tue, Jun 18, 2019 at 6:30 PM Florian Westphal <fw@strlen.de> wrote:
>
> Mojtaba <mespio@gmail.com> wrote:
> > Then let me describe what i am doing.
> > In VoIP networks, One of the ways to solve the one-way audio issue is
> > TURN. In this case both endpoint have to send their media (voice as
> > RTP) to server. In this conditions the server works as B2BUA. Because
> > of the server is processing the media (get media from one hand and
> > relay it to another hand), It usages a lot of resource of server. So I
> > am implementing  a new module to do this in kernel level. I test this
> > idea in my laboratory by adding conntrack entry manually in server and
> > all things works great. But i need to get more  idea to do this
> > project in best way and high performance, because the QoS very
> > importance in VoIP networks. What is the best way? Let me know more
> > about this.
>
> In that case I wonder why you need nfqueue at all.
>
> Isn't it enough for the proxy to inject a conntrack entry with the
> expected endpoint addresses of the media stream?
>
> I would expect that your proxy consumes/reads the sdp messages from
> the client already, or are you doing that via nfqueue?
>
> I would probably use tproxy+normal socket api for the signalling
> packets and insert conntrack entries for the rtp/media streams
> via libnetfilter_conntrack, this way, the media streams stay in kernel.



-- 
--Mojtaba Esfandiari.S
