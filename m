From: Neutron Soutmun <neo.neutron@gmail.com>
Subject: Re: [PATCH] libmnl: Failed to build with clang, incompatible
 EXPORT_SYMBOL(x) macro
Date: Thu, 1 Oct 2015 18:12:38 +0700
Message-ID: <CAMQP0smV62oNtCi-v+W18pvKY3Uh=GpsDV_VU-_Q9A7XuvysZw@mail.gmail.com>
References: <20150925040745.GA433@oxygen>
	<20150930221241.GA14943@salvia>
	<alpine.LSU.2.20.1510011119340.22579@nerf40.vanv.qr>
	<CAMQP0s=TACNduhH+_w0yWLtHnS5rUaQXXvKOfoVR7Mqz2ZYDhA@mail.gmail.com>
	<20151001101515.GA2313@salvia>
	<CAMQP0snj1bgvfWZCH5cXGE5kHUfSwPbsef9WDZZhYq-SMDT_Kw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jan Engelhardt <jengelh@inai.de>, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ig0-f179.google.com ([209.85.213.179]:34984 "EHLO
	mail-ig0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810AbbJALMj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Oct 2015 07:12:39 -0400
Received: by igbkq10 with SMTP id kq10so12657020igb.0
        for <netfilter-devel@vger.kernel.org>; Thu, 01 Oct 2015 04:12:38 -0700 (PDT)
In-Reply-To: <CAMQP0snj1bgvfWZCH5cXGE5kHUfSwPbsef9WDZZhYq-SMDT_Kw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I have prepared the patch that drop all EXPORT_SYMBOL tags
Please find [1] - [PATCH] libmnl: Drop the EXPORT_SYMBOL() tags


Best regards,
Neutron Soutmun

[1] https://marc.info/?l=netfilter-devel&m=144369760923041&w=2

On Thu, Oct 1, 2015 at 5:29 PM, Neutron Soutmun <neo.neutron@gmail.com> wrote:
> On Thu, Oct 1, 2015 at 5:15 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> On Thu, Oct 01, 2015 at 04:30:23PM +0700, Neutron Soutmun wrote:
>>> On Thu, Oct 1, 2015 at 4:20 PM, Jan Engelhardt <jengelh@inai.de> wrote:
>>> >
>>> > On Thursday 2015-10-01 00:12, Pablo Neira Ayuso wrote:
>>> >>On Fri, Sep 25, 2015 at 11:07:45AM +0700, Neutron Soutmun wrote:
>>> >>> The EXPORT_SYMBOL(x) macro causes clang compile error and warning
>>> >>> messges:
>>> >>>   error,   "note: previous definition is here"
>>> >>>   warning, "warning: attribute declaration must precede definition
>>> >>>             [-Wignored-attributes]"
>>> >>>   See: [1]
>>> >>>
>>> >>> This proposed patch has been prepared to fix this error which make the
>>> >>> EXPORT_SYMBOL macro define a precede definition of an attribute
>>> >>> declaration. This approach is both compatible with gcc and clang.
>>> >>
>>> >>We have more libraries using this approach, which resembles kernel
>>> >>coding. So we would need to update them all, which is a bit annoying.
>>> >
>>> > If you use an export map (-Wl,--version-script=), you don't strictly
>>> > need to have any of the EXPORT_SYMBOL tags in the C source.
>>>
>>> +1
>>
>> That sounds as a smaller patch, please send it to me for the existing
>> libraries that we have. Thanks.
>
> I have tested with libipset, clang exports the symbols fine and no any warnings.
>
> libmnl has implemented the export map already,
> therefore, I'll prepare and test the patch that drop all EXPORT_SYMBOL tags.
>
> Best regards,
> Neutron Soutmun
