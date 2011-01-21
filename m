From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH 0/3][RFC] Relationship between conntrack and firewall
 rules
Date: Fri, 21 Jan 2011 00:13:20 +0000
Message-ID: <4D38CFA0.9080407@googlemail.com>
References: <1295563629-14996-1-git-send-email-richard@nod.at> <4D38CD9F.1040905@googlemail.com> <201101210110.38451.richard@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Richard Weinberger <richard@nod.at>
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:48055 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121Ab1AUAN1 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 20 Jan 2011 19:13:27 -0500
Received: by wyb28 with SMTP id 28so1244102wyb.19
        for <netfilter-devel@vger.kernel.org>; Thu, 20 Jan 2011 16:13:26 -0800 (PST)
In-Reply-To: <201101210110.38451.richard@nod.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> SELinux is disabled on my box.
>   
Still, isn't it supposed to show secctx=0 (or was it secctx=-1) if 
SELinux is in permissive/disabled mode?

