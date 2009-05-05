From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: iptables pull request
Date: Tue, 05 May 2009 15:26:35 +0200
Message-ID: <4A003E8B.7050002@netfilter.org>
References: <1241380473-22262-1-git-send-email-jengelh@medozas.de> <49FEEC5A.3080409@netfilter.org> <alpine.LSU.2.00.0905050116060.5938@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40648 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752146AbZEEN0s (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 May 2009 09:26:48 -0400
In-Reply-To: <alpine.LSU.2.00.0905050116060.5938@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> I do not think we planned for a stable API - but feel free to ask Jamal. 
> The main target was ABI, because... - I am not sure how m_ipt did it, 
> but I seem to remember that despite version checks (ie. struct 
> xtables_match->version) it provided an iptables-like API that was not 
> actually that from the respective iptables version. Or something.

Well, IMO if this is intended to be a public API it should be stable.

> I am not sure what m_ipt did previously w.r.t. checks, but there are now 
> various mechanisms in place to ensure ABIs do not get mixed up 
> erroneously:
> 
> - soversion. m_ipt now links against, say, libxtables.so.2. If the 
> latter changes incompatibly, it becomes libxtables.so.3, and the 
> runtime linker ld.so will take care of it -- by throwing a "file not 
> found" error, or by actually loading a still-existing .so.2.
> 
> - libxtables will not load extensions that have a mismatching soversion 
> string
> 
> - lastly, we could make it so that every extension is backlinked to 
> libxtables.so.$version as an added measure but I had not yet given 
> thought of the impact that it causes for running iptables directly from 
> the source directory.

Aware of all of those, but I think that we should not abuse these
because versioning is not a solution, it's more like a workaround. If we
change the ABI over and over again, this will result in binary breakages
and really bad experience from the user side.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
