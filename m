From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/1] Conntrack event generation control, kernel part
Date: Tue, 12 May 2009 15:23:04 +0200
Message-ID: <4A097838.1080905@netfilter.org>
References: <alpine.DEB.2.00.0905121348460.28379@blackhole.kfki.hu> <alpine.LSU.2.00.0905121445460.31110@fbirervta.pbzchgretzou.qr> <alpine.DEB.2.00.0905121515530.28379@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Patrick McHardy <kaber@trash.net>,
	netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34814 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752703AbZELNXO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 May 2009 09:23:14 -0400
In-Reply-To: <alpine.DEB.2.00.0905121515530.28379@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jozsef Kadlecsik wrote:
> Hi Jan,
> 
> On Tue, 12 May 2009, Jan Engelhardt wrote:
> 
>> On Tuesday 2009-05-12 13:52, Jozsef Kadlecsik wrote:
>>
>>> diff --git a/net/netfilter/xt_CONNMARK.c b/net/netfilter/xt_CONNMARK.c
>>> index d6e5ab4..86bc5ea 100644
>>> --- a/net/netfilter/xt_CONNMARK.c
>>> +++ b/net/netfilter/xt_CONNMARK.c
>>> +
>>> +struct compat_xt_connmark_tginfo1 {
>>> +	__u32 ctmark, ctmask, nfmask;
>>> +	__u8 mode;
>>> +	__u8 __pad1;
>>> +	__u16 __pad2;
>>> +};
>> v1 does not need a compat mode, because it does not use 'int' or 'long'.
>> Note: 'compat' here means "32-bit userspace with a 64-bit kernel". It
>> does not mean converting v1 to v2.
> 
> Ahh, I'm blind, thanks! And the comments on the userspace part too - I'm 
> going to fix and resend the patches.

Well, let's talk about the forest before looking at the trees :)

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
