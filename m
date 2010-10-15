From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 3/4] conntrack: export lsm context rather than internal
 secid	via netlink
Date: Fri, 15 Oct 2010 17:20:20 +0200
Message-ID: <4CB87134.1070506@trash.net>
References: <20101013202441.15272.75924.stgit@paris.rdu.redhat.com> <20101013202454.15272.72074.stgit@paris.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, selinux@tycho.nsa.gov,
	jengelh@medozas.de, paul.moore@hp.com, jmorris@namei.org,
	sds@tycho.nsa.gov, pablo@netfilter.org
To: Eric Paris <eparis@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51220 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756327Ab0JOPUg (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Oct 2010 11:20:36 -0400
In-Reply-To: <20101013202454.15272.72074.stgit@paris.rdu.redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 13.10.2010 22:24, schrieb Eric Paris:
> The conntrack code can export the internal secid to userspace.  These are
> dynamic, can change on lsm changes, and have no meaning in userspace.  We
> should instead be sending lsm contexts to userspace instead.  This patch sends
> the secctx (rather than secid) to userspace over the netlink socket.  We use a
> new field CTA_SECCTX and stop using the the old CTA_SECMARK field since it did
> not send particularly useful information.
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>
> Reviewed-by: Paul Moore <paul.moore@hp.com>

Acked-by: Patrick McHardy <kaber@trash.net>
