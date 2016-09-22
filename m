From: Feng Gao <gfree.wind@gmail.com>
Subject: Re: [PATCH nf] netfilter: seqadj: Fix the wrong ack adjust for the
 RST packet without ack
Date: Thu, 22 Sep 2016 10:36:22 +0800
Message-ID: <CA+6hz4p7dbNm5LU56ZP51+gktEr7nmUci-e4qSaxr2NoUxkFQg@mail.gmail.com>
References: <1473127567-10419-1-git-send-email-fgao@ikuai8.com>
 <CA+6hz4r+g-s_h=FiV4axCuwT_JQLiztyN2oDQ_iyz_20Mp2j+A@mail.gmail.com>
 <CA+6hz4qzd+Hew69SdF4VMAObMdRtEuX=ycG22fomjEULjrWqTw@mail.gmail.com>
 <20160912171732.GB28913@salvia> <CA+6hz4oYAsUc5v3yrsj7tLV-VtpMfwUQ2AK3wDkaPJg4jqSjpg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f54.google.com ([209.85.213.54]:34466 "EHLO
        mail-vk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753874AbcIVCgY (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 21 Sep 2016 22:36:24 -0400
Received: by mail-vk0-f54.google.com with SMTP id u196so7146469vkd.1
        for <netfilter-devel@vger.kernel.org>; Wed, 21 Sep 2016 19:36:23 -0700 (PDT)
In-Reply-To: <CA+6hz4oYAsUc5v3yrsj7tLV-VtpMfwUQ2AK3wDkaPJg4jqSjpg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

On Wed, Sep 14, 2016 at 5:51 PM, Feng Gao <gfree.wind@gmail.com> wrote:
>
>
> On Tue, Sep 13, 2016 at 1:17 AM, Pablo Neira Ayuso <pablo@netfilter.org>
> wrote:
>>
>> On Fri, Sep 09, 2016 at 11:06:51PM +0800, Feng Gao wrote:
>> > How about this patch ?
>>
>> Is this a theoretical problem? I would really prefer if you do your
>> work to collect traces that show that the actual sequence adjustment
>> is not correct.
>>
>> > I think it should be one bug of seqadjust.
>>
>> "I think this is a bug" is not sufficient, I expect you prove this is
>> not correct.
>
>
> Yes. Now I only analyze it by codes, and it should check ack flag in theory.
> Because TCP REST could not contain ack.
>
> But I will set up one environment and generate the packet trace.
>
> Regards
> Feng
>

I have gotten the packet trace which shows seqadj adjusts the 0 ack
value, and sent the v3 patch which contains the reproduce steps,
packet trace, and logs.

Best Regards
Feng
