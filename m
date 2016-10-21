From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: Re: [RFC nf-next PATCH] netfilter: nf_conntrack_proto_tcp: propagate IP_CT_TCP_FLAG_BE_LIBERAL
Date: Fri, 21 Oct 2016 09:15:24 +0200
Message-ID: <CAOkSjBj-Tyc90ph8-tEt9Ux07ZeCRBETnBNVCyL9RLXiByUHhA@mail.gmail.com>
References: <147695370184.31999.2434286995020619745.stgit@nfdev2.cica.es> <20161020181424.GA10898@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>, mat999@gmail.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:35357 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754601AbcJUHPs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 21 Oct 2016 03:15:48 -0400
Received: by mail-lf0-f67.google.com with SMTP id x79so4074187lff.2
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Oct 2016 00:15:47 -0700 (PDT)
Received: from mail-lf0-f48.google.com (mail-lf0-f48.google.com. [209.85.215.48])
        by smtp.gmail.com with ESMTPSA id s10sm198694lja.26.2016.10.21.00.15.46
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 21 Oct 2016 00:15:46 -0700 (PDT)
Received: by mail-lf0-f48.google.com with SMTP id b81so124429896lfe.1
        for <netfilter-devel@vger.kernel.org>; Fri, 21 Oct 2016 00:15:46 -0700 (PDT)
In-Reply-To: <20161020181424.GA10898@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 20 October 2016 at 20:14, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> There is a 'TCPWindowTracking' option that you can set on from the
> configuration file.
>
> Is that probably what Mathew needs?

@Mathew, could you please share what are your problems with this
conntrackd code?


/* disable TCP window tracking for recovered connections if required */
if (nfct_attr_is_set(ct, ATTR_TCP_STATE)) {
    uint8_t flags = IP_CT_TCP_FLAG_SACK_PERM;

    if (!CONFIG(sync).tcp_window_tracking)
        flags |= IP_CT_TCP_FLAG_BE_LIBERAL;
    else
        flags |= IP_CT_TCP_FLAG_WINDOW_SCALE;
[...]
