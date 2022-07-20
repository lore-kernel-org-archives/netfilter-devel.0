Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4788C43334
	for <netfilter-devel@archiver.kernel.org>; Wed, 20 Jul 2022 16:11:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235077AbiGTQL2 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 20 Jul 2022 12:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235734AbiGTQL1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 20 Jul 2022 12:11:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 3B8CE52FDC
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Jul 2022 09:11:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658333485;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iayvnZM03dpe+kI1ZskkB8ZTsM/BkAU/ZdUkJsOym4s=;
        b=Ijz4FC4WHUvMU/LrNav9pJYsIcNep4sRkedmna7EyXVzlzoB2dyrp6TZ5MWJ2Xlzug/7oH
        +egxwxoPjqLiT9/1rDYdL6rJHJcNiTyWZ8W2568vvmcffCXB5+2sUNP8q/geLlb/pSpmlA
        US6BbsC45JIb44KKmhxaicmfwPf2O88=
Received: from mail-ej1-f71.google.com (mail-ej1-f71.google.com
 [209.85.218.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-668-k8N8NhQVNIW8RgRIHxYcWw-1; Wed, 20 Jul 2022 12:11:23 -0400
X-MC-Unique: k8N8NhQVNIW8RgRIHxYcWw-1
Received: by mail-ej1-f71.google.com with SMTP id nb10-20020a1709071c8a00b006e8f89863ceso4267400ejc.18
        for <netfilter-devel@vger.kernel.org>; Wed, 20 Jul 2022 09:11:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=iayvnZM03dpe+kI1ZskkB8ZTsM/BkAU/ZdUkJsOym4s=;
        b=wk0eXYeZQQfXy+Shk3L1ltfITGgdbW4owkN2Z16lH9xXifIx/6Ji4t+4TI1urd9BiI
         SI21/hG9H98Nc/VIQH2OwQt/Tb1ZhbR33rIcUahrUX1tHy2OCV8PqDymHELlrClHl66E
         jduFnkHrrDzF+nrqZvluAmJymg8HU8dix8Q9ACF+xCK3ysKq/YInK3DWB5wXtq7ZQph7
         RZWZFaMUJtUzdXVQAAVpOgEtFVmbFubr5M1yX90RKe2jyUJVH5rC/PTAkGSsv4va2b/p
         ihaVnLtQQs/W4/PWE8kVMe2A7VnbqQ2rfbHjVwBl6HcrSSx2a3md+yE1Q5y3ZseqWcTr
         k3Eg==
X-Gm-Message-State: AJIora+5SYNfoU9RkSKu/kBCK7PxCqiLzvkNDdXwUa6BuMYW4zkh6jOD
        iWNaqsdLew6hHxEIKNKCI1ViKj8+jiKvEfacbO7JPFOKnBsOhHUdeDAoSoMuq1ZHeOU1vqYzu2g
        vpGyWQokh16sz1kDXGZp2x1oUVZ/a
X-Received: by 2002:a17:906:106:b0:715:7cdf:400f with SMTP id 6-20020a170906010600b007157cdf400fmr36507570eje.1.1658333481709;
        Wed, 20 Jul 2022 09:11:21 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vJMzOdRYh+GUEBZOaD8FlPaYN/XUIPZNMmKMx5lxcmWXSfiAE8dQyrv0AGpoImnMhilXQ0kQ==
X-Received: by 2002:a17:906:106:b0:715:7cdf:400f with SMTP id 6-20020a170906010600b007157cdf400fmr36507558eje.1.1658333481507;
        Wed, 20 Jul 2022 09:11:21 -0700 (PDT)
Received: from nautilus.home.lan (cst2-15-35.cust.vodafone.cz. [31.30.15.35])
        by smtp.gmail.com with ESMTPSA id w6-20020a50fa86000000b0043ba0cf5dbasm2809219edr.2.2022.07.20.09.11.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Jul 2022 09:11:21 -0700 (PDT)
Date:   Wed, 20 Jul 2022 18:11:19 +0200
From:   Erik Skultety <eskultet@redhat.com>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] iptables: xshared: Ouptut '--' in the opt field
 in ipv6's fake mode
Message-ID: <YtgpJ9FNZmmuniLV@nautilus.home.lan>
References: <bb391c763171f0c5511f73e383e1b2e6a53e2014.1658322396.git.eskultet@redhat.com>
 <20220720142002.GA22790@breakpoint.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220720142002.GA22790@breakpoint.cc>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jul 20, 2022 at 04:20:02PM +0200, Florian Westphal wrote:
> Erik Skultety <eskultet@redhat.com> wrote:
> > The fact that the 'opt' table field reports spaces instead of '--' for
> > IPv6 as it would have been the case with IPv4 has a bit of an
> > unfortunate side effect that it completely confuses the 'jc' JSON
> > formatter tool (which has an iptables formatter module).
> > Consider:
> >     # ip6tables -L test
> >     Chain test (0 references)
> >     target     prot opt source   destination
> >     ACCEPT     all      a:b:c::  anywhere    MAC01:02:03:04:05:06
> > 
> > Then:
> >     # ip6tables -L test | jc --iptables
> >     [{"chain":"test",
> >       "rules":[
> >           {"target":"ACCEPT",
> >            "prot":"all",
> >            "opt":"a:b:c::",
> >            "source":"anywhere",
> >            "destination":"MAC01:02:03:04:05:06"
> >           }]
> >     }]
> > 
> > which as you can see is wrong simply because whitespaces are considered
> > as a column delimiter.
> 
> Looks like ip6tables and iptables had this behaviour since day 1.
> original iptables:
> 
>        if (format & FMT_OPTIONS) {
>                if (format & FMT_NOTABLE)
>                        fputs("opt ", stdout);
>                fputc(fw->ip.invflags & IPT_INV_FRAG ? '!' :
>        		'-', stdout);
>                fputc(flags & IPT_F_FRAG ? 'f' : '-', stdout);
>                fputc(' ', stdout);
>        }
> 
> original ip6tables (5eed48af2516ebce0412121713d285bc30edb10d, June 2000):
>        if (format & FMT_OPTIONS) {
>                if (format & FMT_NOTABLE)
>                        fputs("opt ", stdout);
>                fputc(' ', stdout);
>                fputc(' ', stdout);
>                fputc(' ', stdout);
>        }
> 
> While I like the idea of making those two identical I'm not sure its
> worh the risk, we've hit bugs for a myriad of other reasons when making 
> seemingly innocent changes like this.

Hmm, the only reason why I submitted this change is because our libvirt test
suite suddenly started failing on CentOS Stream 9 and only on CS9. Now, the
test suite is flawed in its own way checking libvirt actions against iptables
CLI output (yes, very fragile), but at the time the tests were written there
essentially wasn't a programatic way of checking the changes like we could do
today with the nftables library and its JSON formatter.
So I investigated what's changed on CentOS Stream 9 compared to CS8 or Fedora
35/36 and it turned out that CS9 ships iptables-nft 1.8.8 while e.g. Fedora 36
ships 1.8.7 (so we're bound to failures there as well in the future).

Let me describe the output difference in between the 2 versions of iptables:

< v1.8.8
# ip6tables -L FI-tck-7081731
Chain FI-tck-7081731 (1 references)
target     prot opt source               destination
RETURN     icmpv6    f:e:d::c:b:a/127     a:b:c::d:e:f         MAC01:02:03:04:05:06 DSCP match 0x02 ipv6-icmptype 12 code 11 ctstate NEW,ESTABLISHED
    *** NOTE ^^HERE ***

>= v1.8.8
ip6tables -L FI-tck-7081731
Chain FI-tck-7081731 (1 references)
target     prot opt source               destination
RETURN     ipv6-icmp    f:e:d::c:b:a/127     a:b:c::d:e:f         MAC01:02:03:04:05:06 DSCP match 0x02 ipv6-icmptype 12 code 11 ctstate NEW,ESTABLISHED
      *** NOTE ^^HERE ***

If my detective work was correct it was caused by commit
b6196c7504d4d41827cea86c167926125cdbf1f3 which swapped the order of the
protocol keys in the 'xtables_chain_protos'.

If the protocol key order could be reverted back to its previous state then
essentially it doesn't matter much to libvirt whether this patch lands in or
not (well, it would have to be downstreamed to both CS9 and Fedora 36 anyway),
I'm just looking for ways to fix our test suite even though I'd like to make
use of a more programatic way of checking the chain rules, e.g. the JSON output
as we've had many breakages in this area over the past couple of years. Note
that the 'nft's JSON parser is currently not an answer for us in ^^this regard
as for some reason it doesn't format the iptables' module extension data like
the source MAC 01:02... you see above, but it does so when the rule was created
with the nft frontend - I'm going to file a bug about this.

Regards,
Erik

