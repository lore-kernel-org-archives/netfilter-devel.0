From: =?ISO-8859-1?Q?=C1lvaro_Neira_Ayuso?= <alvaroneay@gmail.com>
Subject: Re: [nftables PATCH v2] src: Replace TOS support for using DSCP support
Date: Mon, 02 Jun 2014 10:06:20 +0200
Message-ID: <538C307C.30405@gmail.com>
References: <1401184815-14002-1-git-send-email-alvaroneay@gmail.com> <1401200300-24583-1-git-send-email-alvaroneay@gmail.com> <20140601202707.GC19396@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f180.google.com ([209.85.212.180]:52989 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751348AbaFBIHD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Jun 2014 04:07:03 -0400
Received: by mail-wi0-f180.google.com with SMTP id hi2so4109689wib.7
        for <netfilter-devel@vger.kernel.org>; Mon, 02 Jun 2014 01:07:02 -0700 (PDT)
In-Reply-To: <20140601202707.GC19396@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

El 01/06/14 22:27, Patrick McHardy escribi=F3:
> On Tue, May 27, 2014 at 04:18:20PM +0200, Alvaro Neira Ayuso wrote:
>> From: =C1lvaro Neira Ayuso <alvaroneay@gmail.com>
>>
>> Signed-off-by: Alvaro Neira Ayuso <alvaroneay@gmail.com>
>> ---
>> [changes in v2]
>> * Replace TOS support for using DSCP support
>>
>> Now, when we add a rule with DSCP, in the code generation step, nfta=
bles
>> compares 1 bytes but it should compare 6 bits. I think that the prob=
lem should
>> be in the code generation.
>
> I don't really see how this patch changes this. The kernel operates i=
n units
> of bytes. For anything smaller nftables will have to generate appropr=
iate
> bitwise operations. Please explain in more detail how this patch chan=
ges this.
>

Now, nothing. For that it's stopped. I'm working for doing a patch for=20
operating in the kernel not only with units of bytes like you say. In a=
=20
couple of days, I'm going to send it to the list.

Thanks for the review, Patrick

=C1lvaro
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
