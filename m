From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: xt_target checkentry()/destroy() semantics
Date: Wed, 11 Jan 2012 02:27:26 -0800
Message-ID: <CAHo-Oow9fZg+O6jkmzN2cLooE6TwsFmOib+1gF5_VXtwXRt=Wg@mail.gmail.com>
References: <4F0CE6C0.6080900@nod.at>
	<alpine.LNX.2.01.1201110741110.27346@frira.zrqbmnf.qr>
	<4F0D5BE4.3040509@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Richard Weinberger <richard@nod.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:50853 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755776Ab2AKK11 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jan 2012 05:27:27 -0500
Received: by obbup16 with SMTP id up16so652267obb.19
        for <netfilter-devel@vger.kernel.org>; Wed, 11 Jan 2012 02:27:26 -0800 (PST)
In-Reply-To: <4F0D5BE4.3040509@nod.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

every change, whether addition or deletion is done via table-replacement.
the only modification operation supported is table replacement.
so you're making 6 table replecaments with those 6 commands.


On Wed, Jan 11, 2012 at 01:52, Richard Weinberger <richard@nod.at> wrote:
> Am 11.01.2012 07:45, schrieb Jan Engelhardt:
>> On Wednesday 2012-01-11 02:32, Richard Weinberger wrote:
>>
>>> Hi!
>>>
>>> I always thought that checkentry()/destroy() are being called upon rule insertion/deletion.
>>> So I assumed that this command sequence prints three times "test_tg_check" and then three times
>>> "test_tg_destroy". But it's not the case.
>>
>> One table-replace operation implies add-delete of all rules.
>
> Okay, I did not know that my simple command sequence is causing a table-replacement.
> Why?
>
> I thought it appends (-A) only...
>
> Thanks,
> //richard
>
