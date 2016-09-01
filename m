From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: ftp: Remove the useless dlen==0
 condition check in find_pattern
Date: Thu, 1 Sep 2016 13:08:06 +0200
Message-ID: <20160901110806.GA2872@salvia>
References: <1472696057-15819-1-git-send-email-fgao@ikuai8.com>
 <CA+6hz4o5ZqQBEND62wK3QswZd-vi0ark9aJWbjrPL9d_Aq2-ZQ@mail.gmail.com>
 <20160901102001.GA2005@salvia>
 <CA+6hz4qyjEV7wjTbWZbbP-c6npyq1He-4x5==3KD6OiwdQCdfQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kadlec@blackhole.kfki.hu,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>, coreteam@netfilter.org
To: Feng Gao <gfree.wind@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35416 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751606AbcIALIO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Sep 2016 07:08:14 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id CD26CC0B4C
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Sep 2016 13:08:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id BB7AA1153FC
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Sep 2016 13:08:12 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9F8A41150DD
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Sep 2016 13:08:07 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CA+6hz4qyjEV7wjTbWZbbP-c6npyq1He-4x5==3KD6OiwdQCdfQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 01, 2016 at 07:01:51PM +0800, Feng Gao wrote:
> On Thu, Sep 1, 2016 at 6:20 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Thu, Sep 01, 2016 at 10:26:08AM +0800, Feng Gao wrote:
> >> On Thu, Sep 1, 2016 at 10:14 AM,  <fgao@ikuai8.com> wrote:
[...]
> >> Sorry, I forget one point. I also remove some codes which are
> >> commented out by #if0.
> >
> > Please, do this in a separated patch. Thanks.
> 
> Done.
> I thought the "#if 0" change is very tiny, and it did not deserve one commit.
> 
> Now I get it. It needs one separate commit, even though how tiny it is.

Better split patches into logical changes.

In general, if you end up describing two changes that don't relate
each other in the patch description, then this usually means you need
two patches.

Thanks for addressing my feedback!
