From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH] netfilter: ipset: timeout values corrupted on set resize
Date: Mon, 25 Feb 2013 17:36:22 +0000
Message-ID: <512BA116.9000207@googlemail.com>
References: <1361302559-8657-1-git-send-email-johunt@akamai.com> <alpine.DEB.2.00.1302202238210.9720@blackhole.kfki.hu> <51254FA8.3050407@akamai.com> <alpine.DEB.2.00.1302211749080.11814@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f171.google.com ([74.125.82.171]:49216 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758518Ab3BYRgc (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 25 Feb 2013 12:36:32 -0500
Received: by mail-we0-f171.google.com with SMTP id u54so2752702wey.16
        for <netfilter-devel@vger.kernel.org>; Mon, 25 Feb 2013 09:36:31 -0800 (PST)
In-Reply-To: <alpine.DEB.2.00.1302211749080.11814@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> The new 
> extension to be introduced is the packet and bytes counters per elements. 
>   
That would be superb - a feature truly missed since I started using 
ipsets. Would that count packet/bytes in sub-sets (members of set:list) 
as well?

