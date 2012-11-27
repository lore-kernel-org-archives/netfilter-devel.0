From: Eric Leblond <eric@regit.org>
Subject: Re: [PATCH 2/2] build: resolve compile error due to missing nfacct
 CPPFLAGS
Date: Tue, 27 Nov 2012 13:30:08 +0100
Message-ID: <1354019408.4103.10.camel@tiger2>
References: <1353974099-19891-1-git-send-email-jengelh@inai.de>
	  <1353974099-19891-3-git-send-email-jengelh@inai.de>
	 <1354002875.4103.5.camel@tiger2>
	 <alpine.LNX.2.01.1211271251000.22381@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:37513 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab2K0Mal (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Nov 2012 07:30:41 -0500
In-Reply-To: <alpine.LNX.2.01.1211271251000.22381@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Tue, 2012-11-27 at 12:51 +0100, Jan Engelhardt wrote:
> On Tuesday 2012-11-27 08:54, Eric Leblond wrote:
> >> index 630aee6..61d827a 100644
> >> --- a/output/Makefile.am
> >> +++ b/output/Makefile.am
> >> @@ -1,4 +1,4 @@
> >> -AM_CPPFLAGS = -I$(top_srcdir)/include
> >> +AM_CPPFLAGS = -I$(top_srcdir)/include ${LIBNETFILTER_ACCT_CFLAGS}
> >>  AM_CFLAGS = ${regular_CFLAGS} ${LIBNETFILTER_LOG_CFLAGS} \
> >>  	    ${LIBNETFILTER_CONNTRACK_CFLAGS}
> >
> >Good catch but on last line we use the other ${LIBNETFILTER*_CFLAGS} to
> >populate AM_CFLAGS. We should keep all variables at the same place. If
> >we follow your indication in the commit we should use AM_CPPFLAGS (I'm
> >agree with that).
> 
> I can send another patch moving all the pkgconfig variables to
> CPPFLAGS.

Please do, I will push your two patches to the public tree once done.

BR,
-- 
Eric Leblond <eric@regit.org>
Blog: https://home.regit.org/

