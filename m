From: Sam Roberts <vieuxtech@gmail.com>
Subject: Re: is assert() an appropriate substitute for return -1?
Date: Mon, 28 Mar 2011 08:47:30 -0700
Message-ID: <AANLkTimz=-HKcZUBDad+Q=fYpDV78BbpKCnPj71yr3Ph@mail.gmail.com>
References: <AANLkTikDX+SqxROiZDQZXop_Ooiv9QXZR3JJ66sG2m--@mail.gmail.com>
	<4D908443.6070703@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vx0-f174.google.com ([209.85.220.174]:36328 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753819Ab1C1Ps0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 28 Mar 2011 11:48:26 -0400
Received: by vxi39 with SMTP id 39so2380952vxi.19
        for <netfilter-devel@vger.kernel.org>; Mon, 28 Mar 2011 08:48:25 -0700 (PDT)
In-Reply-To: <4D908443.6070703@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 28, 2011 at 5:51 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>> Is it worth supplying patches?
>
> I read once in the manpages that you can disable assert() macro with NDEBUG.
>
> Is that enough for you?

No, this only changes the signal number (instead of terminating with
SIGABRT, process will terminate with SISEGV when the null pointers are
used).

The asserts could be changed to #define argassert(x)
if(!x){errno=EINVAL; return -1;} -- mostly the asserts occur before
anything is done that would require cleanup.

Cheers,
Sam
