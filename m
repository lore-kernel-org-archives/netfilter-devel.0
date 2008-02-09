From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH 1/5] Fix treatment of return from function
Date: Sat, 09 Feb 2008 18:28:37 +0100
Message-ID: <47ADE2C5.30609@netfilter.org>
References: <12025605952271-git-send-email-eric@inl.fr> <12025605953450-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55761 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754424AbYBIR3E (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 9 Feb 2008 12:29:04 -0500
In-Reply-To: <12025605953450-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> The treatment of the return of some functions from libnetfilter_log API was wrong and this
> was preventing some fields to be propagated through the stack.

Applied. Thanks.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
