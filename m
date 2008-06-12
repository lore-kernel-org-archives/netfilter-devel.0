From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH 3/5] Enable reading of hex or dec integer in config
 file.
Date: Thu, 12 Jun 2008 11:19:02 +0200
Message-ID: <4850EA06.2000502@netfilter.org>
References: <> <1212758035-19538-1-git-send-email-eric@inl.fr> <1212758035-19538-2-git-send-email-eric@inl.fr> <1212758035-19538-3-git-send-email-eric@inl.fr> <1212758035-19538-4-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33926 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755348AbYFLJTM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Jun 2008 05:19:12 -0400
In-Reply-To: <1212758035-19538-4-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> The config file parsing was not able to parse integer given in hex notation.
> This patch modify the parsing of configfile to be able to use different
> integers notation.

Applied with Patrick's suggestion on strtoul. Thanks.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
