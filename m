From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [libnetfilter_queue] extra data after payload
Date: Sat, 24 Sep 2011 10:24:05 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1109241018150.25073@frira.zrqbmnf.qr>
References: <j5ibim$sen$1@dough.gmane.org> <6F5DE7538AFCDA45A114F5E7510424A702B36A0B@hq-exchange01.bytemobile.com> <j5k36d$9ch$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: "U.Mutlu" <for-gmane@mutluit.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:40863 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751031Ab1IXIYH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 24 Sep 2011 04:24:07 -0400
In-Reply-To: <j5k36d$9ch$1@dough.gmane.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2011-09-24 10:08, U.Mutlu wrote:
>>> for example:
>>>    rv  = recv(fd, buf, sizeof(buf), 0);   // rv=84
>>>    ...
>>>    ret = nfq_get_payload(tb,&data);      // ret=40 (ie. ip + tcp pkt, both
>>> w/o
>>> options, and tcp w/o user data)
>>>
>>> So, here, what are the extra 44 bytes after the tcp data?
>>
>> I believe you will find there is a struct nlmsghdr at  the beginning of the
>> data, before the IP header
>
> nlmsghdr has size 16, I've not figured out yet what comes after it before the
> (optional) payload starts.

(It's struct nlmsghdr, struct nfgenmsg, struct nfqnl_msg_packet_hdr.)

Suffice to say that, what buf actually contains is implementation-defined, and
"uninteresting", since you chose to use a library to deal with it for you,
abstracting the whole thing.
