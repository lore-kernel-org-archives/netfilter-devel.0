From: Eric Leblond <eric@regit.org>
Subject: Re: [ulogd PATCH 0/8] make progress ulogd_output_IPFIX
Date: Sat, 19 Apr 2014 15:36:33 +0200
Message-ID: <1397914593.25953.7.camel@ice-age2.regit.org>
References: <20140308010344.GA4415@gmail.com>
	 <1395600620.23474.18.camel@ice-age2.regit.org>
	 <20140326121122.GA24689@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:40500 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751910AbaDSNgp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 19 Apr 2014 09:36:45 -0400
In-Reply-To: <20140326121122.GA24689@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

Sorry for the delay in the review.

On Wed, 2014-03-26 at 21:11 +0900, Ken-ichirou MATSUZAWA wrote:
>  Hello Eric.
> 
> Thank you for taking your time to see it and your reply.
> 
> > Some generic points regarding this patchset:
> 
> I'm resending all with following it, sorry for your inconvenience
> And you wrote...
> 
> > Subject: Re: [PATCH 1/8] ipfix: use nfct_bitmask
> > available on the system. As it is possible to build ulogd with
> > --disable-nfct configure flags, you need to make the build of IPFIX

I've just realized this means you won't be able to build IPFIX module if
you don't have a new version of libnetfilter_conntrack. I don't want to
dump once again the required version of the libs. So you should add a
check on nfct_bitmask in the configure.ac to be sure you will be able to
build IPFIX.

> I see. I should have seen input/Makefile.am before, thank you.
> 
> > Subject: Re: [PATCH 5/8] ipfix: add function for ipfix message creation
> > I don't like this malloc because ulogd will do an allocation for each
> 
> I think we can fix allocation sizes for each of template and I worked
> at PATCH 8/8 but you could not see it because the patches format were
> invalid, sorry.

I'm basically ok with the patchset if we omit the nfct_bitmask issue.
I've just fixed two remaining whitespace issues and I can provide you
the updated patchset if you want.

BR,
-- 
Eric Leblond <eric@regit.org>

