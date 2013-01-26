From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [iptables PATCH] configure: display summary at end of
 configure
Date: Sat, 26 Jan 2013 01:16:47 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1301260113570.24932@nerf07.vanv.qr>
References: <1359154090-11061-1-git-send-email-eric@regit.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:52849 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752290Ab3AZAQs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Jan 2013 19:16:48 -0500
In-Reply-To: <1359154090-11061-1-git-send-email-eric@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2013-01-25 23:48, Eric Leblond wrote:
>
>Build parameters:
>  Static build:				no
>  Shared build:				yes

--enable-static/shared has a different meaning in iptables:

   Put plugins into executable:           ${enable_static}
   Support plugins via dlopen:            ${enable_shared}
