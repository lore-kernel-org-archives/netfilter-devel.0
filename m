From: Ani Sinha <ani@arista.com>
Subject: Re: linux 3.4.43 : kernel crash at __nf_conntrack_confirm
Date: Thu, 22 Oct 2015 12:53:57 -0700
Message-ID: <CAOxq_8PTLQGZ7WwMX8W0dmWW3+cMbv5BkocR3rsW=rNTfxXRjw@mail.gmail.com>
References: <CAOxq_8PF91fpX9jYTgBbXnOVeVfSu3tytu-3P_Zr5OodGRoz+g@mail.gmail.com>
 <CAOxq_8Pt7VMwkV8+wdjS9vj=-L0L8Xxkd3Beit0zZN_oR6ixhw@mail.gmail.com>
 <20151018080702.GA14564@breakpoint.cc> <CAOxq_8P9Qgy5+qWNCHtbG8qJwfdKSO3ZiDWoQW_6BVS-+hcTRA@mail.gmail.com>
 <20151021211911.GD31323@breakpoint.cc> <CAOxq_8PLX_+w-7mfx1Agh+utogEiFWHSmEFd0Bax1LY6qbEN-w@mail.gmail.com>
 <20151022034232.58e5af7a@playground>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Cc: netfilter-devel@vger.kernel.org
To: "Neal P. Murphy" <neal.p.murphy@alum.wpi.edu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-io0-f173.google.com ([209.85.223.173]:33132 "EHLO
	mail-io0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757621AbbJVTyR convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Oct 2015 15:54:17 -0400
Received: by iodv82 with SMTP id v82so102923161iod.0
        for <netfilter-devel@vger.kernel.org>; Thu, 22 Oct 2015 12:54:17 -0700 (PDT)
In-Reply-To: <20151022034232.58e5af7a@playground>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 22, 2015 at 12:42 AM, Neal P. Murphy
<neal.p.murphy@alum.wpi.edu> wrote:
> On Wed, 21 Oct 2015 14:26:35 -0700
> Ani Sinha <ani@arista.com> wrote:
>
>> On Wed, Oct 21, 2015 at 2:19 PM, Florian Westphal <fw@strlen.de> wrote:
>> > Ani Sinha <ani@arista.com> wrote:
>> >> >> > commit c6825c0976fa7893692e0e43b09740b419b23c09
>> >> >> > Author: Andrey Vagin <avagin@openvz.org>
>> >> >> > Date:   Wed Jan 29 19:34:14 2014 +0100
>> >> >> >      netfilter: nf_conntrack: fix RCU race in nf_conntrack_find_get
>> >> >> >
>> >> >> > and a followup patch :
>> >> >> >
>> >> >> > commit e53376bef2cd97d3e3f61fdc677fb8da7d03d0da
>> >> >> > Author: Pablo Neira Ayuso <pablo@netfilter.org>
>> >> >> > Date:   Mon Feb 3 20:01:53 2014 +0100
>> >> >> >         netfilter: nf_conntrack: don't release a conntrack with non-zero refcnt
>> >> >> >
>> >> >
>> >> > These for instance fix such bugs.
>> >>
>> >> So since both these patches were not backported to 3.4 series and
>> >> since now we have evidence of a crash that points to issues which the
>> >> patches fix, should we consider backporting the above patches to 3.4?
>> >
>> > Yes.
>>
>> Ok cool. I will send out backport patches for 3.4 corresponding to
>> both the above patches.
>
> As an FYI, Zefan Li just released 3.4.110; I didn't see the fix in the list. No surprise, of course; it does take more than 12 hours to get patches right, as I am painfully aware.
>
> I just bumped Smoothwall Express to 3.4.109 in Update4, and 3.4.110 contains fixes that relate to Smoothwall. May I safely assume that these patches will apply easily to 3.4.110? The obvious answer is, "Yes," but I'd like a bit of reassurance (<pat> <pat> "There, there; it'll be fine. The patches will be OK.") before I prepare and release the next update.

The patches won't apply as is. There will be some work involved. For
example, one of the patches involves modification in synproxy module.
This isn't available in 3.4 train. So don't hold your breath. I will
work on this as soon as I can.

Ani


>
> Neal
