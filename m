From: Brian Gerst <brgerst@gmail.com>
Subject: Re: help needed with EXPORT_SYMBOL
Date: Mon, 23 Aug 2010 09:44:26 -0400
Message-ID: <AANLkTinq5APN4CXWAGj9sTFiTf4Cn1_mDaJSrAOh=t+N@mail.gmail.com>
References: <1282373834.4080.79.camel@aijazbaig1-desktop>
	<1282540448.4080.86.camel@aijazbaig1-desktop>
	<AANLkTimtNOyJCbLxAW8Ebsftb58EWoNFW7Xkevqb6oGo@mail.gmail.com>
	<1282569477.2605.1798.camel@laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: aijazbaig1@gmail.com, netfilter-devel@vger.kernel.org,
	jengelh@medozas.de, linux-kernel@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59314 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752819Ab0HWNo1 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Aug 2010 09:44:27 -0400
In-Reply-To: <1282569477.2605.1798.camel@laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 23, 2010 at 9:17 AM, Peter Zijlstra <peterz@infradead.org> =
wrote:
> On Mon, 2010-08-23 at 07:48 -0400, Brian Gerst wrote:
>>
>> Use an exported function pointer in the main kernel as a hook that t=
he
>> module sets when it is loaded. =C2=A0Note, you must use module_get a=
nd
>> module_put around the call to the module to prevent it from unloadin=
g
>> while in use.
>
> Please don't do any such thing, its impossible to use correctly.
>
> Suppose there are two modular users, A and B.
>
> Both have something like:
>
> extern void (*fptr)(void);
>
> static void (*old_fptr)(void);
>
> static void func(void)
> {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0/* foo */
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (old_fptr)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0old_fptr();
> }
>
> module_init()
> {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0old_fptr =3D fptr;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0fptr =3D A_func;
> }
>
> Then you load A, load B and unload A, then guess what happens?
>

The assumption was that there was a single module using that hook.
=46or multiple users you'd need to use a register function that adds th=
e
module to a linked list.

--
Brian Gerst
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
