From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH 1/3] Fix compilation of input plugin when libnetfilter
 library are non globally available.
Date: Wed, 18 Jun 2008 17:39:53 +0200
Message-ID: <48592C49.2090003@netfilter.org>
References: <1213803013-19433-1-git-send-email-eric@inl.fr> <1213803013-19433-2-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51431 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752052AbYFRPj5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Jun 2008 11:39:57 -0400
In-Reply-To: <1213803013-19433-2-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> This patch fixes compilation of NFLOG and NFCT plugin when libnetfilter libraries
> are installed under a non standard prefix. Include path and libs path for
> libnetfilter_conntrack and libnetfilter_log were not correctly set even if
> pkg-config found them.

Applied. Thanks

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
