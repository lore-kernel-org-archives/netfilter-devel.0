From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/4] netfilter: print the list of register loggers.
Date: Mon, 16 Feb 2009 18:11:15 +0100
Message-ID: <49999E33.9070307@trash.net>
References: <49980BA7.2040108@inl.fr> <1234701437-2754-3-git-send-email-eric@inl.fr> <alpine.LSU.2.00.0902161753530.26651@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Eric Leblond <eric@inl.fr>, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63518 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718AbZBPRLS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 16 Feb 2009 12:11:18 -0500
In-Reply-To: <alpine.LSU.2.00.0902161753530.26651@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> The seqprinting (knowingly that I suggested it) has a bit of a drawback
> the way you use it -- if userspace passes a buffer of, say, size 11,
> then the first seq_printf will succeed in stuffing " 1 NONE (" into
> the buffer; it then has 2 left. Because t->name is probably more descriptive
> than that, the second seq_printf will fail, breaking out of the loop,
> calling seq_stop, etc. and userspace gets 9 as the return value for
> the read() it attempted. However, when userspace now tries to read()
> again, as it is absolutely entitled to, the " 1 NONE (" will be printed
> again into the buffer -- which is rather undesirable.
> ...
> Maybe the authors of seq_file can offer some better function that
> takes care of this?

seqfile operates on records not characters and always provides
one page of memory.

