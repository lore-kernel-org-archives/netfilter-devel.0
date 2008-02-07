From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] Use index2name capabilities of libnfnetlink in IFINDEX
 filter.
Date: Thu, 07 Feb 2008 07:45:59 +0100
Message-ID: <47AAA927.6050902@netfilter.org>
References: <47A5B0C0.1060003@netfilter.org> <12022922743115-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58347 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752933AbYBGGqQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Feb 2008 01:46:16 -0500
In-Reply-To: <12022922743115-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> This patch modify ulogd_filter_IFINDEX to use libnfnetlink for index to
> interface name mapping instead of using local version. This requires at least
> libnfnetlink 0.0.30. This dependancy is checked in configure (thanks to
> Sebastien Tricaud for his patch).

Great. Applied. Thanks Eric.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
