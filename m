From: Brian Gerst <brgerst@gmail.com>
Subject: Re: help needed with EXPORT_SYMBOL
Date: Mon, 23 Aug 2010 07:48:06 -0400
Message-ID: <AANLkTimtNOyJCbLxAW8Ebsftb58EWoNFW7Xkevqb6oGo@mail.gmail.com>
References: <1282373834.4080.79.camel@aijazbaig1-desktop>
	<1282540448.4080.86.camel@aijazbaig1-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, jengelh@medozas.de,
	linux-kernel@vger.kernel.org
To: aijazbaig1@gmail.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:41255 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab0HWLsI convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Aug 2010 07:48:08 -0400
In-Reply-To: <1282540448.4080.86.camel@aijazbaig1-desktop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 23, 2010 at 1:14 AM, Aijaz Baig <aijazbaig1@gmail.com> wrot=
e:
> Hello,
>
> Yeah I do understand that part, but there has to be a way to do what =
I
> am trying to do here isn't it?
>
> And can anyone tell me can kallsyms_lookup() be used in such a
> situation? If yes than how do I use it?
>
> Regards,
> Aijaz
>
> On Sat, Aug 21, 2010 at 2:53 PM, Jan =C2=A0Engelhardt <jengelh@medoza=
s.de>
> wrote:
> On Saturday 2010-08-21 08:57, Aijaz Baig wrote:
>
>>So why is it that when my netfilter module is exporting something to
>>the kernel and im tryin to use it from within a core kernel file, the
>>compiler flags a 'undefined reference to' error?
>
> There, you answered yourself. Exports only go one way. And that is
> core -> module -> module.
>
> On Sat, 2010-08-21 at 12:27 +0530, Aijaz Baig wrote:
>> Hello,
>>
>> Ive been trying to EXPORT a SYMBOL from a netfilter module (actually=
 a
>> hook) to the KERNEL. Various modules seem to export various symbols =
to
>> the kernel (or so it seems), an example being x_tables which exports=
 a
>> whole lot of functions like xt_register_target and so on and all oth=
er
>> netfilter modules which use these functions dont seem to have any
>> problems.
>>
>> So why is it that when my netfilter module is exporting something to=
 the
>> kernel and im tryin to use it from within a core kernel file, the
>> compiler flags a 'undefined reference to' error?
>>
>> I googled and came to the conclusion from the kernelnewbies mailing =
list
>> that using kallsyms_lookup() seems to be the answer or is it?
>> So, if I do intend to use kallsyms_lookup how do I use it? There are=
n't
>> so many instances of it being used it seems.
>>
>> Ive seen it being used in dev/core.c like so:
>> symname =3D kallsyms_lookup((unsigned long)sym, &symsize,&offset,&mo=
dname,
>> namebuf);
>>
>> I am basically trying to call a function that MY module EXPORTs insi=
de
>> one of the core linux routines. This would also mean that my netfilt=
er
>> module must be compiled (and linked also maybe?..not so sound with l=
ink
>> time stuff) before the address becomes visible so that kallsyms_look=
up
>> can find it. So do I really shd be using it and if so, how?
>>
>> Any input is appreciated.
>>
>> Regards,
>> Aijaz Baig.
>>
>>

Use an exported function pointer in the main kernel as a hook that the
module sets when it is loaded.  Note, you must use module_get and
module_put around the call to the module to prevent it from unloading
while in use.

--
Brian Gerst
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
