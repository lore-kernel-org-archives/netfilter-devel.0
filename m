From: Matthew Weber <matthew.weber@rockwellcollins.com>
Subject: Re: [Repost] Fix userspace compilation of ip_tables.h/ip6_tables.h in
 C++ mode
Date: Tue, 18 Nov 2014 07:43:57 -0600
Message-ID: <CANQCQpYL52_Fy-vK7ZC2Mfcg7x9XmJ=FRbFZnCx4jyQT3mgWcQ@mail.gmail.com>
References: <CANQCQpb+_Z0U7ko-FKcmA3Zm4VXrG4QG3+Nx_noq3CFt1UfZMA@mail.gmail.com>
	<20141104183154.GA27004@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from secvs02.rockwellcollins.com ([205.175.225.241]:9069 "EHLO
	secvs02.rockwellcollins.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754349AbaKRNn7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 18 Nov 2014 08:43:59 -0500
Received: by mail-ie0-f178.google.com with SMTP id tp5so4550671ieb.9
        for <netfilter-devel@vger.kernel.org>; Tue, 18 Nov 2014 05:43:57 -0800 (PST)
In-Reply-To: <20141104183154.GA27004@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo,

On Tue, Nov 4, 2014 at 12:31 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Nov 03, 2014 at 10:13:43PM -0600, Matthew Weber wrote:
>> Re-posting a link to a patch that was posted to lkml & linux-netdev at
>> first, then posted to netfilter-devel.
>>
>> http://marc.info/?t=134904906300003&r=1&w=1
>>
>> It seems to have been rejected:   http://patchwork.ozlabs.org/patch/188216/
>>
>> We're building a custom C++ application which pulls in the iptables
>> header that requires this change.  We wanted to see if we could get it
>> incorporated so we don't carry the patch as part of our build.
>
> I'm reticent to apply a kernel patch to resolve C++ compilation
> issues. You can easily fix this by keeping a cached copy of this
> header file in your userspace application.
We've also noticed since I originally posted this thread that it is
definitely a kernel patch and not something that should live with the
iptables package.

>
> What existing C++ FOS software is using the native binary iptables
> interface?
Not sure, I ran into this when porting a proprietary application.

>
>> I can gladly resubmit the patch but the one in patchworks is still
>> correct.
>
> I guess you're using an older kernel version, this nows resides in
> include/uapi/linux.

I appreciate the clarification, thanks!


-- 
Matthew L Weber / Pr Software Engineer
Airborne Information Systems / Security Systems and Software
MS 131-100, C Ave NE, Cedar Rapids, IA, 52498, USA
www.rockwellcollins.com

Note: Any Export License Required Information and License Restricted
Third Party Intellectual Property (TPIP) content must be encrypted and
sent to matthew.weber@corp.rockwellcollins.com.
