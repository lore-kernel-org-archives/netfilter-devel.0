From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [PATCH 05/17] v4: rename init_extensions() to init_extensions4()
Date: Fri, 1 Apr 2011 14:38:16 -0700
Message-ID: <AANLkTim+sqcwuGgR1-qK1q_0iJTqn7Qkc3sQYJcT2mg3@mail.gmail.com>
References: <AANLkTika7Hgg=AUkkoDE0QroXKnJvA8fr23q-trk8Wbv@mail.gmail.com>
	<1301632053-3694-5-git-send-email-zenczykowski@gmail.com>
	<alpine.LNX.2.01.1104011214570.10168@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48753 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757161Ab1DAVjY convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Apr 2011 17:39:24 -0400
Received: by wya21 with SMTP id 21so3311939wya.19
        for <netfilter-devel@vger.kernel.org>; Fri, 01 Apr 2011 14:39:23 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1104011214570.10168@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

To be able to combine iptables-multi and ip6tables-multi into one
binary (ie. to avoid duplicate symbol definition problems at link
time).

2011/4/1 Jan Engelhardt <jengelh@medozas.de>:
> On Friday 2011-04-01 06:27, Maciej =C5=BBenczykowski wrote:
>>diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
>>index b96bd11..84688d3 100644
>>--- a/extensions/GNUmakefile.in
>>+++ b/extensions/GNUmakefile.in
>>@@ -127,8 +127,8 @@ initext4.c: .initext4.dd
>> =C2=A0 =C2=A0 =C2=A0 for i in ${initext_func}; do \
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 echo "extern void l=
ib$${i}_init(void);" >>$@; \
>> =C2=A0 =C2=A0 =C2=A0 done; \
>>- =C2=A0 =C2=A0 =C2=A0echo "void init_extensions(void);" >>$@; \
>>- =C2=A0 =C2=A0 =C2=A0echo "void init_extensions(void)" >>$@; \
>>+ =C2=A0 =C2=A0 =C2=A0echo "void init_extensions4(void);" >>$@; \
>>+ =C2=A0 =C2=A0 =C2=A0echo "void init_extensions4(void)" >>$@; \
>> =C2=A0 =C2=A0 =C2=A0 echo "{" >>$@; \
>> =C2=A0 =C2=A0 =C2=A0 for i in ${initext_func}; do \
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 echo =C2=A0" ""lib$=
${i}_init();" >>$@; \
>
> And the reason for these renames is...?
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
