From: =?UTF-8?Q?Ville_Skytt=C3=A4?= <ville.skytta@iki.fi>
Subject: Re: [PATCH] iptables: Spelling fixes
Date: Sun, 6 Sep 2015 10:30:28 +0300
Message-ID: <CABr9L5BtsG-mzA4LrN0TANPFG-9L8bOeLL6O=M9D4P9d52putw@mail.gmail.com>
References: <20150905210746.GA13600@salvia> <1441520550-526-1-git-send-email-ville.skytta@iki.fi>
 <alpine.LSU.2.20.1509060915240.28331@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:35062 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750883AbbIFHat convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Sep 2015 03:30:49 -0400
Received: by lbpo4 with SMTP id o4so27054803lbp.2
        for <netfilter-devel@vger.kernel.org>; Sun, 06 Sep 2015 00:30:48 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.20.1509060915240.28331@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Sep 6, 2015 at 10:15 AM, Jan Engelhardt <jengelh@inai.de> wrote=
:
>
> On Sunday 2015-09-06 08:22, Ville Skytt=C3=A4 wrote:
>>
>>-/* print a given ip including mask if neccessary */
>>+/* Print a given ip including mask if necessary.
>>+ */
>> static void print_ip(const char *prefix, const struct in6_addr *ip,
>>                    const struct in6_addr *mask, int invert)
>> {
>
> Hm that really looks worse than it did before.

Well, I believe it matches the instructions for block formatting I was
given by Pablo. If it doesn't, I suggest applying my original patch
which didn't do anything but the spelling fixes -- I'm not going to
spend any more time on this.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
