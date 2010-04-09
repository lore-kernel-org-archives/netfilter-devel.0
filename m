From: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
Subject: Re: [PATCH 2/3] flex_array: export some symbols for nfnetlink_queue
	use
Date: Fri, 9 Apr 2010 13:09:03 +0800
Message-ID: <l2x2375c9f91004082209p9b13a651zc227448380f65b16@mail.gmail.com>
References: <4BBEA87B.4040807@gmail.com>
	 <1270789332.2458.23.camel@edumazet-laptop>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: xiaosuo@gmail.com, Patrick McHardy <kaber@trash.net>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	netfilter-devel@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qy0-f179.google.com ([209.85.221.179]:64919 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab0DIFJE convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 9 Apr 2010 01:09:04 -0400
In-Reply-To: <1270789332.2458.23.camel@edumazet-laptop>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 9, 2010 at 1:02 PM, Eric Dumazet <eric.dumazet@gmail.com> w=
rote:
> Le vendredi 09 avril 2010 =C3=A0 12:09 +0800, Changli Gao a =C3=A9cri=
t :
>> export some symbols for nfnetlink_queue use
>>
>> export some symbols for nfnetlink_queue use.
>>
>> Signed-off-by: Changli Gao <xiaosuo@gmail.com>
>> ----
>> lib/Makefile | 4 ++--
>> lib/flex_array.c | 5 +++++
>> 2 files changed, 7 insertions(+), 2 deletions(-)
>>
>> diff --git a/lib/Makefile b/lib/Makefile
>> index 0a6ab6f..0700e74 100644
>> --- a/lib/Makefile
>> +++ b/lib/Makefile
>> @@ -12,7 +12,7 @@ lib-y :=3D ctype.o string.o vsprintf.o cmdline.o \
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0idr.o int_sqrt.o extable.o prio_tree.o \
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0sha1.o irq_regs.o reciprocal_div.o argv_s=
plit.o \
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0proportions.o prio_heap.o ratelimit.o sho=
w_mem.o \
>> - =C2=A0 =C2=A0 =C2=A0is_single_threaded.o plist.o decompress.o flex=
_array.o
>> + =C2=A0 =C2=A0 =C2=A0is_single_threaded.o plist.o decompress.o
>>
>
> Hmm, could you instead add a lib-$(CONFIG_FLEX_ARRAY) +=3D flex_array=
=2Eo
> instead ?
>
> And do the necessary Kconfig changes as well.
>

Right, if nfnetlink will use flex_array, CONFIG_NETFILTER_NETLINK will
need to depend on or select CONFIG_FLEX_ARRAY.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
