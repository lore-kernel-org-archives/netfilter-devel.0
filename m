From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH 5/9] Fix crash IP2BIN and IP2STR due to ui128 type
 introduction.
Date: Mon, 02 Jun 2008 01:59:13 +0200
Message-ID: <484337D1.6000107@netfilter.org>
References: <> <1211236295-30207-6-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56164 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753153AbYFAX7Y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Jun 2008 19:59:24 -0400
In-Reply-To: <1211236295-30207-6-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> IP2BIN and IP2STR were using the ptr field of the value but the type used
> for IPv6 address is now ui128. This patch fix this problem by using ui128
> instead of ptr.

I have merged this to 02cleanup.patch. Thanks.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
