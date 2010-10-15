From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/4] secmark: make secmark object handling generic
Date: Fri, 15 Oct 2010 17:18:49 +0200
Message-ID: <4CB870D9.6020703@trash.net>
References: <20101013202441.15272.75924.stgit@paris.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, selinux@tycho.nsa.gov,
	jengelh@medozas.de, paul.moore@hp.com, jmorris@namei.org,
	sds@tycho.nsa.gov, pablo@netfilter.org
To: Eric Paris <eparis@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51195 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756300Ab0JOPTR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Oct 2010 11:19:17 -0400
In-Reply-To: <20101013202441.15272.75924.stgit@paris.rdu.redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 13.10.2010 22:24, schrieb Eric Paris:
> Right now secmark has lots of direct selinux calls.  Use all LSM calls and
> remove all SELinux specific knowledge.  The only SELinux specific knowledge
> we leave is the mode.  The only point is to make sure that other LSMs at
> least test this generic code before they assume it works.  (They may also
> have to make changes if they do not represent labels as strings)
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>
> Acked-by: Paul Moore <paul.moore@hp.com>

I think these patches should go through the security tree.

Acked-by: Patrick McHardy <kaber@trash.net>

