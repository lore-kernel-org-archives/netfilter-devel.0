From: AFT <aftnix@gmail.com>
Subject: Re: Journey of a network packet through linux 2.6 network stack
Date: Tue, 19 Jun 2012 19:15:10 +0600
Message-ID: <fw9ra1ep.fsf@s1.test.com>
References: <hau7egzm.fsf@s1.test.com> <20120619114211.GE445@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kernelnewbies@kernelnewbies.org, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43294 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751813Ab2FSNY4 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Jun 2012 09:24:56 -0400
Received: by pbbrp8 with SMTP id rp8so9654184pbb.19
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Jun 2012 06:24:55 -0700 (PDT)
In-Reply-To: <20120619114211.GE445@1984> (Pablo Neira Ayuso's message of "Tue,
	19 Jun 2012 13:42:11 +0200")
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso <pablo@netfilter.org> writes:

> On Tue, Jun 19, 2012 at 04:25:01PM +0600, AFT wrote:
>> 
>> Hi,
>> 
>> A document with this heading can be found for 2.4 network stack. But i
>> have not found any document regarding 2.6 network stack.
>> 
>> When i was searching netfilter mailing list archive, i got the following
>> post :
>> 
>> http://lists.netfilter.org/pipermail/netfilter/2007-august/069583.html
>> 
>> in this post author mentioned about a document named after this. but
>> does not gave any link to that document.
>> 
>> so i'm wondering if any similar document can be found?
>
> You've got Linux Networking internals.
>
> http://shop.oreilly.com/product/9780596002558.do
>
> It's pretty think, but it provides some panoramic. As kernel code
> evolves quite quickly, you may find that some things have changed, but
> it's a good base to start with if you're looking for an alternative to
> reading pure code.

Hi Pablo,

I have a scanned pdf of Linux kernel internals. But i stopped reading
when i found out struct sk_buff does not have a member struct
sk_buff_head * list like the book mentioned. It turns out its removed in
2.6.14/15 series where the book references a earlier code. 

On the plus side this made me set up cscope in my emacs. So i guess i
should thank the book for this.

Cheers.
