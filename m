From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH 2/2] build: resolve compile error due to missing nfacct
 CPPFLAGS
Date: Tue, 27 Nov 2012 12:51:16 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1211271251000.22381@nerf07.vanv.qr>
References: <1353974099-19891-1-git-send-email-jengelh@inai.de>  <1353974099-19891-3-git-send-email-jengelh@inai.de> <1354002875.4103.5.camel@tiger2>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:50522 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750890Ab2K0LvT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Nov 2012 06:51:19 -0500
In-Reply-To: <1354002875.4103.5.camel@tiger2>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2012-11-27 08:54, Eric Leblond wrote:
>> index 630aee6..61d827a 100644
>> --- a/output/Makefile.am
>> +++ b/output/Makefile.am
>> @@ -1,4 +1,4 @@
>> -AM_CPPFLAGS = -I$(top_srcdir)/include
>> +AM_CPPFLAGS = -I$(top_srcdir)/include ${LIBNETFILTER_ACCT_CFLAGS}
>>  AM_CFLAGS = ${regular_CFLAGS} ${LIBNETFILTER_LOG_CFLAGS} \
>>  	    ${LIBNETFILTER_CONNTRACK_CFLAGS}
>
>Good catch but on last line we use the other ${LIBNETFILTER*_CFLAGS} to
>populate AM_CFLAGS. We should keep all variables at the same place. If
>we follow your indication in the commit we should use AM_CPPFLAGS (I'm
>agree with that).

I can send another patch moving all the pkgconfig variables to
CPPFLAGS.
