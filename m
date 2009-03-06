From: Fred Moyer <fred@redhotpenguin.com>
Subject: Re: build error when compiling nfsim against 2.6.23.17
Date: Fri, 6 Mar 2009 09:02:23 -0800
Message-ID: <ad28918e0903060902o21e72ae1r65fb7f1680b8e618@mail.gmail.com>
References: <ad28918e0903041223t7edb61d3hb479b3ca3c91ed26@mail.gmail.com>
	 <49AFC4BB.8090102@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.226]:12004 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756289AbZCFRC0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 6 Mar 2009 12:02:26 -0500
Received: by rv-out-0506.google.com with SMTP id g37so581032rvb.1
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Mar 2009 09:02:24 -0800 (PST)
In-Reply-To: <49AFC4BB.8090102@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 5, 2009 at 4:25 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Fred Moyer wrote:
>> I'm developing a connection tracking module for the 2.6.23.17 kernel
>> using the nf_conntrack helper examples (actually porting a nat module
>> I had for 2.4.30) and am trying to use the nfsim test framework
>> instead of my previous crude method of sending packets through the
>> machine.
>
> Sorry, nfsim currently lacks of maintainer.

Ok, I'll make an effort to fix that issue and submit a patch.

What is the recommended alternative for testing connection helper modules?
