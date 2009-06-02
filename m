From: Patrick McHardy <kaber@trash.net>
Subject: Re: Fwd: ebtables broken for kernel above 2.6.28
Date: Tue, 02 Jun 2009 14:20:45 +0200
Message-ID: <4A25191D.2030201@trash.net>
References: <17923cc80905280124t4ed6cf7m87f91e4444146697@mail.gmail.com>  <4A1EB783.4090801@pandora.be>  <17923cc80905282251s2ddc50a4n1a44a2b1e6b01cc5@mail.gmail.com>  <alpine.LSU.2.00.0905291156060.9095@fbirervta.pbzchgretzou.qr> <17923cc80905290414r5caaaec9t8b6c4ce849c66175@mail.gmail.com> <4A200B60.6080804@pandora.be> <alpine.LSU.2.00.0905291915490.12199@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Bart De Schuymer <bdschuym@pandora.be>,
	sachin sanap <sachin.sanap.1gb@gmail.com>,
	netfilter-devel@vger.kernel.org, buytenh@wantstofly.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38051 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751110AbZFBMUr (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Jun 2009 08:20:47 -0400
In-Reply-To: <alpine.LSU.2.00.0905291915490.12199@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Friday 2009-05-29 18:20, Bart De Schuymer wrote:
> 
>> I think it's best to fix this in the kernel if it's possible, since we don't
>> want to break compatibility.
>> If the fix has to be in userspace, then it must be a fix that still works for
>> older kernels.
> 
> Since the kernel uses xt_align already, it's best for userspace to do the same.

But that doesn't work for older kernels. Please don't dismiss
compatibility issues that easily. Sometimes things unfortunately
do slip through, but I expect people to do their best to fix the
problem properly when this happens.

