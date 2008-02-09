From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH 1/5] Fix treatment of return from function
Date: Sat, 09 Feb 2008 18:31:18 +0100
Message-ID: <47ADE366.6020300@netfilter.org>
References: <12025605952271-git-send-email-eric@inl.fr> <12025605953450-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56737 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754761AbYBIRbm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 9 Feb 2008 12:31:42 -0500
In-Reply-To: <12025605953450-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> The treatment of the return of some functions from libnetfilter_log API was wrong and this
> was preventing some fields to be propagated through the stack.

libnetfilter_log API is confusing, get_seq() should returns 1 if OK,
that seems more logical to me. Well, we don't have anything to do here
apart from rewritten the API or move later to libnl.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
