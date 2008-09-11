From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD2 PATCH 2/3] Make NFLOG and NFCT build conditionnal
Date: Thu, 11 Sep 2008 23:56:57 +0200
Message-ID: <48C99429.2020406@netfilter.org>
References: <> <1221166085-23435-3-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49386 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752712AbYIKWIR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Sep 2008 18:08:17 -0400
In-Reply-To: <1221166085-23435-3-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> This patch modifies the build system behaviour to be able to compile
> ulogd on system without recent release of libnetfilter library. If
> a library is absent or too old, it will simply not compile the concerned
> input module.

I don't see any gain from this patch. We had this sort of conditional
compilation in iptables - that we finally removed - and it was source of
user-side problems.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
