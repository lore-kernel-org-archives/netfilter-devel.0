From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: Re: [PATCHv2 lnf-log] utils: nf-log: attaching a conntrack
 information
Date: Tue, 15 Nov 2016 16:36:02 +0900
Message-ID: <20161115073602.GA10113@gmail.com>
References: <1441731291-21342-1-git-send-email-pablo@netfilter.org>
 <20150909095042.GA11843@gmail.com>
 <20150910000615.GB5734@salvia>
 <20150911030530.GA7380@gmail.com>
 <20150911031535.GG7380@gmail.com>
 <20151012152630.GC21781@salvia>
 <20151015043544.GA18814@gmail.com>
 <20151015043925.GB18814@gmail.com>
 <20151016165908.GA5588@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f67.google.com ([74.125.83.67]:36098 "EHLO
        mail-pg0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755596AbcKOHsh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 15 Nov 2016 02:48:37 -0500
Received: by mail-pg0-f67.google.com with SMTP id x23so11158135pgx.3
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Nov 2016 23:48:37 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20151016165908.GA5588@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

 Hi, sorry for so much late.
 
On Fri, Oct 16, 2015 at 06:59:08PM +0200, Pablo Neira Ayuso wrote:
> I think you can update configure.ac to update CFLAGS, like this:
> 
>         CFLAGS="$CFLAGS -DBUILD_NFCT"
> 
> so we can skip this include.

We can avoid to (re)run autogen.sh without lnf-conntrack at first
then install it after, but

>         gcc -lnetfilter_log -lnetfilter_conntrack -lmnl -DBUILD_NFCT nf-log.c -o nf-log

this make a sense, I follow your advice.

I have met another issue related to lnf-conntrack, could you give me
some advice? The following patch is compile error:

    In file included from nf-log.c:14:0:
    /usr/include/libnetfilter_conntrack/libnetfilter_conntrack.h:729:6: error: nested redefinition of ‘enum ip_conntrack_status’
     enum ip_conntrack_status {
          ^
    /usr/include/libnetfilter_conntrack/libnetfilter_conntrack.h:729:6: error: redeclaration of ‘enum ip_conntrack_status’
    In file included from nf-log.c:12:0:
    /usr/include/linux/netfilter/nf_conntrack_common.h:37:6: note: originally defined here
     enum ip_conntrack_status {

since both libnetfilter_conntrack.h and nf_conntrack_common.h
defines ip_conntrack_status. Could you tell me how do I avoid such a
error when using ip_conntrack_status and ip_conntrack_info?

# It seems that the prev 2 patches I posted with this
# has not applied yet?

Thanks,
