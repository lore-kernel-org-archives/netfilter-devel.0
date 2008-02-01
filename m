From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [patch 1/1] Add subsystem accessors
Date: Fri, 01 Feb 2008 17:59:04 +0100
Message-ID: <47A34FD8.2080806@netfilter.org>
References: <20080130182128.826992459@kruemel.intranet.astaro.de> <20080130182454.607358723@kruemel.intranet.astaro.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, holger@eitzenberger.org
To: heitzenberger@astaro.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48902 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755517AbYBAQ70 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Feb 2008 11:59:26 -0500
In-Reply-To: <20080130182454.607358723@kruemel.intranet.astaro.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

heitzenberger@astaro.com wrote:
> Need by newer ulogd v2.

Why do you need this? If I apply this, I'll have to provide support for
people mixing calls to libnfnetlink and libnetfilter_conntrack which can
be a problematic. The subsys handles are encapsulated for that reason.

If you really need them, I suggest you to use libnfnetlink together with
the low level functions libnetfilter_conntrack functions:
nfct_[build|parse]_conntrack and nfct_build_query.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
