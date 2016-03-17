From: Arpan Kapoor <rpnkpr@gmail.com>
Subject: Re: [PATCH] iptables: Replace gethostbyname() with getaddrinfo()
Date: Thu, 17 Mar 2016 21:45:43 +0530
Message-ID: <20160317161509.GA5809@arch>
References: <1458219439-561-1-git-send-email-rpnkpr@gmail.com>
 <alpine.LSU.2.20.1603171443100.30641@nerf40.vanv.qr>
Reply-To: rpnkpr@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f194.google.com ([209.85.192.194]:34688 "EHLO
	mail-pf0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965729AbcCQQQS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Mar 2016 12:16:18 -0400
Received: by mail-pf0-f194.google.com with SMTP id n5so11701791pfn.1
        for <netfilter-devel@vger.kernel.org>; Thu, 17 Mar 2016 09:16:18 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.20.1603171443100.30641@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 17, 2016 at 02:44:00PM +0100, Jan Engelhardt wrote:
> 
> You should just remove host_to_ipaddr and ipparse_hostnetwork,
> because nothing appears to be using them anymore. Everything
> switched to xtopt_parse_host.

ipparse_hostnetwork is utilized by xtables_ipparse_any and
xtables_ipparse_multiple which are being used by
1) arpmangle_parse (extensions/libarpt_mangle.c)
2) do_command4 (iptables/iptables.c)
3) nft_ipv4_post_parse (iptables/nft-ipv4.c)

Excuse me if I'm missing something. I'm new to the codebase
and this is my first patch.
