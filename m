From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: nf-next: more cleanups, int error reporting
Date: Sun, 21 Mar 2010 03:46:05 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003210345210.6476@obet.zrqbmnf.qr>
References: <1269046942-31719-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38031 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752932Ab0CUCqJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 20 Mar 2010 22:46:09 -0400
In-Reply-To: <1269046942-31719-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Saturday 2010-03-20 02:02, Jan Engelhardt wrote:
>
>I've split the big changes from the error reporting into three commits
>so as to
> - make patch 6 as small as possible
> - separate patch 6 for bisecting
>because it is a potentially error-prone part.
>
>
>Please review. (And, if clear, pull :)

I'm retracting this for now due to the incompleteness of, you figured 
it, number 6.
