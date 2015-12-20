From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: Re: Support of different targets in nftables
Date: Sun, 20 Dec 2015 16:05:10 +0530
Message-ID: <CAKHNQQFMPMTCs+z8twBUyANaLVjRo=zWaLOi66d5DXvuzGiFXA@mail.gmail.com>
References: <CAKHNQQEvQ9-RTOFjyrvonCZ-miiwucBcw_M+KufJ2yhjrK2a7g@mail.gmail.com>
 <20151220103416.GA1024@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f48.google.com ([74.125.82.48]:38110 "EHLO
	mail-wm0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754316AbbLTKfa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 20 Dec 2015 05:35:30 -0500
Received: by mail-wm0-f48.google.com with SMTP id l126so36568508wml.1
        for <netfilter-devel@vger.kernel.org>; Sun, 20 Dec 2015 02:35:30 -0800 (PST)
In-Reply-To: <20151220103416.GA1024@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Dec 20, 2015 at 4:04 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Sun, Dec 20, 2015 at 02:59:58PM +0530, Shivani Bhardwaj wrote:
>> Hi,
>>
>> While doing the translations, I see that iptables-translate is able to
>> produce output only for the target ACCEPT. For all others, it shows
>>
>> nft # <rules>
>>
>> Why is it so?
>
> This tool you're working on was a proof-of-concept and it incomplete.
>
> So get ready to find incomplete stuff and bugs in it, please, in case
> you find issues, you don't have to ask, you can just send a patch to
> fix them.
>

Alright.
Thank you

> Thank you.
