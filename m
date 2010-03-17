From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 3/9] netfilter: xtables: restrict TCPMSS to mangle table
 as intended
Date: Wed, 17 Mar 2010 14:34:45 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003171431420.6297@obet.zrqbmnf.qr>
References: <1268831945-6041-1-git-send-email-jengelh@medozas.de> <1268831945-6041-4-git-send-email-jengelh@medozas.de> <4BA0D97D.6020701@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:39008 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754863Ab0CQNeq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Mar 2010 09:34:46 -0400
In-Reply-To: <4BA0D97D.6020701@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2010-03-17 14:30, Patrick McHardy wrote:
>Jan Engelhardt wrote:
>> References: http://bugs.debian.org/567050
>> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
>
>So we removed those artificial restrictions in other modules
>just to introduce them somewhere else?

Couldn't MSS be relevant to routing?
Just trying to figure out how the manpage came to mention it would need 
to be limited.
