Return-Path: <SRS0=BUQT=24=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EDC2C282DD
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Jan 2020 23:10:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D927720715
	for <netfilter-devel@archiver.kernel.org>; Tue,  7 Jan 2020 23:10:10 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ViI6KQkN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727198AbgAGXKK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 7 Jan 2020 18:10:10 -0500
Received: from mail-io1-f51.google.com ([209.85.166.51]:36025 "EHLO
        mail-io1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727074AbgAGXKK (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 7 Jan 2020 18:10:10 -0500
Received: by mail-io1-f51.google.com with SMTP id d15so1194233iog.3
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Jan 2020 15:10:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=xhiHFf0OfpAWjDM8ip/3ELcAJo5BysOLPOydQm/qH9A=;
        b=ViI6KQkNEiArEy1zfWPsTDKQvl9n+O9zA5L81kbhgg9ebBoi+90Z7ly3NuHlEJlwmo
         uucclrtjZ2jiekR1m1Y2pa8hcbe2id3vnRYrgLWMh9rT+X4O4rZOP7KGWv+z14NvrsTV
         zUYJ2B+fekTO6Is2aB3utPnuond7ftTqsBMX10viVzFeGhzjG3nv35ngJc5qXxbvp69M
         32oo157DsDasA/VIR+fBU/EtdDr7Z+lfHX7m+AKJSv1ADM95PPQXYujPMlfnv5lvMkt8
         oJiLttlUuJE58z7l0ymSNp9sbLgKGIj+I1c40t179AxfB3Zthv9eZ/MCaCHF8lI3Xel5
         d6cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=xhiHFf0OfpAWjDM8ip/3ELcAJo5BysOLPOydQm/qH9A=;
        b=VkHQjtHblKyDSE5nXLCjlqcuS1dc+UnYQ5EQcv0NsePBTUevRWc84oGgg+OU69019q
         2SNOKIPi0cdXJFaPM6FzmC6ejGkjXfpWwgUM7Rx5WkoWOe6lLxYMRnRZRsaHgFO7rOss
         hc14IdM0gMv0yjjhTsjjUrUJnhmz6xl3ELCI9hvNZ+dscGHQKhOBzI61PnbJ23E1+gOt
         Q3llJGaqAesqDiFYSyO8nJsU+i0x6aRkNDNX4Gg8nPsk8XAjf1dtTMBAp9oWi4hY/yG5
         4qoM+tqxOUCNPBfEYCYPngVI/3GTzIhPBqxOxA8Xoaa2s9gIlv4akDWIxxYvjQF+4Q+j
         PF0g==
X-Gm-Message-State: APjAAAU9fY7s2jbEUZKCnVxspR9Vg5JuZXzDLbYtmEMSTJAeytR5QQNh
        5qd2/hHoevC9F3AXnG6sIn3LFRmJzHKRTigwF6Q=
X-Google-Smtp-Source: APXvYqyAoReH7ORqggixO/HJWCUihHJowyaVeqXLKGDnuBx37fXryiYg7DqIosedeR3IMpfpggO+rjKI8dm/lvWjQhI=
X-Received: by 2002:a6b:700e:: with SMTP id l14mr1213043ioc.170.1578438609497;
 Tue, 07 Jan 2020 15:10:09 -0800 (PST)
MIME-Version: 1.0
References: <CAA0dE=UFhDmAnoOQpR33S59dP_v3UVrkX29YMJyqOYc3YF1FPA@mail.gmail.com>
 <rXj5-pS3LGR5qqyPp6xyNkKoDz7cWKa6q9fqsenNu9fsf2erlDbUoOMSB05wwuiBNeQYOwF1VkItgADSmURnjNeV0JRV7n8x_bG4gk1fR8w=@o-t.ch>
In-Reply-To: <rXj5-pS3LGR5qqyPp6xyNkKoDz7cWKa6q9fqsenNu9fsf2erlDbUoOMSB05wwuiBNeQYOwF1VkItgADSmURnjNeV0JRV7n8x_bG4gk1fR8w=@o-t.ch>
From:   Alberto Leiva <ydahhrk@gmail.com>
Date:   Tue, 7 Jan 2020 17:09:58 -0600
Message-ID: <CAA0dE=Vs4u9ULcgJoxcf-V8eNc3Y11RQYeqC+KkKuQodqLj5Pg@mail.gmail.com>
Subject: Re: Adding NAT64 to Netfilter
To:     Laurent Fasnacht <lf@o-t.ch>
Cc:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi!

> In regards to the iptables approach, do you have any benchmark
> compared to the NAT in the same stack?

I think we do, but they are old to the point of pointlessness. But we
can allocate some testing efforts in February, if you would confirm
the desirability of this information.

> In regards to the nftables approach, do you mean to integrate the RFC
> implementations natively into the nftables infrastructure?

I would say "yes," but I'm not sure we mean the same thing.

Jool is currently a box of translating code that interfaces with the
kernel by way of wrappers.

ie. The Netfilter wrapper receives packets by registering itself to
nf_register_hooks(), and the iptables wrapper receives packets by
registering itself to xt_register_targets().

What I mean by integrating Jool into nftables is to create a wrapper
that would receive packets by means of something like
nft_register_expr(). (I'm not entirely sure this is what I'm supposed
to do because I haven't started analyzing this task yet. But that
would be my starting point.)

Does this answer your question?

> Checking your code, it seems that you use several user space tools
> (jool, joold) and a conntrack-like table to store the connection data.
> As you know, in the nftables project it has been done a great effort
> to avoid several tools for packet mangling so something natively like
> the following would be probably required.

I'm not averse to the idea of adapting code to fulfill the standards
of the Netfilter project. Jool's core itself has naturally changed
substantially over the years to account for emerging RFCs and feature
requests. It wouldn't be my first major overhaul.

But I admit I don't presently understand how things like the EAM table
([0] [1]) are meant to fit in this model.

(Then again, I don't know much about nftables just yet.)

[0] https://jool.mx/en/eamt.html
[1] https://jool.mx/en/usr-flags-eamt.html

> That's really great news! We (ProtonVPN) will be following the project, a=
nd will be glad to help if possible.

Thank you! :)

On Tue, Jan 7, 2020 at 8:14 AM Laurent Fasnacht <lf@o-t.ch> wrote:
>
> Hello,
>
> =E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90 Original =
Message =E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90=E2=80=90
> On Friday, January 3, 2020 7:09 PM, Alberto Leiva <ydahhrk@gmail.com> wro=
te:
>
> > Hello
> >
>
> > I've been working on Jool, an open source IP/ICMP translator for a
> > while ([0]). It currently implements SIIT, NAT64 and (if everything
> > goes according to plan) will later this year also support MAP-T. It
> > currently works both as a Netfilter module (hooking itself to
> > PREROUTING) or as an xtables target, and I'm soon going to start
> > integrating it into nftables.
>
> That's really great news! We (ProtonVPN) will be following the project, a=
nd will be glad to help if possible.
>
> Cheers,
>
> Laurent
> ProtonVPN R&D
