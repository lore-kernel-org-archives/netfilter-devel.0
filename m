From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: Re: [ulogd PATCH 0/8] make progress ulogd_output_IPFIX
Date: Wed, 26 Mar 2014 21:11:24 +0900
Message-ID: <20140326121122.GA24689@gmail.com>
References: <20140308010344.GA4415@gmail.com>
 <1395600620.23474.18.camel@ice-age2.regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f48.google.com ([209.85.160.48]:32772 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753518AbaCZMLl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 26 Mar 2014 08:11:41 -0400
Received: by mail-pb0-f48.google.com with SMTP id md12so1849868pbc.21
        for <netfilter-devel@vger.kernel.org>; Wed, 26 Mar 2014 05:11:40 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1395600620.23474.18.camel@ice-age2.regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 Hello Eric.

Thank you for taking your time to see it and your reply.

> Some generic points regarding this patchset:

I'm resending all with following it, sorry for your inconvenience
And you wrote...

> Subject: Re: [PATCH 1/8] ipfix: use nfct_bitmask
> available on the system. As it is possible to build ulogd with
> --disable-nfct configure flags, you need to make the build of IPFIX

I see. I should have seen input/Makefile.am before, thank you.

> Subject: Re: [PATCH 5/8] ipfix: add function for ipfix message creation
> I don't like this malloc because ulogd will do an allocation for each

I think we can fix allocation sizes for each of template and I worked
at PATCH 8/8 but you could not see it because the patches format were
invalid, sorry.

Thanks.
