From: Shivani Bhardwaj <shivanib134@gmail.com>
Subject: Re: [PATCH nft] src: evaluate: Show error for fanout without balance
Date: Thu, 7 Apr 2016 22:48:13 +0530
Message-ID: <CAKHNQQEiswUESDHaTAroCYRCwjPJDGD=9NzhWhJ4Uh=g0nLh-A@mail.gmail.com>
References: <20160407093640.GA5034@shivani> <20160407171317.GA6225@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:35710 "EHLO
	mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756543AbcDGRS7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Apr 2016 13:18:59 -0400
Received: by mail-oi0-f49.google.com with SMTP id p188so106949903oih.2
        for <netfilter-devel@vger.kernel.org>; Thu, 07 Apr 2016 10:18:54 -0700 (PDT)
In-Reply-To: <20160407171317.GA6225@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 7, 2016 at 10:43 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Thu, Apr 07, 2016 at 03:06:40PM +0530, Shivani Bhardwaj wrote:
>> The idea of fanout option is to improve the performance by indexing CPU
>> ID to map packets to the queues. This is used for load balancing.
>> Fanout option is not required when there is a single queue specified.
>>
>> According to iptables, queue balance should be specified in order to use
>> fanout, following that, throw an error in nftables if the range of
>> queues for load balancing is not specified with the fanout option.
>
> Curious, how does iptables behave when you pass fanout and a single
> queue?
>

It throws an error:

$ sudo iptables -A FORWARD -j NFQUEUE --queue-num 0 --queue-cpu-fanout
iptables v1.6.0: NFQUEUE: option "--queue-cpu-fanout" also requires
"--queue-balance".

Try `iptables -h' or 'iptables --help' for more information.

Since, queue-balance is done as queue num with a range in nftables, I
thought it should follow the same routine as iptables.

> Could you also include how the nft error output looks like after your
> patch in your description?
>

Yes I'll do that.
Thanks.

> Thanks.
