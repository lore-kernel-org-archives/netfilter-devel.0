From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] libxtables: change option precedence order to be
 intuitive
Date: Mon, 25 Oct 2010 23:57:57 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1010252357270.18188@obet.zrqbmnf.qr>
References: <1287501388-5948-1-git-send-email-jengelh@medozas.de> <1287501388-5948-2-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:53679 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756153Ab0JYV57 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Oct 2010 17:57:59 -0400
In-Reply-To: <1287501388-5948-2-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2010-10-19 17:16, Jan Engelhardt wrote:

>When using `-m mark --mark 2 -m connmark --mark 2`, the user currently
>gets an error about the (libxt_mark) --mark option being used twice.
>This is because libxt_connmark's option table does not override any
>previous options. This patch changes this behavior, since the current
>behavior does not allow connmark's option to be used at all, which is
>illogical.

As per fw's suggestion, I should nag you every 48 hours ;-)

Really, this should be in the next tag.

