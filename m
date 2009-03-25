From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: 1.4.3: iptables-multi needs adjustment for -static callname
Date: Wed, 25 Mar 2009 13:48:44 +0100
Message-ID: <49CA282C.7020008@netfilter.org>
References: <alpine.LSU.2.00.0903242236130.26397@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47734 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752160AbZCYMs6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2009 08:48:58 -0400
In-Reply-To: <alpine.LSU.2.00.0903242236130.26397@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> HI,
> 
> I just noticed that one cannot call iptables-static because the multi 
> handler does not know about itself.
> 
> Available through: git://dev.medozas.de/iptables plus

Pulled and applied. Thanks.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
