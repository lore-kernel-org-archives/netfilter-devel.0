From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] for some issues in tcp window tracking patch
Date: Sat, 22 May 2004 16:31:25 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40AF643D.2050706@trash.net>
References: <Pine.LNX.4.44.0405220040040.28306-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira <pablo@eurodev.net>,
 Jozsef Kadlecsik <kadlec@netfilter.org>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0405220040040.28306-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Henrik Nordstrom wrote:
> On Fri, 21 May 2004, Patrick McHardy wrote:
> 
> 
>>I missed that question. It's probably not neccessary, we will get a
>>small race when zapping conntracks, but according to this comment in
>>unreplied() we already have one anyway.
> 
> 
> What I thought.. a __set_bit should be sufficient here, right?

I think so.

> 
> Is there any good description somewhere on how these memory barriers 
> works and when they are needed, or more precisely what is the difference 
> between set_bit and __set_bit in terms of when/how/why each should be 
> used?

Judging from the comments, the difference is that set_bit guarantees
multiple set_bits will be seen by all processors in the right order.
atomic is not the right word, since a single load or store is
indivisible on x86 anyway. The reason why one would use __set_bit
instead of just ORing the bits together is that it can operate on
almost arbitrarily large bitmaps.

> 
> But in this case there is many races.. a test_bit followed  by a set_bit 
> is not atomic unles governed by a surrounding lock independent of if 
> there is memory barriers of not around the operations, and the flushing of 
> unconfirmed sessions is inherently racy anyway without strict locking. If 
> there is strict locking then memory barriers in the set_bit should be 
> completely irrelevant. Right?

Yes.

Regards
Patrick

> 
> Regards
> Henrik
> 
