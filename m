From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCHv2 lnf-log] utils: nf-log: attaching a conntrack
 information
Date: Thu, 24 Nov 2016 14:15:02 +0100
Message-ID: <20161124131502.GB18726@salvia>
References: <1441731291-21342-1-git-send-email-pablo@netfilter.org>
 <20150909095042.GA11843@gmail.com>
 <20150910000615.GB5734@salvia>
 <20150911030530.GA7380@gmail.com>
 <20150911031535.GG7380@gmail.com>
 <20151012152630.GC21781@salvia>
 <20151015043544.GA18814@gmail.com>
 <20151015043925.GB18814@gmail.com>
 <20151016165908.GA5588@salvia>
 <20161115073602.GA10113@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44614 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S938515AbcKXNPR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Nov 2016 08:15:17 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DF0FB21056A
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 14:15:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CA43FDA398
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 14:15:13 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 568E9DA398
        for <netfilter-devel@vger.kernel.org>; Thu, 24 Nov 2016 14:15:11 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20161115073602.GA10113@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 15, 2016 at 04:36:02PM +0900, Ken-ichirou MATSUZAWA wrote:
>  Hi, sorry for so much late.
>  
> On Fri, Oct 16, 2015 at 06:59:08PM +0200, Pablo Neira Ayuso wrote:
> > I think you can update configure.ac to update CFLAGS, like this:
> > 
> >         CFLAGS="$CFLAGS -DBUILD_NFCT"
> > 
> > so we can skip this include.
> 
> We can avoid to (re)run autogen.sh without lnf-conntrack at first
> then install it after, but
> 
> >         gcc -lnetfilter_log -lnetfilter_conntrack -lmnl -DBUILD_NFCT nf-log.c -o nf-log
> 
> this make a sense, I follow your advice.
> 
> I have met another issue related to lnf-conntrack, could you give me
> some advice? The following patch is compile error:
> 
>     In file included from nf-log.c:14:0:
>     /usr/include/libnetfilter_conntrack/libnetfilter_conntrack.h:729:6: error: nested redefinition of ‘enum ip_conntrack_status’
>      enum ip_conntrack_status {
>           ^
>     /usr/include/libnetfilter_conntrack/libnetfilter_conntrack.h:729:6: error: redeclaration of ‘enum ip_conntrack_status’
>     In file included from nf-log.c:12:0:
>     /usr/include/linux/netfilter/nf_conntrack_common.h:37:6: note: originally defined here
>      enum ip_conntrack_status {
> 
> since both libnetfilter_conntrack.h and nf_conntrack_common.h
> defines ip_conntrack_status. Could you tell me how do I avoid such a
> error when using ip_conntrack_status and ip_conntrack_info?

I have just fixed this on the repository:

commit 9833df6abd4d5ef381354e32b2d7d7afa7a616fe
Author: Pablo Neira Ayuso <pablo@netfilter.org>
Date:   Thu Nov 24 14:09:34 2016 +0100

    include: expose a copy of nf_conntrack_common.h
    
    Copy and rename nf_conntrack_common.h to
linux_nf_conntrack_common.h,
    then include it from libnetfilter_conntrack.h
    
Please, let me know if you see any problem with such update, thanks.
