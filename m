From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Re: [PATCH netfilter: nft] Add the connmark meta_key
Date: Mon, 6 Jan 2014 19:09:58 +0100
Message-ID: <CAKfDRXir46pGb8-YpdW54RMgkdB11YEmqR_VNMJd3CTJKEo6TQ@mail.gmail.com>
References: <1389027476-16837-1-git-send-email-kristian.evensen@gmail.com>
	<20140106170523.GA9894@breakpoint.cc>
	<20140106171523.GC23002@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:59743 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755809AbaAFSJ6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jan 2014 13:09:58 -0500
Received: by mail-pd0-f173.google.com with SMTP id p10so18490601pdj.32
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Jan 2014 10:09:58 -0800 (PST)
In-Reply-To: <20140106171523.GC23002@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

On Mon, Jan 6, 2014 at 6:15 PM, Patrick McHardy <kaber@trash.net> wrote:
> Well, actually the ct expression already supports connmark, as does userspace.
>
> #ifdef CONFIG_NF_CONNTRACK_MARK
>         case NFT_CT_MARK:
>                 dest->data[0] = ct->mark;
>                 return;
> #endif

Thank you very much for pointing this out. I will change my approach
and add a set command in ct (similar to what was recently added to
meta). Or is someone already working on this?

-Kristian
