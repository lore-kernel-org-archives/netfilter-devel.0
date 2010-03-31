From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: Modifying ebtables to read the commands from a file
Date: Wed, 31 Mar 2010 13:45:00 +0200
Message-ID: <4BB335BC.5060209@pandora.be>
References: <1269770877.2563.9.camel@qed>	 <alpine.LSU.2.01.1003281457380.22298@obet.zrqbmnf.qr>	 <4BAF7917.2030207@pandora.be> <1270020234.2792.11.camel@qed>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	netfilter-devel@vger.kernel.org
To: Peter Gordon <peter@pg-consultants.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gerard.telenet-ops.be ([195.130.132.48]:40636 "EHLO
	gerard.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016Ab0CaLpF (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Mar 2010 07:45:05 -0400
In-Reply-To: <1270020234.2792.11.camel@qed>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Peter Gordon schreef:
> Thanks for the reply.
>
> The counters are not particularly interesting in my application, so that
> isn't a problem.
>
> ebtables-restore replaces the rules atomically. There are two meanings
> in this context to "atomic".
>
> a) The old ruleset is deleted, and after, the new ruleset is applied
> atomically, at a single instant in time.
>
> or 
>
> b) The old ruleset is deleted and replaced by the new ruleset as one
> action - with no time gap between them.
>
>   
1 the new table content is constructed
2 the pointer to the old table is replaced by a pointer to the new table
3 the old table is deleted

So there's no gap of time in which there is no table ruleset present.

cheers,
Bart


-- 
Bart De Schuymer
www.artinalgorithms.be

