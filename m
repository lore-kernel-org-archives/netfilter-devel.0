From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Patch for geoip match agains kernel 2.6.28
Date: Fri, 23 Jan 2009 10:51:23 +0100
Message-ID: <4979931B.5060503@netfilter.org>
References: <000301c97cd4$4b810f30$e2832d90$%olav@bjerkeset.com> <dd45289d0901221822v2d52b653h3f961dd8b4563843@mail.gmail.com> <alpine.LSU.2.00.0901231020310.17548@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: NICOLAS BOULIANE <nicboul@gmail.com>,
	Svein Olav Bjerkeset <svein.olav@bjerkeset.com>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45836 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757554AbZAWJvt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Jan 2009 04:51:49 -0500
In-Reply-To: <alpine.LSU.2.00.0901231020310.17548@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Friday 2009-01-23 03:22, NICOLAS BOULIANE wrote:
>> Thanks for this patch. I'll update my patchlet repository as soon as I get home.
>>
>> peace,
>> acidfu.
> 
> People still use POM patchlets? Gosh...

I'm planning to give a spin to POM to keep some (minor number of)
patches in it. For example, AFAIK xtables-addons cannot contain patches
like ACCOUNT, since they require changes in the main kernel.

My opinion on pom-ng and xtables-addons is still the same. I think that
they don't have a reason with the current kernel development cycle.

And, of course, if Nicolas wants to keep its patchset in pom-ng updated,
I would be OK with it.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
