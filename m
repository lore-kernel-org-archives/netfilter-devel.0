From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH iptables] libxt_length: update to revision 1
Date: Sat, 24 Jul 2010 13:43:59 +0800
Message-ID: <AANLkTi=BiR1GbDZ9NyCSY1VBLy_2_HqKq61gKoFc2Cdb@mail.gmail.com>
References: <1279945746-24034-1-git-send-email-xiaosuo@gmail.com>
	<1279949326.2451.47.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:32802 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab0GXFoU convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 24 Jul 2010 01:44:20 -0400
Received: by vws3 with SMTP id 3so979728vws.19
        for <netfilter-devel@vger.kernel.org>; Fri, 23 Jul 2010 22:44:19 -0700 (PDT)
In-Reply-To: <1279949326.2451.47.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jul 24, 2010 at 1:28 PM, Eric Dumazet <eric.dumazet@gmail.com> =
wrote:
> Le samedi 24 juillet 2010 =E0 12:29 +0800, Changli Gao a =E9crit :
>> update libxt_length to revision 1 to support ipv6 jumbo frames.
>>
>> Signed-off-by: Changli Gao <xiaosuo@gmail.com>
>> ----
>> =A0extensions/libxt_length.c =A0 =A0 =A0 =A0 =A0 | =A0 =A01 +
>> =A0include/linux/netfilter/xt_length.h | =A0 =A02 +-
>> =A02 files changed, 2 insertions(+), 1 deletion(-)
>> diff --git a/extensions/libxt_length.c b/extensions/libxt_length.c
>> index 96e8b6c..5d0f5e9 100644
>> --- a/extensions/libxt_length.c
>> +++ b/extensions/libxt_length.c
>> @@ -125,6 +125,7 @@ static struct xtables_match length_match =3D {
>> =A0 =A0 =A0 .print =A0 =A0 =A0 =A0 =A0=3D length_print,
>> =A0 =A0 =A0 .save =A0 =A0 =A0 =A0 =A0 =3D length_save,
>> =A0 =A0 =A0 .extra_opts =A0 =A0 =3D length_opts,
>> + =A0 =A0 .revision =A0 =A0 =A0 =3D 1,
>> =A0};
>>
>> =A0void _init(void)
>
> Hmm... I think you missed at line 50 :
>
>
> =A0 =A0 =A0 =A0info->max =3D cp[0] ? parse_length(cp) : 0xFFFF;
>
> Or document the thing...
>

Oh, thanks. I think we can change 0xFFFF to 0xFFFFFFFF, and I also
need to update the return value of parse_length() to u_int32_t.

--=20
Regards,
Changli Gao(xiaosuo@gmail.com)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
