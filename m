From: Eric Leblond <eric@regit.org>
Subject: Re: [ulogd PATCH 0/8] make progress ulogd_output_IPFIX
Date: Tue, 22 Apr 2014 17:20:20 +0200
Message-ID: <1398180020.4353.13.camel@ice-age2.regit.org>
References: <20140308010344.GA4415@gmail.com>
	 <1395600620.23474.18.camel@ice-age2.regit.org>
	 <20140326121122.GA24689@gmail.com>
	 <1397914593.25953.7.camel@ice-age2.regit.org>
	 <20140422120351.GC1521@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:41098 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932843AbaDVPUc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:20:32 -0400
In-Reply-To: <20140422120351.GC1521@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Tue, 2014-04-22 at 21:03 +0900, Ken-ichirou MATSUZAWA wrote:
>  Hello,
> 
> I have just resent patches related to theses.
> 
> On Sat, Apr 19, 2014 at 03:36:33PM +0200, Eric Leblond wrote:
> > dump once again the required version of the libs. So you should add a
> > check on nfct_bitmask in the configure.ac to be sure you will be able to
> > build IPFIX.
> 
> I did it by compiling, or should I check lib version?

No function check should be enough as the code is only needing one
single function.

> > I've just fixed two remaining whitespace issues and I can provide you
> > the updated patchset if you want.
> 
> I think I fixed it. if not, would you send updated patchset?

I'm sending it to you.

BR,
-- 
Eric Leblond <eric@regit.org>

