From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: libnetfilter_conntrack endian issue
Date: Tue, 29 Jul 2008 13:52:46 +0200
Message-ID: <488F048E.5020202@netfilter.org>
References: <4e0fd89b0807290324v6f771a79q80dcafc6b03dae54@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Albert Veli <albert.veli@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50264 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755002AbYG2Lwx (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Jul 2008 07:52:53 -0400
In-Reply-To: <4e0fd89b0807290324v6f771a79q80dcafc6b03dae54@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Albert Veli wrote:
> Hi!
> 
> I run contrack-tools on a big-endian arm machine and had a problem:
> 
> $ conntrack -L
> conntrack v0.9.7: Operation failed: Address family not supported by protocol
> 
> The problem was in libnetfilter_conntrack-0.0.96/src/conntrack/api.c.
> See attached endian.patch. In nfct_build_query() the *data argument is
> converted into a u_int8_t*. This works for little-endian but not for
> big-endian. The fix is a one-liner. Replace
> 
>  const u_int8_t *family = data;
> 
> with
> 
>  const u_int32_t *family = data;
> 
> After the patch it works:
> 
> $ conntrack -L
> conntrack v0.9.7: 0 flow entries has been shown.
> 
> I also tested the patch on my little-endian laptop and it doesn't seem
> to cause any regression there. Just wanted to let you guys know.

Applied. Thanks Albert.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
