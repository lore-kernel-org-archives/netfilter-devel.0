From: Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: Re: [nft PATCH RFC] Convert man page source to asciidoc
Date: Wed, 6 Sep 2017 11:56:37 +0200
Message-ID: <CAOkSjBhAxw8KxyQrBbCfBE9kQb--4HY39Qoi0jvf-ybwc1y=8Q@mail.gmail.com>
References: <20170906084105.10915-1-phil@nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:37008 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752351AbdIFJ5B (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2017 05:57:01 -0400
Received: by mail-wm0-f53.google.com with SMTP id u26so28964197wma.0
        for <netfilter-devel@vger.kernel.org>; Wed, 06 Sep 2017 02:57:00 -0700 (PDT)
Received: from mail-wm0-f46.google.com (mail-wm0-f46.google.com. [74.125.82.46])
        by smtp.gmail.com with ESMTPSA id p14sm1210673edj.21.2017.09.06.02.56.58
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 06 Sep 2017 02:56:58 -0700 (PDT)
Received: by mail-wm0-f46.google.com with SMTP id i145so27502063wmf.1
        for <netfilter-devel@vger.kernel.org>; Wed, 06 Sep 2017 02:56:58 -0700 (PDT)
In-Reply-To: <20170906084105.10915-1-phil@nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 6 September 2017 at 10:41, Phil Sutter <phil@nwl.cc> wrote:
> Beware: The conversion is incomplete and merely serves as base for
> discussion.
>
> This patch converts nft.xml into asciidoc markup, top down until (and
> including) stateful objects description. I stopped there because it's
> the first chance of demonstrating my idea of splitting the documentation
> into smaller pieces for convenience and maintainability.
>
> Regarding package dependencies, this "just" exchanges docbook with
> asciidoc - dblatex is still required for PDF creation.
>

Hi Phil,

thanks for your initiative and hard work, it's really appreciated :-)

Regarding the change, why asciidoc? why not markdown, or org-mode or
reStructuredText?
There are many markup languages, it reminds me to xkcd #927 [0].
I would prefer if we stick to groff, which seems to be the standard in Linux.

Regarding the separation of text in different includes, why not
creating different manpages?
Netfilter did this in the past with iptables(8) and iptables-extensions(8).

Brainstorming:
* nft(8) <-- main document, general info
* nft-ct(8) <-- concrete info for ct objects
* nft-counter(8) <-- concrete info for counter objets
* nft-flowtables(8) <-- about flow tables
* nft-quota(8) <--- concrete info for quotas
* nft-performance(8) <--- concrete info about nftables sets, maps,
dicts, concatenations, etc.
* nft-ha(8) <--- for HA environments, loadbalancing etc

[0] https://xkcd.com/927/
