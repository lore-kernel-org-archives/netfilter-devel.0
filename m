From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 2/9] netfilter: xtables: slightly more detailed checkentry
 return values
Date: Wed, 17 Mar 2010 22:54:47 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1003171648590.8633@obet.zrqbmnf.qr>
References: <1268831945-6041-1-git-send-email-jengelh@medozas.de> <1268831945-6041-3-git-send-email-jengelh@medozas.de> <4BA0DB87.9040709@trash.net> <alpine.LSU.2.01.1003171443330.6297@obet.zrqbmnf.qr> <4BA0E450.3010902@trash.net>
 <alpine.LSU.2.01.1003171522020.6297@obet.zrqbmnf.qr> <4BA0E8F7.6050905@trash.net> <4BA0E9F9.80502@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:50722 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751904Ab0CQVyu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Mar 2010 17:54:50 -0400
In-Reply-To: <4BA0E9F9.80502@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2010-03-17 15:40, Patrick McHardy wrote:
>> 
>> OK that seems mostly fine. Basically its just the NULL/ENOENT
>> interpretation that might be confusing.
>
>One more thing though - I really don't like the strange mix of booleans
>and errno codes. If you want to change this,

I'm pretty indifferent, but what if I don't want to change it? :-)

Is it so bad to keep EINVAL and unspecified-error separated at the extension
level?

>please switch to the
>standard convention of 0 == no error, < 0 == errno code. For unspecific
>errors you can simply return EINVAL as the xt_check_*() functions
>currently do.
