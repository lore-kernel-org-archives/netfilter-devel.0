From: "U.Mutlu" <for-gmane@mutluit.com>
Subject: Re: [libnetfilter_queue] extra data after payload
Date: Mon, 26 Sep 2011 20:58:06 +0200
Message-ID: <j5qhvu$4mc$1@dough.gmane.org>
References: <j5ibim$sen$1@dough.gmane.org> <6F5DE7538AFCDA45A114F5E7510424A702B36A0B@hq-exchange01.bytemobile.com> <j5k36d$9ch$1@dough.gmane.org> <alpine.LNX.2.01.1109241018150.25073@frira.zrqbmnf.qr> <6F5DE7538AFCDA45A114F5E7510424A702B36BFD@hq-exchange01.bytemobile.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:35953 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603Ab1IZS6X (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Sep 2011 14:58:23 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <gnnd-netfilter-devel@m.gmane.org>)
	id 1R8GNh-0004Fj-1O
	for netfilter-devel@vger.kernel.org; Mon, 26 Sep 2011 20:58:21 +0200
Received: from p5dc8f4a5.dip.t-dialin.net ([93.200.244.165])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Sep 2011 20:58:21 +0200
Received: from for-gmane by p5dc8f4a5.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Mon, 26 Sep 2011 20:58:21 +0200
In-Reply-To: <6F5DE7538AFCDA45A114F5E7510424A702B36BFD@hq-exchange01.bytemobile.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jeff Haran wrote, On 2011-09-26 19:45:
>> -----Original Message-----
>> From: netfilter-devel-owner@vger.kernel.org [mailto:netfilter-devel-
>> owner@vger.kernel.org] On Behalf Of Jan Engelhardt
>> Sent: Saturday, September 24, 2011 1:24 AM
>> To: U.Mutlu
>> Cc: netfilter-devel@vger.kernel.org
>> Subject: Re: [libnetfilter_queue] extra data after payload
>>
>> On Saturday 2011-09-24 10:08, U.Mutlu wrote:
>>>>> for example:
>>>>>     rv  = recv(fd, buf, sizeof(buf), 0);   // rv=84
>>>>>     ...
>>>>>     ret = nfq_get_payload(tb,&data);      // ret=40 (ie. ip + tcp
> pkt, both
>>>>> w/o
>>>>> options, and tcp w/o user data)
>>>>>
>>>>> So, here, what are the extra 44 bytes after the tcp data?
>>>>
>>>> I believe you will find there is a struct nlmsghdr at  the
> beginning of the
>>>> data, before the IP header
>>>
>>> nlmsghdr has size 16, I've not figured out yet what comes after it
> before
>> the
>>> (optional) payload starts.
>>
>> (It's struct nlmsghdr, struct nfgenmsg, struct nfqnl_msg_packet_hdr.)
>>
>> Suffice to say that, what buf actually contains is
> implementation-defined, and
>> "uninteresting", since you chose to use a library to deal with it for
> you,
>> abstracting the whole thing.
>
> Well, not necessarily "uninteresting". Some people like to understand
> how something they are using works.
>
> Plus, if you don't know how big these headers are, you can you know how
> big a buffer you need to read the message off of the socket into without
> truncating the IP packet at the end?
>
> The sample code at
> http://www.netfilter.org/projects/libnetfilter_queue/doxygen/group__Queu
> e.html shows a call to recv() made into an undeclared variable named
> "buf" with the amount of data to be read specified as "sizeof(buf)".
>
> I don't see anything in the API to call to tell the user this and I
> haven't seen it in the documentation either, though perhaps I've missed
> it.

One can get the header size by subtracting the payload start from the
buffer start. So, the header(s) seems to have the mentioned total len
of 44 bytes, but not sure if that's true always.

BTW, since the sample above contains this func call:
   nfq_set_mode(qh, NFQNL_COPY_PACKET, 0xffff)
it then practically means that buf must be >= 64k-1+hdrsize, ie. at least 65579 bytes...

