From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH 0/3][RFC] Relationship between conntrack and firewall
 rules
Date: Fri, 21 Jan 2011 00:04:47 +0000
Message-ID: <4D38CD9F.1040905@googlemail.com>
References: <1295563629-14996-1-git-send-email-richard@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Richard Weinberger <richard@nod.at>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ww0-f42.google.com ([74.125.82.42]:43305 "EHLO
	mail-ww0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751997Ab1AUAEz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jan 2011 19:04:55 -0500
Received: by wwi17 with SMTP id 17so56878wwi.1
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Jan 2011 16:04:54 -0800 (PST)
In-Reply-To: <1295563629-14996-1-git-send-email-richard@nod.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> "conntrack -L" shows us this two entries:
> tcp      6 431999 ESTABLISHED src=192.168.1.1 dst=192.168.1.2 sport=51444 \
> 	dport=22 src=192.168.1.2 dst=192.168.1.1 sport=22 dport=51444 [ASSURED] \
> 	mark=0 established=1 related=0 new=3 reply=2 use=1
>
> icmp     1 28 src=192.168.1.2 dst=149.20.20.133 type=8 code=0 id=63239 \
> 	src=149.20.20.133 dst=192.168.1.2 type=0 code=0 id=63239 mark=0 \
> 	established=2 related=0 new=2 reply=1 use=1
>   
Isn't there supposed to be secctx (SELinux context) field showing as 
well or is this still not implemented in the conntrack tools?

