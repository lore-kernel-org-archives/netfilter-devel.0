From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH v0] netns NOTRACK
Date: Thu, 11 Feb 2010 19:04:13 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002111903100.19618@obet.zrqbmnf.qr>
References: <20100211173117.GD4099@x200> <4B744565.2010808@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Alexey Dobriyan <adobriyan@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:48821 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755311Ab0BKSEO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Feb 2010 13:04:14 -0500
In-Reply-To: <4B744565.2010808@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2010-02-11 18:59, Patrick McHardy wrote:
>Alexey Dobriyan wrote:
>> This is netns NOTRACK fix we discussed earlier.
>> 
>> The idea was to remove nf_conntrack_untracked and
>> declare that ->nfct=NULL and ->nfctinfo=IP_CT_UNTRACKED are untracked
>> connections.

As invalid connections used nfct=NULL, how are they now
checked for?
