From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH] netfilter: avoid additional compare.
Date: Wed, 4 Nov 2009 21:27:47 +0800
Message-ID: <412e6f7f0911040527x5aee566i73ac98880bb430d5@mail.gmail.com>
References: <4AEF9D99.5070804@gmail.com> <4AF1700F.1090401@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pw0-f42.google.com ([209.85.160.42]:48297 "EHLO
	mail-pw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753750AbZKDN1m convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Nov 2009 08:27:42 -0500
Received: by pwj9 with SMTP id 9so3167539pwj.21
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Nov 2009 05:27:47 -0800 (PST)
In-Reply-To: <4AF1700F.1090401@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 4, 2009 at 8:14 PM, Patrick McHardy <kaber@trash.net> wrote=
:
> Changli Gao wrote:
>> avoid additional compare.
>>
>> avoid additional compare.
>
> This doesn't even compile:
>
> net/netfilter/nf_conntrack_core.c: In function 'early_drop':
> net/netfilter/nf_conntrack_core.c:522: error: 'NF_CT_EVICITON_RANGE'
> undeclared (first use in this function)
>
> Please don't send me untested patches.
>

Oh, I am sorry. I sent the wrong version. :( The macro
NF_CT_EVICITON_RANGE should be NF_CT_EVICITION_RANGE.

--=20
Regards=EF=BC=8C
Changli Gao(xiaosuo@gmail.com)
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
