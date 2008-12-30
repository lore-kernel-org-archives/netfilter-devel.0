From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnetfilter_log 3/3] Suppress NFULNL_MSG_CONFIG callback registration.
Date: Tue, 30 Dec 2008 12:20:09 +0100
Message-ID: <495A03E9.8000700@netfilter.org>
References: <1230586404-24639-1-git-send-email-eric@inl.fr> <1230586404-24639-4-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56172 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751585AbYL3MGV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Dec 2008 07:06:21 -0500
In-Reply-To: <1230586404-24639-4-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> It seems there is no NFULNL_MSG_CONFIG message send from kernel space to
> userspace. Thus the registration of an nfnetlink callback for this type
> of messages is not necessary.

Please, also apply this one.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
