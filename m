From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH] iptables: fix the dead loop when meeting unknown options
Date: Thu, 14 Apr 2011 15:30:41 +0800
Message-ID: <BANLkTinS4yO0uY8BW6SJmVKhSMxJ9+5BmQ@mail.gmail.com>
References: <1300083811-27146-1-git-send-email-xiaosuo@gmail.com> <alpine.LNX.2.01.1104140919470.30983@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-px0-f179.google.com ([209.85.212.179]:62305 "EHLO
	mail-px0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753447Ab1DNHbB convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Apr 2011 03:31:01 -0400
Received: by pxi2 with SMTP id 2so744241pxi.10
        for <netfilter-devel@vger.kernel.org>; Thu, 14 Apr 2011 00:31:01 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1104140919470.30983@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 14, 2011 at 3:20 PM, Jan Engelhardt <jengelh@medozas.de> wr=
ote:
> On Monday 2011-03-14 07:23, Changli Gao wrote:
>
>>Signed-off-by: Changli Gao <xiaosuo@gmail.com>
>>---
>> xshared.c | =A0 =A02 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>diff --git a/xshared.c b/xshared.c
>>index 404a9f5..87402b4 100644
>>--- a/xshared.c
>>+++ b/xshared.c
>>@@ -92,7 +92,7 @@ static bool should_load_proto(struct iptables_comma=
nd_state *cs)
>> =A0 =A0 =A0 if (find_proto(cs->protocol, XTF_DONT_LOAD,
>> =A0 =A0 =A0 =A0 =A0 cs->options & OPT_NUMERIC, NULL) =3D=3D NULL)
>> =A0 =A0 =A0 =A0 =A0 =A0 =A0 return true;
>>- =A0 =A0 =A0return cs->proto_used;
>>+ =A0 =A0 =A0return !cs->proto_used;
>> }
>
> Could you, for completeness, give the command that causes the infinit=
e
> loop?
>

I can't remember it clearly. At that time, I was testing connlimit.
Maybe a spell mistake in the option list for connlimit. You can refer
to the comment above the code, and the code isn't consistent with the
comment. This bug maybe just a typo by you. :)

--=20
Regards,
Changli Gao(xiaosuo@gmail.com)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
