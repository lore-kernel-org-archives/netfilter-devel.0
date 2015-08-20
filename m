From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH] build: use _DEFAULT_SOURCE for newer glibc
Date: Thu, 20 Aug 2015 10:12:25 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1508201011460.28043@nerf40.vanv.qr>
References: <1439935658-17834-1-git-send-email-vapier@gentoo.org> <alpine.LSU.2.20.1508190908430.11093@nerf40.vanv.qr> <20150819130829.GY1584@vapier>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Mike Frysinger <vapier@gentoo.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:54499 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbbHTIM1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Aug 2015 04:12:27 -0400
In-Reply-To: <20150819130829.GY1584@vapier>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2015-08-19 15:08, Mike Frysinger wrote:
>On 19 Aug 2015 09:09, Jan Engelhardt wrote:
>> On Wednesday 2015-08-19 00:07, Mike Frysinger wrote:
>> >Since _BSD_SOURCE is deprecated with newer glibc versions, we get build
>> >warnings when using only that define.  Add the newer _DEFAULT_SOURCE to
>> >quiet things down.
>> 
>> Why do we even need _BSD_SOURCE/_ISOC99_SOURCE/_DEFAULT_SOURCE? The 
>> thing apparently builds without it (glibc-2.19), too.
>
>i would check with the guy who committed this ;)
>
>    build: resolve compile abort in libxt_limit on RHEL5
>    
>    libxt_limit.c: In function 'print_rate':
>        libxt_limit.c:124: error: 'INFINITY' undeclared (first use in
>        this function)

Well if that is the case, have you checked that using _DEFAULT_SOURCE
over _ISOC99_SOURCE+_BSD_SOURCE still works on RHEL5?
