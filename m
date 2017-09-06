From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [nft PATCH RFC] Convert man page source to asciidoc
Date: Wed, 6 Sep 2017 13:53:19 +0200 (CEST)
Message-ID: <nycvar.YFH.7.76.1709061344490.3249@n3.vanv.qr>
References: <20170906084105.10915-1-phil@nwl.cc> <CAOkSjBhAxw8KxyQrBbCfBE9kQb--4HY39Qoi0jvf-ybwc1y=8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a3.inai.de ([88.198.180.161]:57366 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753268AbdIFLxU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2017 07:53:20 -0400
In-Reply-To: <CAOkSjBhAxw8KxyQrBbCfBE9kQb--4HY39Qoi0jvf-ybwc1y=8Q@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2017-09-06 11:56, Arturo Borrero Gonzalez wrote:
>
>Regarding the separation of text in different includes, why not creating
>different manpages? Netfilter did this in the past with iptables(8) and
>iptables-extensions(8).

The split into iptables-extensions.8 happened not because of size or topic, but
because iptables.8 and ip6tables.8 had redundant copies of numerous sections of
each other, and they sometimes were quite small sections too (for this reason,
it only has 9 manuals in total, not 96).

>Brainstorming:
>* nft-performance(8) <--- concrete info about nftables sets, maps,
>dicts, concatenations, etc.

those seem more like "datatypes" than "performance".
