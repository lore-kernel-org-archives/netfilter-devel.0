From: "Jeff Haran" <jharan@bytemobile.com>
Subject: RE: [libnetfilter_queue] extra data after payload
Date: Mon, 26 Sep 2011 10:45:54 -0700
Message-ID: <6F5DE7538AFCDA45A114F5E7510424A702B36BFD@hq-exchange01.bytemobile.com>
References: <j5ibim$sen$1@dough.gmane.org> <6F5DE7538AFCDA45A114F5E7510424A702B36A0B@hq-exchange01.bytemobile.com> <j5k36d$9ch$1@dough.gmane.org> <alpine.LNX.2.01.1109241018150.25073@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: <netfilter-devel@vger.kernel.org>
To: "Jan Engelhardt" <jengelh@medozas.de>,
	"U.Mutlu" <for-gmane@mutluit.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ironport.bytemobile.com ([12.153.136.13]:25016 "EHLO
	ironport.bytemobile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750997Ab1IZRqP convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 26 Sep 2011 13:46:15 -0400
Content-class: urn:content-classes:message
In-Reply-To: <alpine.LNX.2.01.1109241018150.25073@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> -----Original Message-----
> From: netfilter-devel-owner@vger.kernel.org [mailto:netfilter-devel-
> owner@vger.kernel.org] On Behalf Of Jan Engelhardt
> Sent: Saturday, September 24, 2011 1:24 AM
> To: U.Mutlu
> Cc: netfilter-devel@vger.kernel.org
> Subject: Re: [libnetfilter_queue] extra data after payload
> 
> 
> On Saturday 2011-09-24 10:08, U.Mutlu wrote:
> >>> for example:
> >>>    rv  = recv(fd, buf, sizeof(buf), 0);   // rv=84
> >>>    ...
> >>>    ret = nfq_get_payload(tb,&data);      // ret=40 (ie. ip + tcp
pkt, both
> >>> w/o
> >>> options, and tcp w/o user data)
> >>>
> >>> So, here, what are the extra 44 bytes after the tcp data?
> >>
> >> I believe you will find there is a struct nlmsghdr at  the
beginning of the
> >> data, before the IP header
> >
> > nlmsghdr has size 16, I've not figured out yet what comes after it
before
> the
> > (optional) payload starts.
> 
> (It's struct nlmsghdr, struct nfgenmsg, struct nfqnl_msg_packet_hdr.)
> 
> Suffice to say that, what buf actually contains is
implementation-defined, and
> "uninteresting", since you chose to use a library to deal with it for
you,
> abstracting the whole thing.

Well, not necessarily "uninteresting". Some people like to understand
how something they are using works.

Plus, if you don't know how big these headers are, you can you know how
big a buffer you need to read the message off of the socket into without
truncating the IP packet at the end?

The sample code at
http://www.netfilter.org/projects/libnetfilter_queue/doxygen/group__Queu
e.html shows a call to recv() made into an undeclared variable named
"buf" with the amount of data to be read specified as "sizeof(buf)".

I don't see anything in the API to call to tell the user this and I
haven't seen it in the documentation either, though perhaps I've missed
it.

Thanks,

Jeff Haran



