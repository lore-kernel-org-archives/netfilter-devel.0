From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD2 PATCH 1/3] Suppress references to ulogd1 only variable.
Date: Fri, 12 Sep 2008 00:18:39 +0200
Message-ID: <48C9993F.5010109@netfilter.org>
References: <> <1221166085-23435-2-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60992 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752487AbYIKWet (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Sep 2008 18:34:49 -0400
In-Reply-To: <1221166085-23435-2-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> 'rmem' and 'bufsize' global variables are unherited from ulogd1
> and are not used anymore. This patch suppresses them from the
> example configuration file.

Applied. Thanks Eric.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
