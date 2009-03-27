From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: "cluster" match uses IPv6-specific code without
 ifdef
Date: Fri, 27 Mar 2009 10:19:46 +0100
Message-ID: <49CC9A32.3060303@netfilter.org>
References: <1238100203-23454-1-git-send-email-steven@uplinklabs.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Steven Noonan <steven@uplinklabs.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39921 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753149AbZC0JT5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Mar 2009 05:19:57 -0400
In-Reply-To: <1238100203-23454-1-git-send-email-steven@uplinklabs.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Steven Noonan wrote:
> The symbol __ipv6_addr_type is only available with CONFIG_IPV6 or
> CONFIG_IPV6_MODULE.

Please, CC netfilter-devel for netfilter-related issues. Patrick, I'm
fine with this, can you apply this patch?

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
