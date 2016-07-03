From: "Neal P. Murphy" <neal.p.murphy@alum.wpi.edu>
Subject: Re: libxtables backward compatibility
Date: Sun, 3 Jul 2016 17:29:44 -0400
Message-ID: <20160703172944.025b3102@playground>
References: <20160703160042.76f76433@playground>
	<alpine.LSU.2.20.1607032252110.20663@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail1.wpi.edu ([130.215.36.91]:58233 "EHLO MAIL1.WPI.EDU"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932156AbcGCV3s (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Jul 2016 17:29:48 -0400
Received: from MAIL1.WPI.EDU (MAIL1.WPI.EDU [130.215.36.91])
	by MAIL1.WPI.EDU (8.15.1/8.15.1) with ESMTP id u63LTlNO001155
	for <netfilter-devel@vger.kernel.org>; Sun, 3 Jul 2016 17:29:47 -0400
Received: from MX3.WPI.EDU (mx3.wpi.edu [130.215.36.147])
	by MAIL1.WPI.EDU (8.15.1/8.15.1) with ESMTP id u63LTlsn001151
	for <netfilter-devel@vger.kernel.org>; Sun, 3 Jul 2016 17:29:47 -0400
Received: from ALUM.WPI.EDU (alum.wpi.edu [130.215.36.126])
	by MX3.WPI.EDU (8.14.4/8.14.4) with ESMTP id u63LTkGY011561
	for <netfilter-devel@vger.kernel.org>; Sun, 3 Jul 2016 17:29:46 -0400
	(envelope-from neal.p.murphy@alum.wpi.edu)
Received: from playground (c-73-251-108-62.hsd1.va.comcast.net [73.251.108.62])
	(authenticated authen=neal.p.murphy)
	by ALUM.WPI.EDU (8.15.1/8.15.1) with ESMTPSA id u63LTjpK015705
	(version=TLSv1.2 cipher=AES128-GCM-SHA256 bits=128 verify=NO)
	for <netfilter-devel@vger.kernel.org>; Sun, 3 Jul 2016 17:29:45 -0400
In-Reply-To: <alpine.LSU.2.20.1607032252110.20663@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 3 Jul 2016 22:59:36 +0200 (CEST)
Jan Engelhardt <jengelh@inai.de> wrote:

> 
> On Sunday 2016-07-03 22:00, Neal P. Murphy wrote:
> 
> >Specifically, should programs linked to--and expecting to use--libxtables.so.7
> >work with versions libxtables.so.10 and libxtables.so.11? I suspect yes
> 
> Absolutely not. Never has been in any shared library system.

Drat. So I'll include all three versions in the next update. Unless the older versions of iptables are not compatible with newer versions of linux. (I begin to see why some products stay with a specific set of pkg versions for longer periods of time: keeping one or two things updated can turn into a full-time job updating all of the related pkgs.)

Thanks,
Neal
