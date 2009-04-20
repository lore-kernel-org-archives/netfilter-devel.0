From: Tim Verhoeven <tim.verhoeven.be@gmail.com>
Subject: Re: Compiling ebtables statically or dynamically results in different
	behaviour
Date: Mon, 20 Apr 2009 11:27:10 +0200
Message-ID: <2a7fce340904200227j42e07fd3gbf507539809a4e08@mail.gmail.com>
References: <W8403423488155181239184148@nocme1bl6.telenet-ops.be>
	 <2a7fce340904080257r4164cd63hcd5f07b036489aae@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: "bdschuym@pandora.be" <bdschuym@telenet.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:35904 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754134AbZDTJ1N convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 20 Apr 2009 05:27:13 -0400
Received: by fxm2 with SMTP id 2so1841347fxm.37
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Apr 2009 02:27:10 -0700 (PDT)
In-Reply-To: <2a7fce340904080257r4164cd63hcd5f07b036489aae@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Apr 8, 2009 at 11:57 AM, Tim Verhoeven
<tim.verhoeven.be@gmail.com> wrote:
> On Wed, Apr 8, 2009 at 11:49 AM, bdschuym@pandora.be
> <bdschuym@telenet.be> wrote:
>> What is your exact command and what type of processor are you using?
>>
>
> The command run is "ebtables -N 1000"
>
> This is /proc/cpuinfo :
> processor =C2=A0 =C2=A0 =C2=A0 : 0
> vendor_id =C2=A0 =C2=A0 =C2=A0 : GenuineIntel
> cpu family =C2=A0 =C2=A0 =C2=A0: 6
> model =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 : 23
> model name =C2=A0 =C2=A0 =C2=A0: Intel(R) Xeon(R) CPU =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 E5430 =C2=A0@ 2.66GHz
=2E..snip...

Hi again,

Is there any update about this issue ? Can I do anything to help debug
 the problem ? I have test machines available.

Thanks,
Tim

--=20
Tim Verhoeven - tim.verhoeven.be@gmail.com - 0479 / 88 11 83

Hoping the problem  magically goes away  by ignoring it is the
"microsoft approach to programming" and should never be allowed.
(Linus Torvalds)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
