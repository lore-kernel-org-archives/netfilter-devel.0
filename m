From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: arptables 0.0.3-4 build fixes
Date: Thu, 18 Mar 2010 14:00:49 +0100
Message-ID: <4BA22401.1070802@pandora.be>
References: <alpine.LSU.2.01.1003161144290.27631@obet.zrqbmnf.qr> <4B9F8499.1060104@pandora.be> <alpine.LSU.2.01.1003161617120.10927@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from jacques.telenet-ops.be ([195.130.132.50]:43714 "EHLO
	jacques.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753237Ab0CRNAw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Mar 2010 09:00:52 -0400
In-Reply-To: <alpine.LSU.2.01.1003161617120.10927@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:

>> The warings that occur when using llu with 64-bit numbers should be
>> resolved with the PRIu64 macro. Could you fix that and resubmit, please?
>> Thanks.
> 
> Hmm, iptables is not using PRI either so it seemed like the preferred
> approach.

I've committed the rest of your patches too, altered where needed to use
the PRIu64 macro.

cheers,
Bart


-- 
Bart De Schuymer
www.artinalgorithms.be
