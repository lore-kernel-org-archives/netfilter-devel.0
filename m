From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/4] secmark: export secctx, drop secmark in procfs
Date: Fri, 15 Oct 2010 17:31:30 +0200
Message-ID: <4CB873D2.4030309@trash.net>
References: <20101013202441.15272.75924.stgit@paris.rdu.redhat.com> <20101013202500.15272.92369.stgit@paris.rdu.redhat.com> <4CB871CF.8040607@trash.net> <alpine.LNX.2.01.1010151725020.30823@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Eric Paris <eparis@redhat.com>, netfilter-devel@vger.kernel.org,
	selinux@tycho.nsa.gov, paul.moore@hp.com, jmorris@namei.org,
	sds@tycho.nsa.gov, pablo@netfilter.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51441 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754659Ab0JOPcO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Oct 2010 11:32:14 -0400
In-Reply-To: <alpine.LNX.2.01.1010151725020.30823@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 15.10.2010 17:25, schrieb Jan Engelhardt:
> On Friday 2010-10-15 17:22, Patrick McHardy wrote:
> 
>> Am 13.10.2010 22:25, schrieb Eric Paris:
>>> The current secmark code exports a secmark= field which just indicates if
>>> there is special labeling on a packet or not.  We drop this field as it
>>> isn't particularly useful and instead export a new field secctx= which is
>>> the actual human readable text label.
>>
>> We usually don't do this to avoid breaking parsers, however in
>> this case the field was dependant on a config option anyways,
>> so userspace must already be prepared that it is missing.
> 
> But do we really /have/ to add more and more stuff to procfs?

As long as we don't add new files, I don't really mind.

