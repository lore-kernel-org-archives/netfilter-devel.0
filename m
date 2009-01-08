From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: build: resolve autotools suggestions
Date: Thu, 08 Jan 2009 16:55:54 +0100
Message-ID: <4966220A.7080705@netfilter.org>
References: <alpine.LNX.1.10.0812252021300.17625@fbirervta.pbzchgretzou.qr> <495A05B0.8070700@netfilter.org> <alpine.LSU.2.00.0812301611070.5671@fbirervta.pbzchgretzou.qr> <4964B8F6.8080605@netfilter.org> <alpine.LSU.2.00.0901080049060.29344@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: kaber@trash.net,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40398 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751081AbZAHP4H (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Jan 2009 10:56:07 -0500
In-Reply-To: <alpine.LSU.2.00.0901080049060.29344@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Wednesday 2009-01-07 15:15, Pablo Neira Ayuso wrote:
>> Applied. Thanks. Any other missing patch to apply to iptables from your
>> side? I remember those to deprecate -b for iptables-save/restore but I
>> prefer to add a warning before removing them as I suggested.
> 
> I really really doubt anyone ever used it -- since there was no code,
> there was no effect.

I agree, but I prefer being conservative here (and unless that Patrick
has a different opinion here).

Anyway, I'm just requesting a notice message to warn about the deletion,
and later on delete it. It's the same end for this story but making the
film a bit longer.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
