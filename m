From: =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Subject: Re: [PATCH v2 5/6] netfilter: tarpit: Add IPv6 support
Date: Mon, 9 Jul 2012 13:22:25 -0700
Message-ID: <CAHo-OoxAFPmriPChrzqVOELi4JgNrwu7PfhHcV31e6s-RgGRZw@mail.gmail.com>
References: <1341771085-5771-1-git-send-email-johunt@akamai.com>
	<1341771085-5771-6-git-send-email-johunt@akamai.com>
	<alpine.LNX.2.01.1207082125590.11837@frira.zrqbmnf.qr>
	<4FFAE45D.6070603@akamai.com>
	<alpine.LNX.2.01.1207091855540.1876@frira.zrqbmnf.qr>
	<4FFB14B4.6040801@akamai.com>
	<alpine.LNX.2.01.1207092016370.5417@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Josh Hunt <johunt@akamai.com>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36133 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753073Ab2GIUWZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Jul 2012 16:22:25 -0400
Received: by obbuo13 with SMTP id uo13so21030066obb.19
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Jul 2012 13:22:25 -0700 (PDT)
In-Reply-To: <alpine.LNX.2.01.1207092016370.5417@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We want this ;-)

On Mon, Jul 9, 2012 at 11:46 AM, Jan Engelhardt <jengelh@inai.de> wrote:
>
> On Monday 2012-07-09 19:28, Josh Hunt wrote:
>>> I held it off; this is now all merged.
>>
>> Awesome, thanks!
>>
>> I know this just got accepted to xtables-addons, but I was wondering what the
>> process is to possibly get this merged into Linus' tree?
>
> You send the files that are in xtables-addons to whoever is taking care
> of the Linux kernel business (currently that seems to be Pablo), of course
> in a form that is acceptable for the Linux kernel (i.e. minus xtables-addons
> lines).
>
>>I know I've seen some things go from xtables-addons to his tree,
>>xt_TEE comes to mind. Is tarpitting (the concept) something that
>>would be accepted?
>
> It certainly seems well-desired by $users. And normally, inclusion
> is to follow demand (that's how squashfs got in, IIRC). Expect
> to defend your case when making it upstream. Solicit more "we want
> this opinions" :)
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
