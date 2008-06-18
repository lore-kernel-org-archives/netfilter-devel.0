From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD1 PATCH] Fix PCAP len (Jaap Keuter)
Date: Wed, 18 Jun 2008 17:16:15 +0200
Message-ID: <485926BF.7010105@netfilter.org>
References: <1213801091-25885-1-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40590 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750838AbYFRPQY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Jun 2008 11:16:24 -0400
In-Reply-To: <1213801091-25885-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> This is a application of patch provided by Jaap Keuter. Application will close
> bugzilla 535. pcap len was set to value of the pointer to raw data.

Applied. Thanks Eric.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
