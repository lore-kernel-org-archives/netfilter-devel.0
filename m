From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Re: [PATCH netfilter: nft] Add the connmark meta_key
Date: Mon, 6 Jan 2014 22:00:42 +0100
Message-ID: <CAKfDRXihd_+pwiKc5G9Zv35i5POeXC3wyu2DDvunntpz11VMaA@mail.gmail.com>
References: <1389027476-16837-1-git-send-email-kristian.evensen@gmail.com>
	<20140106170523.GA9894@breakpoint.cc>
	<20140106171523.GC23002@macbook.localnet>
	<CAKfDRXir46pGb8-YpdW54RMgkdB11YEmqR_VNMJd3CTJKEo6TQ@mail.gmail.com>
	<20140106181928.GA19666@macbook.localnet>
	<CAKfDRXgPaCic9=qxSc5G=QvoX7xti3z8ii94ysBLwRrm4hDy3Q@mail.gmail.com>
	<20140106205405.GA3236@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:58565 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756284AbaAFVAm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jan 2014 16:00:42 -0500
Received: by mail-pb0-f41.google.com with SMTP id jt11so19102105pbb.0
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Jan 2014 13:00:42 -0800 (PST)
In-Reply-To: <20140106205405.GA3236@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Mon, Jan 6, 2014 at 9:54 PM, Patrick McHardy <kaber@trash.net> wrote:
> I see. We need a meta statement for this in userspace and corresponding
> support for the kernel. I thought we'd had an example how to do this in
> the meta expression, but apparently this is wrong. I'll add it for the
> meta expression during the next days so you have a reference.

I am not sure if I understand you correctly, but meta set is already
there. My plan was to use nft_meta (and the related parts in
nftables/libnftables) as a reference for how to add set and add
support for something like:

nft filter postrouting ct mark set "meta mark"

Or is there something I dont see/understand?

-Kristian
