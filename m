From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] build: bump library versioning
Date: Wed, 16 Sep 2015 20:30:53 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1509162015460.13589@nerf40.vanv.qr>
References: <1442423567-12120-1-git-send-email-jengelh@inai.de> <20150916172836.GA29575@salvia> <20150916180048.GA4886@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:58522 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752565AbbIPSaz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Sep 2015 14:30:55 -0400
In-Reply-To: <20150916180048.GA4886@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2015-09-16 20:00, Pablo Neira Ayuso wrote:
>> > index 14ec88c..991fe9d 100644
>> > --- a/src/libnftnl.map
>> > +++ b/src/libnftnl.map
>> > @@ -1,4 +1,4 @@
>> > -LIBNFTNL_1.0 {
>> > +LIBNFTNL_4 {
>> 
>> This is breaking hard existing nft binaries, which is what I was
>> trying to avoid.

Well, a system can at least have both libnftnl.so.0 and libnftnl.so.4
concurrently present, and two programs will continue work.
(This in comparison to both expecting a .so.0 but with different
symbols in the groups.)

>Sorry, what you propose is fine actually. But this should be
>LIBNFTNL_3 instead, I already bumped LIBVERSION from 2:0:2 to 3:0:3,
>see 9e1e8052025fde.

Indeed.
