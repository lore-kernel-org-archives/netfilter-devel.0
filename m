From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: Re: [PATCH v3 kernel 16/29] add permanent byte/packet format capability
 to nfacct
Date: Thu, 11 Jul 2013 19:56:28 +0100
Message-ID: <51DEFFDC.3040502@googlemail.com>
References: <1373480727-11254-1-git-send-email-michael.zintakis@googlemail.com> <1373480727-11254-17-git-send-email-michael.zintakis@googlemail.com> <20130710200024.GB27468@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f176.google.com ([209.85.217.176]:49599 "EHLO
	mail-lb0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756382Ab3GKS4h (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Jul 2013 14:56:37 -0400
Received: by mail-lb0-f176.google.com with SMTP id z5so7016784lbh.35
        for <netfilter-devel@vger.kernel.org>; Thu, 11 Jul 2013 11:56:35 -0700 (PDT)
In-Reply-To: <20130710200024.GB27468@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Florian Westphal wrote:
> Michael Zintakis <michael.zintakis@googlemail.com> wrote:
>> * add a 'fmt' variable to each nfacct object, allowing a permanent packets
>> and bytes formatting to be stored. The two packet and byte formats are
>> independent of each other.
> 
> Every other in-kernel byte counter (that I can think of) is a plain u64.
> 
> It might help if you'd explain why this is necessary.
This isn't a counter. This field stores the formatting of byte and packet numbers for each accounting object registered with the kernel (8-bits each = 16 bits in total unsigned). If you look at the man page (section FORMAT OPTIONS) it is all explained there - with examples.
