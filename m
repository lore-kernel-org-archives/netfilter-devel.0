From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [nft PATH 01/16] libnftables: introduce library
Date: Sat, 19 Aug 2017 21:07:55 +0200 (CEST)
Message-ID: <nycvar.YFH.7.76.1708192106560.32657@n3.vanv.qr>
References: <20170816204310.3371-1-eric@regit.org>         <20170816204310.3371-2-eric@regit.org>         <20170817085750.GS16375@orbyte.nwl.cc> <1502989742.31564.5.camel@regit.org>         <20170817171350.GD10864@orbyte.nwl.cc>
 <1503132192.31564.17.camel@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Phil Sutter <phil@nwl.cc>, pablo@netfilter.org,
        netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a3.inai.de ([88.198.180.161]:43642 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751533AbdHSTH5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 19 Aug 2017 15:07:57 -0400
In-Reply-To: <1503132192.31564.17.camel@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2017-08-19 10:43, Eric Leblond wrote:

>>> Hence I defined a global init and deinit. But maybe it does not
>>> really make sense and could be attached to each context or init
>>> could be done at first usage.
>> 
>> My idea was to implement simple reference counting to see whether
>> the library was already initialized and whether it is safe to
>> deinit. Of course this needs some serialization for thread-safety.
>> 
>> Or maybe the deinit can be ignored completely and
>> nft_global_init() just has to check whether data is already
>> initialized or not.
>
>I have used numerous libraries providing a global init or deinit.
>For now we could easily skip it with your approach or another but I
>prefer we have it existing so it is available later in case of
>needs.

If a global init - more correctly, a singleton init - is needed,
can't it just implicitly be called from make_me_a_new_context()?
