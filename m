From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] libipt_REDIRECT: "--to-ports" is not mandatory
Date: Wed, 18 May 2011 23:16:32 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1105182316010.8472@frira.zrqbmnf.qr>
References: <1305724307-13698-1-git-send-email-ljaenicke@innominate.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Lutz Jaenicke <ljaenicke@innominate.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:44018 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752634Ab1ERVQd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 May 2011 17:16:33 -0400
In-Reply-To: <1305724307-13698-1-git-send-email-ljaenicke@innominate.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2011-05-18 15:11, Lutz Jaenicke wrote:

>The REDIRECT target can be called without the --to-ports option
>being specified. From the manual page:
>  ...without this, the destination port is never altered.

Taken, thanks. (If you can provide git-pullable trees, I would prefer 
that over loose mails if possible.)
