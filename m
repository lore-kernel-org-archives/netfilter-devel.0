From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Patch for geoip match agains kernel 2.6.28
Date: Fri, 23 Jan 2009 12:36:37 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0901231229460.24280@fbirervta.pbzchgretzou.qr>
References: <000301c97cd4$4b810f30$e2832d90$%olav@bjerkeset.com> <dd45289d0901221822v2d52b653h3f961dd8b4563843@mail.gmail.com> <alpine.LSU.2.00.0901231020310.17548@fbirervta.pbzchgretzou.qr> <4979931B.5060503@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: NICOLAS BOULIANE <nicboul@gmail.com>,
	Svein Olav Bjerkeset <svein.olav@bjerkeset.com>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:40691 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753538AbZAWLgk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 23 Jan 2009 06:36:40 -0500
In-Reply-To: <4979931B.5060503@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2009-01-23 10:51, Pablo Neira Ayuso wrote:
>Jan Engelhardt wrote:
>> On Friday 2009-01-23 03:22, NICOLAS BOULIANE wrote:
>>> Thanks for this patch. I'll update my patchlet repository as soon as I get home.
>>>
>>> peace,
>>> acidfu.
>> 
>> People still use POM patchlets? Gosh...
>
>I'm planning to give a spin to POM to keep some (minor number of)
>patches in it. For example, AFAIK xtables-addons cannot contain patches
>like ACCOUNT, since they require changes in the main kernel.

That is true. But the few extensions that I know of that patch kernel
files (ACCOUNT, layer7, ..) are not POM archives, but true
unified-diff style patches, making it a lot easier to patch them in
because most SCM or near-SCM tools (like quilt and stgit) support
unidiffs.

>My opinion on pom-ng and xtables-addons is still the same. I think that
>they don't have a reason with the current kernel development cycle.

Sort of they do (both). Almost like linux-staging, perhaps. I really
don't know what to make of extensions being ... not really rejected,
but not accepted either ... that have their place in a daily life
IMHO.

>And, of course, if Nicolas wants to keep its patchset in pom-ng updated,
>I would be OK with it.

Sure. But it would be beneficial for the end-user to receive
the optimizations made since too.
