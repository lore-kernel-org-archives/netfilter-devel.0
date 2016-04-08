From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] conntrack-tools: Fix build for old automake.
Date: Fri, 8 Apr 2016 11:42:06 +0200
Message-ID: <20160408094206.GA1677@salvia>
References: <1459762780-10255-1-git-send-email-mart.frauenlob@chello.at>
 <1459762780-10255-2-git-send-email-mart.frauenlob@chello.at>
 <20160407164758.GA5353@salvia>
 <570699F7.1010907@chello.at>
 <20160407175009.GB7271@salvia>
 <57069E8E.7050709@chello.at>
 <57075241.80906@chello.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Mart Frauenlob <mart.frauenlob@chello.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52113 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755900AbcDHJmN (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Apr 2016 05:42:13 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id EA2E8E839C
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2016 11:42:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DA2F0DA385
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2016 11:42:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 216C4DA388
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2016 11:42:09 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <57075241.80906@chello.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 08, 2016 at 08:40:01AM +0200, Mart Frauenlob wrote:
> On 07.04.2016 19:53, Mart Frauenlob wrote:
> >On 07.04.2016 19:50, Pablo Neira Ayuso wrote:
> >>On Thu, Apr 07, 2016 at 07:33:43PM +0200, Mart Frauenlob wrote:
> >>>On 07.04.2016 18:47, Pablo Neira Ayuso wrote:
> >>>>On Mon, Apr 04, 2016 at 11:39:40AM +0200, Mart Frauenlob wrote:
> >>>>>  autoreconf fails with automake version smaller than 1.12,
> >>>>>  because of undefined macro AM_PROG_AR.
> >>>>>  So only expand it if it's actually defined.
> >>>>>
> >>>>>Signed-off-by: Mart Frauenlob <mart.frauenlob@chello.at>
> >>>>>---
> >>>>>  configure.ac |    2 +-
> >>>>>  1 files changed, 1 insertions(+), 1 deletions(-)
> >>>>>
> >>>>>diff --git a/configure.ac b/configure.ac
> >>>>>index c541034..2c5913f 100644
> >>>>>--- a/configure.ac
> >>>>>+++ b/configure.ac
> >>>>>@@ -14,7 +14,7 @@ AC_SUBST([libdl_LIBS])
> >>>>>
> >>>>>  AC_PROG_CC
> >>>>>  AC_DISABLE_STATIC
> >>>>>-AM_PROG_AR
> >>>>>+m4_ifdef([AM_PROG_AR], [AM_PROG_AR]) dnl Workaround for Automake 1.11
> >>>>
> >>>>How old is your old system? is it still a distro maintained version?
> >>>
> >>>cat /etc/debian_version
> >>>6.0.10
> >>>Has automake 1.11.
> >>
> >>Is that still maintained?
> >>
> >
> >Quoting https://www.debian.org/News/2016/20160212 :
> >
> >February 12th, 2016
> >The Debian Long Term Support (LTS) Team hereby announces that Debian 6.0
> >("squeeze") support will reach its end-of-life on February 29, 2016,
> >five years after its initial release on February 6, 2011.
> >
> >Hm, no longer since 2 months....
> 
> What does that macro actually do in configure?
> 
> AM_PROG_AR([act-if-fail])
> 
>     You must use this macro when you use the archiver in your project, if
> you want support for unusual archivers such as Microsoft lib. The content of
> the optional argument is executed if the archiver interface is not
> recognized; the default action is to abort configure with an error message.
> 
> Does this archiver get called at all?

eed61ed5        (Felix Janda    2015-05-16 11:19:02 +0200 17)AM_PROG_AR

commit eed61ed57fd2a82b81af9bd2f6895b3aa5221f49
Author: Felix Janda <felix.janda@posteo.de>
Date:   Sat May 16 11:19:02 2015 +0200

    configure: Add AM_PROG_AR to silence automake warning
    
    /usr/share/automake-1.13/am/ltlibrary.am: warning: 'ct_helper_tns.la': linking libtool libraries using a non-POSIX
    /usr/share/automake-1.13/am/ltlibrary.am: archiver requires 'AM_PROG_AR' in 'configure.ac'
    src/helpers/Makefile.am:3:   while processing Libtool library 'ct_helper_tns.la'
