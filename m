From: Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: Re: [nft PATCH 1/4] monitor: Fix printing of range elements in named sets
Date: Fri, 14 Jul 2017 11:03:14 +0200
Message-ID: <CAOkSjBghB8wyuVqew4McttZj0+k8GsuRkLaF-=+73=H1aeR7kw@mail.gmail.com>
References: <20170712123658.25363-1-phil@nwl.cc> <20170712123658.25363-2-phil@nwl.cc>
 <CAOkSjBhX1=DJuY9M8P0axCQkMyjZyweea9tROnGSHM=WqRq47A@mail.gmail.com>
 <20170712190545.GC16375@orbyte.nwl.cc> <20170713182202.GK16375@orbyte.nwl.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Phil Sutter <phil@nwl.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-it0-f48.google.com ([209.85.214.48]:37757 "EHLO
        mail-it0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751367AbdGNJDk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 14 Jul 2017 05:03:40 -0400
Received: by mail-it0-f48.google.com with SMTP id m84so18061196ita.0
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Jul 2017 02:03:40 -0700 (PDT)
Received: from mail-it0-f46.google.com (mail-it0-f46.google.com. [209.85.214.46])
        by smtp.gmail.com with ESMTPSA id r2sm1234ita.25.2017.07.14.02.03.39
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 14 Jul 2017 02:03:39 -0700 (PDT)
Received: by mail-it0-f46.google.com with SMTP id m68so15800926ith.1
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Jul 2017 02:03:39 -0700 (PDT)
In-Reply-To: <20170713182202.GK16375@orbyte.nwl.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 13 July 2017 at 20:22, Phil Sutter <phil@nwl.cc> wrote:
> There are so many different cases, I actually started drawing flow
> diagrams (can't remember when I did that last time). In addition to what
> we discussed already, I realized that via 'nft -f', I can make multiple
> changes to even different sets within a single transaction - this
> requires dealing with cached half-open ranges everywhere, not just in
> NEWGEN callback. Another trap is 'nft flush set': The elements are
> reported in reverse order. Anyway, I have something that seems to work
> but needs quite some cleanup before I dare to publish it. :)
>

In an ideal world, we would detect these 'flush x' calls and print
just that, instead
of every single object being deleted.
I.e. flush ruleset --> monitor prints 'flush ruleset' instead of every
single object in the
ruleset being deleted.

But at this point, I think that going this way would increase
complexity in this code a lot.
Better fix by now the broken things we have.

> I should probably look into ways to write tests for this to get all the
> cases covered.
>

Indeed, but if your --echo functionality is going to use the very same
code path, then we should wait for it,
because testing the monitor thing is not that easy (async output).
The --echo output is sync with the command you call, so you can simply
check the output.

Once the code is in place, this is a good task for one of our
students/interns in GSoC-like programs.
