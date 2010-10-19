From: AIJAZ BAIG <aijazbaig1@gmail.com>
Subject: Re: Question about ebtables.
Date: Tue, 19 Oct 2010 13:27:36 +0530
Message-ID: <AANLkTikv3h_7ykzVZbhNdGFMY7Pt2DjEbVG59tmtAwQF@mail.gmail.com>
References: <C13A00ED-B438-44A6-82A0-6E7530FB7E8B@gmail.com>
	<AANLkTimXuDFyNZ0WfK5rn8FSE0wuWKU9+UvsuGf9Qb4w@mail.gmail.com>
	<9FE5AE7B-726F-4FDA-972E-177B9C341BA8@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Sumin Xia <xiasumin1984@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:50742 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755964Ab0JSH5h (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Oct 2010 03:57:37 -0400
Received: by vws2 with SMTP id 2so1173206vws.19
        for <netfilter-devel@vger.kernel.org>; Tue, 19 Oct 2010 00:57:36 -0700 (PDT)
In-Reply-To: <9FE5AE7B-726F-4FDA-972E-177B9C341BA8@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Sumin,

Think of the tables as a way to organize tasks that are somewhat
similar. Thus for all the tasks that are related to network address
translation, you have the NAT table whereas basic packet mangling
(which includes identifying and applying certain 'marks' or something
similar) the packet is done in the mangle table. This info can later
be checked in the filter table where the actual filtering takes place.
Each table thus consists of various chains some of which are there by
default whereas one can define custom chains within these existing
chains.

Thus a table has multiple chains and each chain then contains various
matches(optional) followed by a TARGET which gives the verdict.

I hope it helps. To see the organizational structure, im afraid u'd
have to see the code for the tables which are again implemented as
modules (iptable_filter.c, iptable_nat.c etc) in context of the base
ip_tables.c .

Regards,
Aijaz Baig.

On 10/19/10, Sumin Xia <xiasumin1984@gmail.com> wrote:
> Hi Aijaz,
>
> I know that "matches" is used to decide whether a frame matches
> certain conditions or not and "target" is used to do a certain action
> when all matches of a rule are passed. However, I'm not clear what is
> function of "tables". Could you introduce the function of "tables",
> please?
>
> Thanks,
>
> Sumin
> On Oct 18, 2010, at 12:28 AM, AIJAZ BAIG wrote:
>
>> Hi,
>>
>> have you read the man page of the ebtables? There are quite a few
>> targets which modify the MAC address of a given frame like snat,
>> redirect etc. Also please do read the examples at
>> http://ebtables.sourceforge.net/examples/basic.html
>>  and http://ebtables.sourceforge.net/examples/real.html to give you
>> a better idea.
>>
>> Hope it helps.
>>
>> Regards,
>> Aijaz Baig
>>
>> On Mon, Oct 18, 2010 at 6:56 AM, Sumin Xia <xiasumin1984@gmail.com>
>> wrote:
>> Hello,
>>
>> I am new to ebtables. Recently, I am working on a project, which
>> needs to modify mac address of each frame in a middle box in order
>> to forward the frame to next expected middle box. I want to know
>> whether I can modify mac headers by ebtables. And how to modify it?
>>
>> Best,
>>
>> Sumin Xia
>> --
>> To unsubscribe from this list: send the line "unsubscribe netfilter-
>> devel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>


-- 
Best Regards,

Aijaz Baig
