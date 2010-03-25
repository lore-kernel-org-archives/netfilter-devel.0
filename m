From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 2/5] netfilter: xt extensions: use pr_<level> (2)
Date: Thu, 25 Mar 2010 15:11:56 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003251510540.32573@obet.zrqbmnf.qr>
References: <1269521809-29393-1-git-send-email-jengelh@medozas.de> <1269521809-29393-3-git-send-email-jengelh@medozas.de> <4BAB6EC4.9080006@pandora.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:52584 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754522Ab0CYOMB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Mar 2010 10:12:01 -0400
In-Reply-To: <4BAB6EC4.9080006@pandora.be>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2010-03-25 15:10, Bart De Schuymer wrote:

>Hi Jan,
>
>You seem to be removing all information about which module is
>responsible for the message. Are you planning on a scheme to define the
>pr_fmt macro for each module or did I miss something?

pr_fmt is appropriately defined at the top of the affected source files.

	#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt

This is the format already used by some modules.
