From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Re: [PATCH netfilter: nft] Add the connmark meta_key
Date: Mon, 6 Jan 2014 20:25:39 +0100
Message-ID: <CAKfDRXgPaCic9=qxSc5G=QvoX7xti3z8ii94ysBLwRrm4hDy3Q@mail.gmail.com>
References: <1389027476-16837-1-git-send-email-kristian.evensen@gmail.com>
	<20140106170523.GA9894@breakpoint.cc>
	<20140106171523.GC23002@macbook.localnet>
	<CAKfDRXir46pGb8-YpdW54RMgkdB11YEmqR_VNMJd3CTJKEo6TQ@mail.gmail.com>
	<20140106181928.GA19666@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f41.google.com ([209.85.160.41]:62458 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755273AbaAFTZk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jan 2014 14:25:40 -0500
Received: by mail-pb0-f41.google.com with SMTP id jt11so18997826pbb.0
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Jan 2014 11:25:39 -0800 (PST)
In-Reply-To: <20140106181928.GA19666@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 6, 2014 at 7:19 PM, Patrick McHardy <kaber@trash.net> wrote:
>
> Not sure what you're trying to achieve, we already support the connmark
> in the ct expression:
>
> nft filter output ct mark 0x1 ...

What I want to achieve is to have functionality similar to connmark
--save-mark, so that we can also set the connmark.

-Kristian
