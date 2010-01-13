From: Dong Wei <dwei.zh@gmail.com>
Subject: Re: Port back 2.6 kernel patch to 2.4 which fixed bridge module panic
	when received special fragments
Date: Wed, 13 Jan 2010 17:42:21 +0800
Message-ID: <3104bfb61001130142p5011c1cj6b01bf80ea9aee21@mail.gmail.com>
References: <3104bfb61001130130s4fbf1649oa9a12e7c855cc6e@mail.gmail.com>
	 <4B4D9355.5000907@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.25]:41863 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755267Ab0AMJmW convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 13 Jan 2010 04:42:22 -0500
Received: by qw-out-2122.google.com with SMTP id 8so3567529qwh.37
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Jan 2010 01:42:21 -0800 (PST)
In-Reply-To: <4B4D9355.5000907@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi, Patrick

Thanks for your reply.

I checked the ebtables website, but the mail-list just point to the
netfilter mail list.

So, would you please tell me who should I send this mail to ?

2010/1/13 Patrick McHardy <kaber@trash.net>:
> Dong Wei wrote:
>> Hi, All
>>
>> linux-2.6.32.3 fixed a kernel panic problem in bridge module when
>> received special fragments.
>>
>> see: http://git.kernel.org/?p=3Dlinux/kernel/git/hpa/linux-2.6-allst=
able.git;a=3Dcommit;h=3D8fa9ff6849bb86c59cc2ea9faadf3cb2d5223497
>>
>> There is a ebtables kernel patch ebtables-brnf-11-2_vs_2.4.31.diff.g=
z
>> which port back bridge netfilter. =A0After applied the kernel patch,=
 the
>> kernel panic problem will be introduced to the kernel. I made a kern=
el
>> patch on 2.4.37.7 which can fix this problem. I think this patch
>> should be merged to the ebtables-brnf-11-2_vs_2.4.31.diff.gz .
>
> You need to send this to whomever is maintaining that patch,
> probably Bart.
>
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
