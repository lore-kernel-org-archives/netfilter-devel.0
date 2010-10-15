From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/4] secmark: export secctx, drop secmark in procfs
Date: Fri, 15 Oct 2010 17:22:55 +0200
Message-ID: <4CB871CF.8040607@trash.net>
References: <20101013202441.15272.75924.stgit@paris.rdu.redhat.com> <20101013202500.15272.92369.stgit@paris.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, selinux@tycho.nsa.gov,
	jengelh@medozas.de, paul.moore@hp.com, jmorris@namei.org,
	sds@tycho.nsa.gov, pablo@netfilter.org
To: Eric Paris <eparis@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51267 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756036Ab0JOPW6 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Oct 2010 11:22:58 -0400
In-Reply-To: <20101013202500.15272.92369.stgit@paris.rdu.redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 13.10.2010 22:25, schrieb Eric Paris:
> The current secmark code exports a secmark= field which just indicates if
> there is special labeling on a packet or not.  We drop this field as it
> isn't particularly useful and instead export a new field secctx= which is
> the actual human readable text label.

We usually don't do this to avoid breaking parsers, however in
this case the field was dependant on a config option anyways,
so userspace must already be prepared that it is missing.

Acked-by: Patrick McHardy <kaber@trash.net>
