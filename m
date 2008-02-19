From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] libnetfilter_queue: align the buffer passed to nfnl_fill_hdr
Date: Tue, 19 Feb 2008 13:17:13 +0100
Message-ID: <47BAC8C9.2000001@trash.net>
References: <ac67d9130801271337s562eebabt7b7332a5f14b9a82@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Silvester Erdeg <slipszi@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep32-int.chello.at ([62.179.121.50]:47193 "EHLO
	viefep32-int.chello.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750869AbYBSMRb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Feb 2008 07:17:31 -0500
In-Reply-To: <ac67d9130801271337s562eebabt7b7332a5f14b9a82@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Silvester Erdeg wrote:
> The buffer passed to nfnl_fill_hdr needs to aligned because some
> architectures (e.g. ARM) cannot do proper 32-bit read/writes on
> unaligned addresses. This patch solves this for libnetfilter_queue.


This does not apply cleanly because your mailer seems to
have wrapped long lines. Could you resend as attachment?
