From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] libxtables: xtables.c: Use getnameinfo()
Date: Sun, 11 Dec 2016 21:25:04 +0100
Message-ID: <20161211202504.GA12091@salvia>
References: <1481284200-6104-1-git-send-email-mayhs11saini@gmail.com>
 <20161211200226.GA11648@salvia>
 <20161211200516.GA11702@salvia>
 <CAKHNQQFa0FO2jdGWkE+AhmXTXbjNzUJk=d_B1H2Q=-FDB829_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Shyam Saini <mayhs11saini@gmail.com>,
        Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44562 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752588AbcLKUZP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 11 Dec 2016 15:25:15 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 3A5D496EC9
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Dec 2016 21:25:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 2B842DA729
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Dec 2016 21:25:12 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id B63AAA7D42
        for <netfilter-devel@vger.kernel.org>; Sun, 11 Dec 2016 21:25:09 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAKHNQQFa0FO2jdGWkE+AhmXTXbjNzUJk=d_B1H2Q=-FDB829_w@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Dec 12, 2016 at 01:47:00AM +0530, Shivani Bhardwaj wrote:
> On Mon, Dec 12, 2016 at 1:35 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Sun, Dec 11, 2016 at 09:02:26PM +0100, Pablo Neira Ayuso wrote:
> >> On Fri, Dec 09, 2016 at 05:20:00PM +0530, Shyam Saini wrote:
> >> > Use getnameinfo() instead of deprecated gethostbyaddr()
> >> >
> >> > Signed-off-by: Shyam Saini <mayhs11saini@gmail.com>
> >> > ---
> >> >  libxtables/xtables.c | 25 ++++++++++++++++++++-----
> >> >  1 file changed, 20 insertions(+), 5 deletions(-)
> >> >
> >> > diff --git a/libxtables/xtables.c b/libxtables/xtables.c
> >> > index 921dfe9..338e325 100644
> >> > --- a/libxtables/xtables.c
> >> > +++ b/libxtables/xtables.c
> >> > @@ -1210,13 +1210,28 @@ const char *xtables_ipaddr_to_numeric(const struct in_addr *addrp)
> >> >
> >> >  static const char *ipaddr_to_host(const struct in_addr *addr)
> >> >  {
> >> > -   struct hostent *host;
> >> > +   static char hostname[NI_MAXHOST];
> >> > +   struct sockaddr_in saddr;
> >> > +   int err;
> >> >
> >> > -   host = gethostbyaddr(addr, sizeof(struct in_addr), AF_INET);
> >> > -   if (host == NULL)
> >> > -           return NULL;
> >> > +   memset(&saddr, 0, sizeof(struct sockaddr_in));
> >> > +   memcpy(&saddr.sin_addr, addr, sizeof(*addr));
> >>
> >> You can skip this by perfoming C99 initialization, eg.
> >>
> >>         struct sockaddr_in sin = { .sin_family = AF_INET, };
> >>         sin.sin_addr = *addr;
> >
> > One more comment below.
> >
> >> > +   saddr.sin_family = AF_INET;
> >> > +
> >> > +   err = getnameinfo((const void *)&saddr, sizeof(struct sockaddr_in),
> >> > +                                 hostname, sizeof(hostname) - 1, NULL, 0, 0);
> >> > +
> >> > +    if (err != 0) {
> >> > +#ifdef DEBUG
> >> > +            fprintf(stderr,"IP2Name: %s\n",gai_strerror(err));
> >> > +#endif
> >
> > I don't remember to have used this debugging this ever, probably it is
> > good to remove it.
> >
> 
> Debugging code has been in this applied patch too:
> http://git.netfilter.org/iptables/commit/?id=2d2b5e046aa56a518160716a9ddf9df53fc79c1f.
> Maybe its good to remove it as well then?

Yes, please remove all debugging in libxtables/xtables.c, in an
initial patch.

Thanks.
