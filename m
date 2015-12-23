From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: Re: [PATCH] extensions: libxt_NFLOG: Add group_info and remove
 multiple keywords
Date: Wed, 23 Dec 2015 15:44:45 +0530
Message-ID: <CAKHNQQGvT1do47XXq5U-5SQwetrDWpnwSDDqthj19xU_zL_bqQ@mail.gmail.com>
References: <20151222200246.GA11677@gmail.com> <20151223101333.GA3026@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f44.google.com ([74.125.82.44]:34984 "EHLO
	mail-wm0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932485AbbLWKPG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Dec 2015 05:15:06 -0500
Received: by mail-wm0-f44.google.com with SMTP id l126so141826440wml.0
        for <netfilter-devel@vger.kernel.org>; Wed, 23 Dec 2015 02:15:05 -0800 (PST)
In-Reply-To: <20151223101333.GA3026@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 23, 2015 at 3:43 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Wed, Dec 23, 2015 at 01:32:46AM +0530, Shivani Bhardwaj wrote:
>> Add group_info with every rule as it is mandatory to consider logging to
>> be same type as NFLOG.
>> Remove multiple log keywords to avoid loading multiple log expressions
>> at a time.
>>
>> Examples:
>>
>> $ sudo iptables-translate -I INPUT -j NFLOG --nflog-threshold 2
>> nft insert rule ip filter INPUT counter log queue-threshold 2 group 0
>>
>> $ sudo iptables-translate -A FORWARD -j NFLOG --nflog-group 32 --nflog-prefix "Prefix 1.0"
>> nft add rule ip filter FORWARD counter log prefix \"Prefix 1.0\" group 32
>
> Applied, thanks Shivani.
>
> BTW, it's a good practise to credit people that report problems, ie.
> add this tag:
>
> Reported-by: Arturo Borrero <arturoborreroglez@gmail.com>
>

I didn't know it before. Thanks. I'll take care next time.

>> Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
>
