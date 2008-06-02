From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH 8/9] Only use overrun handling if local hash is
 used.
Date: Mon, 02 Jun 2008 02:00:21 +0200
Message-ID: <48433815.4060800@netfilter.org>
References: <> <1211236295-30207-9-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40419 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752710AbYFBAAi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Jun 2008 20:00:38 -0400
In-Reply-To: <1211236295-30207-9-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> Overrun handling work by dumping the whole connection tracking table after an
> overrun. This is correct if the local hash is used but could be really bad if
> it is not the case. All entries would be flushed through the stack and arrive
> to the output module. In the case of a syslog or logemu module this will cause
> massive and useless message printing.
> 
> This patch modify the code by activating overrun handling if and only if the
> local hash is used (hash_enable=1 which is the default).

Applied. Thanks.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
