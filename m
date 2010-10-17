From: James Morris <jmorris@namei.org>
Subject: Re: [PATCH 1/4] secmark: make secmark object handling generic
Date: Mon, 18 Oct 2010 10:15:20 +1100 (EST)
Message-ID: <alpine.LRH.2.00.1010181015060.9476@tundra.namei.org>
References: <20101013202441.15272.75924.stgit@paris.rdu.redhat.com> <4CB870D9.6020703@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Eric Paris <eparis@redhat.com>, netfilter-devel@vger.kernel.org,
	selinux@tycho.nsa.gov, jengelh@medozas.de, paul.moore@hp.com,
	sds@tycho.nsa.gov, pablo@netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from tundra.namei.org ([65.99.196.166]:57110 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751038Ab0JQXPy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 17 Oct 2010 19:15:54 -0400
In-Reply-To: <4CB870D9.6020703@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 15 Oct 2010, Patrick McHardy wrote:

> Am 13.10.2010 22:24, schrieb Eric Paris:
> > Right now secmark has lots of direct selinux calls.  Use all LSM calls and
> > remove all SELinux specific knowledge.  The only SELinux specific knowledge
> > we leave is the mode.  The only point is to make sure that other LSMs at
> > least test this generic code before they assume it works.  (They may also
> > have to make changes if they do not represent labels as strings)
> > 
> > Signed-off-by: Eric Paris <eparis@redhat.com>
> > Acked-by: Paul Moore <paul.moore@hp.com>
> 
> I think these patches should go through the security tree.
> 
> Acked-by: Patrick McHardy <kaber@trash.net>

All applied to
git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/security-testing-2.6#next

-- 
James Morris
<jmorris@namei.org>
