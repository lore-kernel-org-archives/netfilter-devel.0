From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH] Resent, new MARK filtering module.
Date: Thu, 12 Jun 2008 11:18:25 +0200
Message-ID: <4850E9E1.1030207@netfilter.org>
References: <48493BCD.4020605@trash.net> <1212919953-6635-1-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net, netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33667 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758498AbYFLJSo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Jun 2008 05:18:44 -0400
In-Reply-To: <1212919953-6635-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> This is a rework on my previous patch with suppression of mark_ce magic.
> 
> This module filters message by using the mark to decide wether or not a
> packet or a flow has to be logged. It takes a mark and a mask option. It
> demonstrates the usage of ULOGD_IRET_STOP which can be used to abort iteration
> through the stack.

Applied. Thanks.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
