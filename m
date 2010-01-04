From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/3] netfilter: xt_recent: save 8 bytes per htable
Date: Mon, 04 Jan 2010 16:26:26 +0100
Message-ID: <4B4208A2.9030100@trash.net>
References: <1260044785-20962-1-git-send-email-jengelh@medozas.de> <1260044785-20962-2-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:36333 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833Ab0ADP03 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Jan 2010 10:26:29 -0500
In-Reply-To: <1260044785-20962-2-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Moving rnd_inited into the hole after the uint8 lets go of the uint32
> rnd_inited was using, plus the padding that would follow the int group.

Applied, thanks Jan.
