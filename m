From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH 2/6] Fix display of IPv6 address.
Date: Sat, 05 Apr 2008 17:31:57 +0200
Message-ID: <47F79B6D.2050209@netfilter.org>
References: <12065717514081-git-send-email-eric@inl.fr> <12065717511847-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56589 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752183AbYDEPcE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Apr 2008 11:32:04 -0400
In-Reply-To: <12065717511847-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> An error in the type of an argument in the call to inet_ntop was causing IPv6
> address to be transformed in a string not really related to the real Ipv6
> address.

Applied.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
