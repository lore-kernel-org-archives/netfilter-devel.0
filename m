From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: Re: [nft RFC PATCH] rule: introduce new option to print set elements
 per line
Date: Tue, 25 Apr 2017 11:35:24 +0200
Message-ID: <CAOkSjBiEXbX9dOgRYu6Zyqmijc1DCksr1Zm7d+bcL+tNHZuyEg@mail.gmail.com>
References: <149277062417.14594.14270713486442491994.stgit@nfdev2.cica.es> <20170425092229.GA3577@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f48.google.com ([209.85.218.48]:33532 "EHLO
        mail-oi0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1428642AbdDYJfu (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Apr 2017 05:35:50 -0400
Received: by mail-oi0-f48.google.com with SMTP id y11so132615134oie.0
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 02:35:45 -0700 (PDT)
Received: from mail-oi0-f41.google.com (mail-oi0-f41.google.com. [209.85.218.41])
        by smtp.gmail.com with ESMTPSA id b32sm7187077ote.9.2017.04.25.02.35.44
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 25 Apr 2017 02:35:44 -0700 (PDT)
Received: by mail-oi0-f41.google.com with SMTP id x184so165667089oia.1
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 02:35:44 -0700 (PDT)
In-Reply-To: <20170425092229.GA3577@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 25 April 2017 at 11:22, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi Arturo,
>
> On Fri, Apr 21, 2017 at 12:30:24PM +0200, Arturo Borrero Gonzalez wrote:
>> Add a new option to nft to print set elements per line instead
>> of all in a single line.
>> This is useful when printing a ruleset with very big sets.
>>
>> The new option is -t/--elements.
>>
>> Annonymous sets/maps/concats are not affected by this. The default
>> behaviour is not changed.
>>
>> Example:
>>
>> % nft list ruleset -t -nn
>> table ip t {
>>       set s {
>>               type inet_service
>>               elements = { 1,
>>                               2,
>>                               3,
>>                               4,
>>                               12345 }
>
> Can we do a more intelligent folding? Via TIOCGWINSZ we can obtain the
> number of columns so we can try to fit as many elements as possible
> without wrapping around. Instead of one element per line? I know what
> I'm asking is harder, but I would like that we explore this path
> before adding this.
>
> And I think we should do this by default, no need for an option.
> Unless you are a robot, you want an output that you can actually read
> without lots of lines wrapping around, eg. a very large sets with
> thousands of elements.

Ok, by default then.

Regarding a more intelligent output, the complexity increases quickly,
since it would require to 'parse' the set before printing it (you
know, knowing the element printed length, the terminal window size, et
all). I guess that doing this right may slow down the output a lot,
similar to what happens in math programs outputs (gnu octave).

What about an intermediate way?

if integers, print 4 o 5 per line.
if maps, contactenations, IPs or strings, print one per line
