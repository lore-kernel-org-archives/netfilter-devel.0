From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH net-next v18 0/8] sched: Add Common Applications Kept
 Enhanced (cake) qdisc
Date: Fri, 01 Jun 2018 14:17:54 -0400 (EDT)
Message-ID: <20180601.141754.1200654092659997748.davem@davemloft.net>
References: <152776056580.16347.7216549227396672873.stgit@alrua-kau>
        <87r2lq9zez.fsf@toke.dk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Cc: netdev@vger.kernel.org, cake@lists.bufferbloat.net,
        gamanakis@gmail.com, peteheist@gmail.com, ycheng@google.com,
        ncardwell@google.com, dave.taht@gmail.com,
        netfilter-devel@vger.kernel.org
To: toke@toke.dk
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <87r2lq9zez.fsf@toke.dk>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Toke Høiland-Jørgensen <toke@toke.dk>
Date: Fri, 01 Jun 2018 19:42:12 +0200

> Toke Høiland-Jørgensen <toke@toke.dk> writes:
> 
>> This patch series adds the CAKE qdisc, and has been split up to ease
>> review.
>>
>> I have attempted to split out each configurable feature into its own patch.
>> The first commit adds the base shaper and packet scheduler, while
>> subsequent commits add the optional features. The full userspace API and
>> most data structures are included in this commit, but options not
>> understood in the base version will be ignored.
> 
> Hmm, there seems to be a lockup issue being triggered when running CAKE
> at high speeds (>40 Gbps in my tests). Please drop this series for now,
> we'll return for 4.19 with a revised version.

Ok.

Thanks for continuing to push this work along.
