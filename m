From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 1/8] [NETFILTER]: Rename ipt_recent to xt_recent
Date: Wed, 9 Apr 2008 14:50:19 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804091447590.4411@fbirervta.pbzchgretzou.qr>
References: <5130e28c2130c57a9a07ae21c552fe7db519473c.1207668694.git.jengelh@computergmbh.de> <47FCBA50.9010408@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:49959 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751673AbYDIMuV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2008 08:50:21 -0400
In-Reply-To: <47FCBA50.9010408@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-04-09 14:45, Patrick McHardy wrote:

> Jan Engelhardt wrote:
>> Like with other modules (such as ipt_state), ipt_recent.h is changed
>> to forward definitions to (IOW include) xt_recent.h, and xt_recent.c
>> is changed to use the new constant names.
>
> Applied. One question:
>
>> --- a/net/ipv4/netfilter/ipt_recent.c
>> +++ b/net/netfilter/xt_recent.c
>
> I like this format since it only shows the real differences
> made during the move. I'm wondering how to apply it so it
> also performs the rename though.
>

Does not git apply automatically do the right thing? It's git-apply
after all, it should see when a patch was obviously created
with git diff -M / git-format-patch -M.

Workaround for gnupatch on the other hand: do the move by hand,
then apply.
