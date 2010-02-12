From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH v0] netns NOTRACK
Date: Fri, 12 Feb 2010 14:24:50 +0200
Message-ID: <b6fcc0a1002120424o17b278dqf0da86666bda7e62@mail.gmail.com>
References: <20100211173117.GD4099@x200> <4B744565.2010808@trash.net>
	 <alpine.LSU.2.01.1002111903100.19618@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-iw0-f201.google.com ([209.85.223.201]:48671 "EHLO
	mail-iw0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754168Ab0BLMYu (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Feb 2010 07:24:50 -0500
Received: by iwn39 with SMTP id 39so549296iwn.1
        for <netfilter-devel@vger.kernel.org>; Fri, 12 Feb 2010 04:24:50 -0800 (PST)
In-Reply-To: <alpine.LSU.2.01.1002111903100.19618@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Feb 11, 2010 at 8:04 PM, Jan Engelhardt <jengelh@medozas.de> wrote:
> On Thursday 2010-02-11 18:59, Patrick McHardy wrote:
>>Alexey Dobriyan wrote:
>>> This is netns NOTRACK fix we discussed earlier.
>>>
>>> The idea was to remove nf_conntrack_untracked and
>>> declare that ->nfct=NULL and ->nfctinfo=IP_CT_UNTRACKED are untracked
>>> connections.
>
> As invalid connections used nfct=NULL, how are they now
> checked for?

Sorry? if ->nfct == NULL && ->nfctinfo == IP_CT_UNTRACKED,
then untracked, otherwise invalid.
Additional checks were inserted where necesary.
