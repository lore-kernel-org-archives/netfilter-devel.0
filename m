From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH 03/14] Fix type of raw.mac_len key in NFLOG.
Date: Sat, 05 Apr 2008 16:30:57 +0200
Message-ID: <47F78D21.3000707@netfilter.org>
References: <1206289522679-git-send-email-eric@inl.fr> <12062895222837-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45689 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753225AbYDEObG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 5 Apr 2008 10:31:06 -0400
In-Reply-To: <12062895222837-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> Type of the raw.mac_len key was set to string but this is an unsigned
> interger. This patch fix this in the NFLOG module.

Applied. Thanks Eric.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
