From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] iptables: Add file output option to iptables-save
Date: Fri, 26 May 2017 17:57:07 +0200
Message-ID: <20170526155707.GA1701@salvia>
References: <1495801516-14937-1-git-send-email-ojford@gmail.com>
 <20170526123147.GA28597@salvia>
 <CAGMVOdu2qvL1p_=uOuTGyjuhqvnsCa7we-ZhXLeCP91v2cSYwg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Oliver Ford <ojford@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53224 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751788AbdEZP5U (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 26 May 2017 11:57:20 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 88D641EC2C7
        for <netfilter-devel@vger.kernel.org>; Fri, 26 May 2017 17:57:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 797B6100A45
        for <netfilter-devel@vger.kernel.org>; Fri, 26 May 2017 17:57:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 47563100A44
        for <netfilter-devel@vger.kernel.org>; Fri, 26 May 2017 17:57:08 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAGMVOdu2qvL1p_=uOuTGyjuhqvnsCa7we-ZhXLeCP91v2cSYwg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, May 26, 2017 at 03:43:12PM +0100, Oliver Ford wrote:
> On Fri, May 26, 2017 at 1:31 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Fri, May 26, 2017 at 12:25:16PM +0000, Oliver Ford wrote:
> >> Adds an option to output the results of iptables-save,
> >> ip6tables-save, and xtables-save save to a file.
> >> Updates the man page with this new option.
> >>
> >> Uses the dup2 call to replace stdout with the specified file.
> >> Error output is unchanged.
> >>
> >> This is a feature requested by a Gentoo developer in
> >> Bugzilla #905.
> >
> > Please, update manpage to include this new option and send v2.
> >
> > Thanks.
> 
> Hi, I updated the manpage in the file "iptables-save.8.in" which is
> included in the patch. A "man iptables-save" on my box shows the new
> option. Is there somewhere else I need to update it?

Sorry, I overlook that chunk where you update the manpage, that chunk
is indeed not missing.
