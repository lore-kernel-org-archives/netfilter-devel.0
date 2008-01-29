From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Transmit mark during connection destruction event
Date: Tue, 29 Jan 2008 14:47:40 +0100
Message-ID: <479F2E7C.3020001@netfilter.org>
References: <20080128231323.GA24226@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46610 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932262AbYA2NtN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jan 2008 08:49:13 -0500
In-Reply-To: <20080128231323.GA24226@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> The following feature was submitted some months ago. It forces the dump
> of mark during the connection destruction event. The induced load is
> quiet small and the patch is usefull to provide an easy way to filter
> event on user side without having to keep an hash in userspace.

I think that I told you that I'm against this patch. You may use the id
for this, although I'm not a big fun of it. I prefer having the hash
table or whatever structure in userspace, why don't you consider this?
If you keep the conntrack entries in a list and you have tons of them
your performance would be harmed anyway.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
