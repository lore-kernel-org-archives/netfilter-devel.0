From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] conntrack-tools: Fix build for old automake.
Date: Thu, 7 Apr 2016 19:50:09 +0200
Message-ID: <20160407175009.GB7271@salvia>
References: <1459762780-10255-1-git-send-email-mart.frauenlob@chello.at>
 <1459762780-10255-2-git-send-email-mart.frauenlob@chello.at>
 <20160407164758.GA5353@salvia>
 <570699F7.1010907@chello.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Mart Frauenlob <mart.frauenlob@chello.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35347 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757177AbcDGRuT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Apr 2016 13:50:19 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 2199215AEA5
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 19:50:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0ED4BDA38C
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 19:50:17 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id BC239DA791
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 19:50:13 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <570699F7.1010907@chello.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 07, 2016 at 07:33:43PM +0200, Mart Frauenlob wrote:
> On 07.04.2016 18:47, Pablo Neira Ayuso wrote:
> >On Mon, Apr 04, 2016 at 11:39:40AM +0200, Mart Frauenlob wrote:
> >>  autoreconf fails with automake version smaller than 1.12,
> >>  because of undefined macro AM_PROG_AR.
> >>  So only expand it if it's actually defined.
> >>
> >>Signed-off-by: Mart Frauenlob <mart.frauenlob@chello.at>
> >>---
> >>  configure.ac |    2 +-
> >>  1 files changed, 1 insertions(+), 1 deletions(-)
> >>
> >>diff --git a/configure.ac b/configure.ac
> >>index c541034..2c5913f 100644
> >>--- a/configure.ac
> >>+++ b/configure.ac
> >>@@ -14,7 +14,7 @@ AC_SUBST([libdl_LIBS])
> >>
> >>  AC_PROG_CC
> >>  AC_DISABLE_STATIC
> >>-AM_PROG_AR
> >>+m4_ifdef([AM_PROG_AR], [AM_PROG_AR]) dnl Workaround for Automake 1.11
> >
> >How old is your old system? is it still a distro maintained version?
> 
> cat /etc/debian_version
> 6.0.10
> Has automake 1.11.

Is that still maintained?
