From: "Neal P. Murphy" <neal.p.murphy@alum.wpi.edu>
Subject: Re: libxtables backward compatibility
Date: Sun, 3 Jul 2016 18:43:41 -0400
Message-ID: <20160703184341.4e0522b4@playground>
References: <20160703160042.76f76433@playground>
	<alpine.LSU.2.20.1607032252110.20663@nerf40.vanv.qr>
	<20160703172944.025b3102@playground>
	<alpine.LSU.2.20.1607032351450.3257@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail1.wpi.edu ([130.215.36.91]:34272 "EHLO MAIL1.WPI.EDU"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932160AbcGCWnq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Jul 2016 18:43:46 -0400
Received: from MAIL1.WPI.EDU (MAIL1.WPI.EDU [130.215.36.91])
	by MAIL1.WPI.EDU (8.15.1/8.15.1) with ESMTP id u63MhiOK022185
	for <netfilter-devel@vger.kernel.org>; Sun, 3 Jul 2016 18:43:44 -0400
Received: from MX1.WPI.EDU (mx1.wpi.edu [130.215.36.141])
	by MAIL1.WPI.EDU (8.15.1/8.15.1) with ESMTP id u63MhiN1022182
	for <netfilter-devel@vger.kernel.org>; Sun, 3 Jul 2016 18:43:44 -0400
Received: from ALUM.WPI.EDU (alum.wpi.edu [130.215.36.126])
	by MX1.WPI.EDU (8.14.4/8.14.4) with ESMTP id u63MhhDQ012394
	for <netfilter-devel@vger.kernel.org>; Sun, 3 Jul 2016 18:43:44 -0400
	(envelope-from neal.p.murphy@alum.wpi.edu)
Received: from playground (c-73-251-108-62.hsd1.va.comcast.net [73.251.108.62])
	(authenticated authen=neal.p.murphy)
	by ALUM.WPI.EDU (8.15.1/8.15.1) with ESMTPSA id u63MhgtB022934
	(version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Sun, 3 Jul 2016 18:43:43 -0400
In-Reply-To: <alpine.LSU.2.20.1607032351450.3257@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 3 Jul 2016 23:56:38 +0200 (CEST)
Jan Engelhardt <jengelh@inai.de> wrote:

> 
> On Sunday 2016-07-03 23:29, Neal P. Murphy wrote:
> >> On Sunday 2016-07-03 22:00, Neal P. Murphy wrote:
> >> 
> >> >Specifically, should programs linked to--and expecting to use--libxtables.so.7
> >> >work with versions libxtables.so.10 and libxtables.so.11? I suspect yes
> >> 
> >> Absolutely not. Never has been in any shared library system.
> >
> >(I begin to see why some products stay with a specific set of pkg versions for
> >longer periods of time: keeping one or two things updated can turn into a
> >full-time job updating all of the related pkgs.)
> 
> This is why anyone caring about their time is offloading automatable task to
> software, like openbuildservice.org does for me.

That would be a great service to be able to use.

Alas, Smoothwall isn't there yet; it doesn't use packages. Maybe some day. Regardless, I still have to manually update the build process when bumping gcc, glibc, binutils and similar utilities; LFS is a good guide, but it still takes a long time to figure out how to make those packages build. Never mind poring through the build logs to find which packages ignore "-m32 -march=i586" (there are plenty of x86 CPUs in use that don't have the CMOV instructions, thus i586 is required). And never mind finding all of a package's dependencies, and adding new ones to the build.

Neal
