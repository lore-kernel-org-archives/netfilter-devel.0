From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: Re: [RFC nf-next PATCH] netfilter: nf_conntrack_proto_tcp: propagate IP_CT_TCP_FLAG_BE_LIBERAL
Date: Fri, 21 Oct 2016 09:22:37 +0200
Message-ID: <CAOkSjBg0TE_LjA4xYnbRvf=BzRP8xGvJK+xOWDURHnqAmjCJSQ@mail.gmail.com>
References: <147695370184.31999.2434286995020619745.stgit@nfdev2.cica.es>
 <20161020181424.GA10898@salvia> <CAOkSjBj-Tyc90ph8-tEt9Ux07ZeCRBETnBNVCyL9RLXiByUHhA@mail.gmail.com>
 <CALFfGYaW3vaMmJ==gXqUATsmu5BWwZx8Aee8G8KknmVTySWrng@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Mathew Heard <mat999@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:35555 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755026AbcJUHW7 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Oct 2016 03:22:59 -0400
Received: by mail-lf0-f67.google.com with SMTP id x79so4104333lff.2
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Oct 2016 00:22:59 -0700 (PDT)
Received: from mail-lf0-f48.google.com (mail-lf0-f48.google.com. [209.85.215.48])
        by smtp.gmail.com with ESMTPSA id s127sm207145lja.14.2016.10.21.00.22.57
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Oct 2016 00:22:57 -0700 (PDT)
Received: by mail-lf0-f48.google.com with SMTP id x79so136235329lff.0
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Oct 2016 00:22:57 -0700 (PDT)
In-Reply-To: <CALFfGYaW3vaMmJ==gXqUATsmu5BWwZx8Aee8G8KknmVTySWrng@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

(please keep the netfilter-devel list in CC)

On 21 October 2016 at 09:18, Mathew Heard <mat999@gmail.com> wrote:
> That's been covered already.
>
> The problem with it is that only the ORIG side of the connection ends
> up set. REPLY does not.
>
> I don't know the fundamental reason why this occurs, only the effect.
>

In that same function, in conntrackd:
 http://git.netfilter.org/conntrack-tools/tree/src/netlink.c#n256

we set the same flags in both original and reply directions:

nfct_set_attr_u8(ct, ATTR_TCP_FLAGS_ORIG, flags);
nfct_set_attr_u8(ct, ATTR_TCP_MASK_ORIG, flags);
nfct_set_attr_u8(ct, ATTR_TCP_FLAGS_REPL, flags);
nfct_set_attr_u8(ct, ATTR_TCP_MASK_REPL, flags);
