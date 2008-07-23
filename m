From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD2 PATCH 0/4] Misc cleaning
Date: Wed, 23 Jul 2008 15:00:12 +0200
Message-ID: <48872B5C.2080503@netfilter.org>
References: <> <1216812835-9851-1-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46112 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751140AbYGWNAV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jul 2008 09:00:21 -0400
In-Reply-To: <1216812835-9851-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> Hello,
> 
> This small patchset fixes some problems. The main issue is a fix of my previous
> patch where I've made a stupid type on a function name.
> To avoid this kind of error, I propose an other patch which adds
> "-Wall -Wextra" to gcc options.
> 
> The main concern here is about IPFIX which is in really bad shape. I've fix
> some major error in one of the patch but it remains untested for now and I
> don't think it can work properly.

All applied. Thanks. Eric, I'd like to resolve the remaining issues
related with the link layer logging before getting into the IPFIX
problems. Please, have a look at my previous email.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
