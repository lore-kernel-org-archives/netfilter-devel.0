From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH 3/5] Selected corrections from Mr. Dash Four
Date: Sun, 18 Dec 2011 15:11:15 +0000
Message-ID: <4EEE0293.90408@googlemail.com>
References: <1324155743-25999-1-git-send-email-jengelh@medozas.de> <1324155743-25999-4-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: eric@regit.org, netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:41471 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab1LRPL0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 18 Dec 2011 10:11:26 -0500
Received: by wgbdr13 with SMTP id dr13so9271777wgb.1
        for <netfilter-devel@vger.kernel.org>; Sun, 18 Dec 2011 07:11:24 -0800 (PST)
In-Reply-To: <1324155743-25999-4-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> -At the time of the writing there is no routing-based implementation of
> +At the time of the writing, there is no routing-based implementation of
>  `rp_filter` in the Linux kernel for IPv6. Manual anti-spoofing via Netfilter
>  rules is thus needed.
>   
I don't mean to be picky (again) but the above should be "At the time of 
writing, there is no routing-based implementation of `rp_filter` in the 
Linux kernel for IPv6 - manual anti-spoofing via Netfilter rules is 
needed." or "At the time of writing, there is no routing-based 
implementation of `rp_filter` in the Linux kernel for IPv6, therefore 
manual anti-spoofing via Netfilter rules is needed."

> -The anti-spoofing must be done on a per-interface basis. For each interface,
> +Anti-spoofing must be done on a per-interface basis. For each interface,
>  we must list the authorized network on the interface. There is exception,
>   
"For each interface, we must list the authorized network on that interface."

