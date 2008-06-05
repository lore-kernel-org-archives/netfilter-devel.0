From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/3] libnfnetlink byte alignment
Date: Thu, 05 Jun 2008 15:31:36 +0200
Message-ID: <4847EAB8.4060905@netfilter.org>
References: <1212488448.29489.40.camel@pumper.lan.luxnet.ch> <484541E0.3020900@trash.net> <48465802.2010005@gmx.ch> <48470C52.1080306@netfilter.org> <4847E22E.8010701@gmx.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, netfilter-devel@vger.kernel.org
To: Fabian Hugelshofer <hugelshofer2006@gmx.ch>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36701 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754356AbYFENbw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Jun 2008 09:31:52 -0400
In-Reply-To: <4847E22E.8010701@gmx.ch>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Fabian Hugelshofer wrote:
> Pablo Neira Ayuso wrote:
>> Please, use union wherever it is possible. BTW, it seems to me that the
>> conntrack-tools may suffer from the same portability problem. The
>> (supposed) fix, which is attached, is ugly but union does not help since
>> the size of struct nf_conntrack is not known. I do not find a way to do
>> this cleanly without removing the use of the stack for temporary object
>> allocation.
> 
> As you noted, conntrack-tools can be affected as well. I did not have a
> look at it before, beacause I don't use it.
> 
> I don't see another way with the stack either. Dynamic memory allocation
> would help, but is not nicer either.

I see.

> Do you want me to rewrite the patches for libnetfilter-(log|contrack) in
> the union style? I probably would put the union declaration in the file
> scope rather than anonymous declarations in the function scope, because
> it is the same everywhere.

I'm fine with it. Thanks Fabian.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
