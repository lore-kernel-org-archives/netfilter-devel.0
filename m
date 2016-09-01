From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: ftp: Remove the useless dlen==0
 condition check in find_pattern
Date: Thu, 1 Sep 2016 12:20:01 +0200
Message-ID: <20160901102001.GA2005@salvia>
References: <1472696057-15819-1-git-send-email-fgao@ikuai8.com>
 <CA+6hz4o5ZqQBEND62wK3QswZd-vi0ark9aJWbjrPL9d_Aq2-ZQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kadlec@blackhole.kfki.hu,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>, coreteam@netfilter.org
To: Feng Gao <gfree.wind@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37120 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S932550AbcIAKUS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 1 Sep 2016 06:20:18 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 71C1B1E0DC4
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Sep 2016 12:20:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 6073C1153E3
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Sep 2016 12:20:09 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C20251150D2
        for <netfilter-devel@vger.kernel.org>; Thu,  1 Sep 2016 12:20:03 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CA+6hz4o5ZqQBEND62wK3QswZd-vi0ark9aJWbjrPL9d_Aq2-ZQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 01, 2016 at 10:26:08AM +0800, Feng Gao wrote:
> On Thu, Sep 1, 2016 at 10:14 AM,  <fgao@ikuai8.com> wrote:
> > From: Gao Feng <fgao@ikuai8.com>
> >
> > The caller function "help" has already make sure the datalen could not be zero
> > before invoke find_pattern as a parameter by the following codes
> >
> >         if (dataoff >= skb->len) {
> >                 pr_debug("ftp: dataoff(%u) >= skblen(%u)\n", dataoff,
> >                          skb->len);
> >                 return NF_ACCEPT;
> >         }
> >         datalen = skb->len - dataoff;
> >
> > And the latter codes "ends_in_nl = (fb_ptr[datalen - 1] == '\n');" use datalen
> > directly without checking if it is zero.
> >
> > So it is unneccessary to check it in find_pattern too.
> >
> > Signed-off-by: Gao Feng <fgao@ikuai8.com>
> > ---
> >  net/netfilter/nf_conntrack_ftp.c | 12 ------------
> >  1 file changed, 12 deletions(-)
> >
> > diff --git a/net/netfilter/nf_conntrack_ftp.c b/net/netfilter/nf_conntrack_ftp.c
> > index b6934b5..77f05ac 100644
> > --- a/net/netfilter/nf_conntrack_ftp.c
> > +++ b/net/netfilter/nf_conntrack_ftp.c
> > @@ -301,8 +301,6 @@ static int find_pattern(const char *data, size_t dlen,
> >         size_t i = plen;
> >
> >         pr_debug("find_pattern `%s': dlen = %Zu\n", pattern, dlen);
> > -       if (dlen == 0)
> > -               return 0;
> >
> >         if (dlen <= plen) {
> >                 /* Short packet: try for partial? */
> > @@ -312,16 +310,6 @@ static int find_pattern(const char *data, size_t dlen,
> >         }
> >
> >         if (strncasecmp(data, pattern, plen) != 0) {
> > -#if 0
> > -               size_t i;
> > -
> > -               pr_debug("ftp: string mismatch\n");
> > -               for (i = 0; i < plen; i++) {
> > -                       pr_debug("ftp:char %u `%c'(%u) vs `%c'(%u)\n",
> > -                                i, data[i], data[i],
> > -                                pattern[i], pattern[i]);
> > -               }
> > -#endif
> >                 return 0;
> >         }
> >
> > --
> > 1.9.1
> >
> >
> 
> Sorry, I forget one point. I also remove some codes which are
> commented out by #if0.

Please, do this in a separated patch. Thanks.
