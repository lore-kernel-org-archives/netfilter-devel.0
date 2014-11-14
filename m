From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: Re: [ebtables-compat PATCH] build ebtables extensions
Date: Fri, 14 Nov 2014 16:57:55 +0100
Message-ID: <CAFpD06QGVOxxoTPxFjkezQ0n7OV9rRUNqdvdD6M+4hmsiKA=rg@mail.gmail.com>
References: <1415646188-2549-1-git-send-email-giuseppelng@gmail.com>
	<20141113113922.GA7619@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vc0-f175.google.com ([209.85.220.175]:63011 "EHLO
	mail-vc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161015AbaKNP54 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Nov 2014 10:57:56 -0500
Received: by mail-vc0-f175.google.com with SMTP id hy10so1004032vcb.20
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Nov 2014 07:57:55 -0800 (PST)
In-Reply-To: <20141113113922.GA7619@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I'd prefer if you put this patch in the ebtables-compat branch.
I'm going to finish the log extension for ebtables.

Thanks

2014-11-13 12:39 GMT+01:00 Pablo Neira Ayuso <pablo@netfilter.org>:
> On Mon, Nov 10, 2014 at 08:03:08PM +0100, Giuseppe Longo wrote:
>> This permits to build extensions for ebtables-compat layer.
>
> I can put this in the ebtables-compat branch if that makes it easier
> for you, but I would really like to see this patch in a small batch
> that at least introduces the first client of it.
>
> Thanks.
