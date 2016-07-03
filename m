From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: libxtables backward compatibility
Date: Sun, 3 Jul 2016 23:56:38 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1607032351450.3257@nerf40.vanv.qr>
References: <20160703160042.76f76433@playground> <alpine.LSU.2.20.1607032252110.20663@nerf40.vanv.qr> <20160703172944.025b3102@playground>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: "Neal P. Murphy" <neal.p.murphy@alum.wpi.edu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:50836 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932160AbcGCV4l (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Jul 2016 17:56:41 -0400
In-Reply-To: <20160703172944.025b3102@playground>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2016-07-03 23:29, Neal P. Murphy wrote:
>> On Sunday 2016-07-03 22:00, Neal P. Murphy wrote:
>> 
>> >Specifically, should programs linked to--and expecting to use--libxtables.so.7
>> >work with versions libxtables.so.10 and libxtables.so.11? I suspect yes
>> 
>> Absolutely not. Never has been in any shared library system.
>
>(I begin to see why some products stay with a specific set of pkg versions for
>longer periods of time: keeping one or two things updated can turn into a
>full-time job updating all of the related pkgs.)

This is why anyone caring about their time is offloading automatable task to
software, like openbuildservice.org does for me.
