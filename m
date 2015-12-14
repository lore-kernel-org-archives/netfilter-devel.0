From: Caroline Tice <cmtice@google.com>
Subject: Re: [PATCH v4] libmnl: Drop the EXPORT_SYMBOL() tags
Date: Mon, 14 Dec 2015 09:37:52 -0800
Message-ID: <CABtf2+TE2w0tGzOQZ+qSSLoNqKVmiXUUpS0uh+yie1PhVf2vPw@mail.gmail.com>
References: <20151029190717.GE5154@vapier.lan> <CAMQP0snn7nt=iK6Um4doYFPSn1ffTDtUOKi8NBjp=ZCE58EXQw@mail.gmail.com>
 <20151214123731.GA26186@salvia> <CABtf2+TgFhMvGPjFR=w91wmaGgtSUTaF-mxxKY7HXsxeQ9u3Tw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Neutron Soutmun <neo.neutron@gmail.com>,
	20151006012711.GA5372@oxygen.gentoo.org,
	netfilter-devel@vger.kernel.org, Mike Frysinger <vapier@gentoo.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ig0-f177.google.com ([209.85.213.177]:37563 "EHLO
	mail-ig0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752862AbbLNRiM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Dec 2015 12:38:12 -0500
Received: by igcto18 with SMTP id to18so88073543igc.0
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Dec 2015 09:38:12 -0800 (PST)
In-Reply-To: <CABtf2+TgFhMvGPjFR=w91wmaGgtSUTaF-mxxKY7HXsxeQ9u3Tw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Trying again; the mailer rejected my initial email.

-- Caroline
cmtice@google.com


On Mon, Dec 14, 2015 at 9:34 AM, Caroline Tice <cmtice@google.com> wrote:
> I did talk with some Clang developers initially, to try to determine
> if this was in fact a Clang bug and therefore would need to be fixed
> in Clang.  The answer I got was a resounding  no, this is not a Clang
> bug; it is, in fact a GCC bug -- an example of GCC being overly
> permissive (which, sadly, is not that uncommon).  After a function has
> been *declared*  (the header, but no code), it is still ok to change
> the visibility of the function.  However after the function has
> actually been *defined*, changing the visibility of the function is
> illegal.  That is why moving all of the EXPORT_SYMBOL statements from
> after the function code to before the function code fixes the problem,
> as far as Clang is concerned.
>
> -- Caroline
> cmtice@google.com
>
>
> On Mon, Dec 14, 2015 at 4:37 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> Cc'ing everyone that has sent patches to us to address libmnl
>> compilation problems with clang.
>>
>> On Sat, Nov 14, 2015 at 07:45:44AM +0700, Neutron Soutmun wrote:
>>> The initial problem for my proposed patch is the incompatible of
>>> symbols visibility in gcc and clang
>>> which libmnl is failed to build from source in clang and it's the one
>>> of another approaches that pass the build in both gcc and clang.
>>>
>>> I'll test your patch with clang and back to you ASAP.
>>
>> Did anyone consider going back to the clang community and ask why
>> EXPORT_SYMBOL() definition is not correct there?
>>
>> I understand removing this from our libraries is a quick solution, but
>> I think it would be to get feedback from them to see if it's something
>> that they can fix there (it would resolve problems for projects a using
>> similar definition without updating the code).
>>
>> Let me know, thanks.
