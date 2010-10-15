From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH 4/4] secmark: export secctx, drop secmark in procfs
Date: Fri, 15 Oct 2010 17:25:18 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1010151725020.30823@obet.zrqbmnf.qr>
References: <20101013202441.15272.75924.stgit@paris.rdu.redhat.com> <20101013202500.15272.92369.stgit@paris.rdu.redhat.com> <4CB871CF.8040607@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Eric Paris <eparis@redhat.com>, netfilter-devel@vger.kernel.org,
	selinux@tycho.nsa.gov, paul.moore@hp.com, jmorris@namei.org,
	sds@tycho.nsa.gov, pablo@netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:39916 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755857Ab0JOPZT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Oct 2010 11:25:19 -0400
In-Reply-To: <4CB871CF.8040607@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2010-10-15 17:22, Patrick McHardy wrote:

>Am 13.10.2010 22:25, schrieb Eric Paris:
>> The current secmark code exports a secmark= field which just indicates if
>> there is special labeling on a packet or not.  We drop this field as it
>> isn't particularly useful and instead export a new field secctx= which is
>> the actual human readable text label.
>
>We usually don't do this to avoid breaking parsers, however in
>this case the field was dependant on a config option anyways,
>so userspace must already be prepared that it is missing.

But do we really /have/ to add more and more stuff to procfs?
