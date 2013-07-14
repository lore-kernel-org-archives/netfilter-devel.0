From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: Re: [PATCH v3 kernel 16/29] add permanent byte/packet format capability
 to nfacct
Date: Sun, 14 Jul 2013 09:29:53 +0100
Message-ID: <51E26181.2090705@googlemail.com>
References: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com> <1373480727-11254-17-git-send-email-michael.zintakis@googlemail.com> <20130710200024.GB27468@breakpoint.cc> <51DEFFDC.3040502@googlemail.com> <20130711201222.GG27468@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:60900 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751694Ab3GNIaI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 14 Jul 2013 04:30:08 -0400
Received: by mail-lb0-f173.google.com with SMTP id v1so8680535lbd.18
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Jul 2013 01:30:05 -0700 (PDT)
In-Reply-To: <20130711201222.GG27468@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Florian Westphal wrote:
> Michael Zintakis <michael.zintakis@googlemail.com> wrote:
>> Florian Westphal wrote:
>>> Michael Zintakis <michael.zintakis@googlemail.com> wrote:
>>>> * add a 'fmt' variable to each nfacct object, allowing a permanent packets
>>>> and bytes formatting to be stored. The two packet and byte formats are
>>>> independent of each other.
>>> Every other in-kernel byte counter (that I can think of) is a plain u64.
>>>
>>> It might help if you'd explain why this is necessary.
>> This isn't a counter. This field stores the formatting of byte and packet numbers for each accounting object registered with the kernel (8-bits each = 16 bits in total unsigned). If you look at the man page (section FORMAT OPTIONS) it is all explained there - with examples.
> 
> It makes no sense to me.
> 
> Why should a 'display/representation property' be part of an operating
> system kernel?  It seems completely out of place.
So, what you are trying to tell me is that "display/presentation property", or, to extend that definition a bit more and include another of your and Pablo's objections from another message - "variables set/unset or interpreted from userspace" have no place in the kernel in your opinion?
