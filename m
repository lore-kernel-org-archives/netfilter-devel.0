From: Luciano Coelho <luciano.coelho@nokia.com>
Subject: Re: [PATCH 1/1] extensions: add idletimer xt target extension
Date: Mon, 14 Jun 2010 17:44:15 +0300
Message-ID: <1276526655.2092.34.camel@chilepepper>
References: <1276525990-7058-1-git-send-email-luciano.coelho@nokia.com>
	 <1276525990-7058-2-git-send-email-luciano.coelho@nokia.com>
	 <alpine.LSU.2.01.1006141639390.32450@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: "kaber@trash.net" <kaber@trash.net>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
	"Rissanen Jukka (Nokia-D/Helsinki)" <Jukka.Rissanen@nokia.com>
To: ext Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:32465 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753369Ab0FNOoq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Jun 2010 10:44:46 -0400
In-Reply-To: <alpine.LSU.2.01.1006141639390.32450@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 2010-06-14 at 16:40 +0200, ext Jan Engelhardt wrote:
> On Monday 2010-06-14 16:33, Luciano Coelho wrote:
> >+#ifndef _XT_IDLETIMER_H
> >+#define _XT_IDLETIMER_H
> >+
> >+#include <linux/types.h>
> >+
> >+#define MAX_IDLETIMER_LABEL_SIZE 32
> 
> I suggest we go down to 28 on this one, so that there won't
> be a wasted padding hole on 64-bit.

Okay, I'll send v5 of my kernel patch and v2 of the extension.

-- 
Cheers,
Luca.

