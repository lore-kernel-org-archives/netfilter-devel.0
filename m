Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8877FC43334
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jun 2022 11:02:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236041AbiFHLCr (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Jun 2022 07:02:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237318AbiFHLCq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Jun 2022 07:02:46 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99C5D1ABF8B
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Jun 2022 04:02:44 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id u23so32677113lfc.1
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Jun 2022 04:02:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Rv3CQPZ7xBnhNagOQUd+GDVAWv/oDlIGfAQrZELOYNM=;
        b=S9yMXsI0Ss1qHl5rj7bdZ8yZPfYFZKfXSYMExHgauuylubrk6F5bLfpshzt2NwLji3
         D5GoHXWRmYbcLyFFf3TOpQvFmH8qPsZqg0JnAUieOOblYFmP2H7V8JIXFomHwivlUcYL
         pOVR1pR6BOdeOgdFg+xNf7Iesh7klk6Bl+2gIe390gavVzJWUsrA0wNsMkTskn9KHGNl
         EUMHkCfD5rHLSkUa31ZNt+6UjXHQVoe85BI/QDyskJUm4jZkBOnma4rn7iz1A38PuAlk
         x5H5vfveb/WICOjCCSCJtt84KWDwuZQF6A5ZDmNa7Unm1Fvy7WHeS2Cg4KDBA9ZNJzcn
         BtaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Rv3CQPZ7xBnhNagOQUd+GDVAWv/oDlIGfAQrZELOYNM=;
        b=DuYHGVx4mSeMQTk9fI0vAMpAbYOHS0CWUuR5zG9Xk6wml6oJkI5H/otVl70tlTer4b
         qAXc9x64E0al+I2rw9FP0bgFIlhXWO3iVLFCm3bXjLGRbgL13xJYD6ZoV/AoyHhNrul1
         UXtSnHGk4h85+XfZ8IAax9SlPFmCu8nMCVSROHBqfoaf6hW/rFcCmIKEqDTruxYIxtdy
         Tq8nj1m9075q04uxL8nSr1fRSR2AFba/Xfp6Z0za8RnkM/y/wu7AT2pZRD87yzJK7DDF
         XZNPT7o7XWUGroXJbC4X0oNsyqknDuxBSpLjSNf32nfLNa7hmeQgstNaUd1leeMP1TrE
         lGhw==
X-Gm-Message-State: AOAM5319zbBxNGpLwQFzokhuiqMeC5sBWxMmLnx3eRBpnfc9YQJEZk5q
        /NcNu+/5aLNxguOtd9aYqnvNEIQg9unJOfuE/MLNfqY7qRoGrg==
X-Google-Smtp-Source: ABdhPJw/tlqrGVLgtjqNo3ITVcwpxH3uG0CJJu192cySzgOX3L6iCTBDWs2HldeHtBww8harEIGV65hYdBNLRtVBo44=
X-Received: by 2002:a05:6512:3b26:b0:479:5610:5672 with SMTP id
 f38-20020a0565123b2600b0047956105672mr7437550lfv.464.1654686162964; Wed, 08
 Jun 2022 04:02:42 -0700 (PDT)
MIME-Version: 1.0
References: <20220602163429.52490-1-mikhail.sennikovskii@ionos.com>
 <20220602163429.52490-2-mikhail.sennikovskii@ionos.com> <YqA/RNP5jQzIRpon@salvia>
In-Reply-To: <YqA/RNP5jQzIRpon@salvia>
From:   Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Date:   Wed, 8 Jun 2022 13:02:30 +0200
Message-ID: <CALHVEJZbcASEfTn4Qc0uAf6PpHLZZb_wHgfmMsjdEkaLSRHyQA@mail.gmail.com>
Subject: Re: [PATCH 1/1] conntrack: use same modifier socket for bulk ops
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, mikhail.sennikovsky@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

IIRC we never had a code that was using nfct_mnl_socket_check_open for
CT_EVENT and friends, because it is not needed there, as they can not
be used in the bulk operations.

Regards,
Mikhail

On Wed, 8 Jun 2022 at 08:18, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> Hi Mikhail,
>
> On Thu, Jun 02, 2022 at 06:34:29PM +0200, Mikhail Sennikovsky wrote:
> > For bulk ct entry loads (with -R option) reusing the same mnl
> > modifier socket for all entries results in reduction of entries
> > creation time, which becomes especially signifficant when loading
> > tens of thouthand of entries.
> >
> > Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
> > ---
> >  src/conntrack.c | 31 +++++++++++++++++++++++++------
> >  1 file changed, 25 insertions(+), 6 deletions(-)
> >
> > diff --git a/src/conntrack.c b/src/conntrack.c
> > index 27e2bea..be8690b 100644
> > --- a/src/conntrack.c
> > +++ b/src/conntrack.c
> > @@ -71,6 +71,7 @@
> >  struct nfct_mnl_socket {
> >       struct mnl_socket       *mnl;
> >       uint32_t                portid;
> > +     uint32_t                events;
> >  };
> >
> >  static struct nfct_mnl_socket _sock;
> > @@ -2441,6 +2442,7 @@ static int nfct_mnl_socket_open(struct nfct_mnl_socket *socket,
> >               return -1;
> >       }
> >       socket->portid = mnl_socket_get_portid(socket->mnl);
> > +     socket->events = events;
> >
> >       return 0;
> >  }
> > @@ -2470,6 +2472,25 @@ static void nfct_mnl_socket_close(const struct nfct_mnl_socket *sock)
> >       mnl_socket_close(sock->mnl);
> >  }
> >
> > +static int nfct_mnl_socket_check_open(struct nfct_mnl_socket *socket,
> > +                                    unsigned int events)
> > +{
> > +     if (socket->mnl != NULL) {
> > +             assert(events == socket->events);
> > +             return 0;
> > +     }
> > +
> > +     return nfct_mnl_socket_open(socket, events);
> > +}
> > +
> > +static void nfct_mnl_socket_check_close(struct nfct_mnl_socket *sock)
> > +{
> > +     if (sock->mnl) {
> > +             nfct_mnl_socket_close(sock);
> > +             memset(sock, 0, sizeof(*sock));
> > +     }
> > +}
> > +
> >  static int __nfct_mnl_dump(struct nfct_mnl_socket *sock,
> >                          const struct nlmsghdr *nlh, mnl_cb_t cb, void *data)
> >  {
> > @@ -3383,19 +3404,17 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd,
> >               break;
> >
> >       case CT_UPDATE:
> > -             if (nfct_mnl_socket_open(modifier_sock, 0) < 0)
> > +             if (nfct_mnl_socket_check_open(modifier_sock, 0) < 0)
> >                       exit_error(OTHER_PROBLEM, "Can't open handler");
> >
> >               nfct_filter_init(cmd);
> >               res = nfct_mnl_dump(sock, NFNL_SUBSYS_CTNETLINK,
> >                                   IPCTNL_MSG_CT_GET, mnl_nfct_update_cb,
> >                                   cmd, NULL);
> > -
> > -             nfct_mnl_socket_close(modifier_sock);
> >               break;
> >
> >       case CT_DELETE:
> > -             if (nfct_mnl_socket_open(modifier_sock, 0) < 0)
> > +             if (nfct_mnl_socket_check_open(modifier_sock, 0) < 0)
>
> No events needed anymore?
>
> nfct_mnl_socket_check_open() is now only used by CT_UPDATE and CT_DELETE,
> right?
>
> >                       exit_error(OTHER_PROBLEM, "Can't open handler");
> >
> >               nfct_filter_init(cmd);
> > @@ -3418,8 +3437,6 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd,
> >                                   cmd, filter_dump);
> >
> >               nfct_filter_dump_destroy(filter_dump);
> > -
> > -             nfct_mnl_socket_close(modifier_sock);
> >               break;
> >
> >       case EXP_DELETE:
> > @@ -3857,6 +3874,7 @@ static const char *ct_unsupp_cmd_file(const struct ct_cmd *cmd)
> >  int main(int argc, char *argv[])
> >  {
> >       struct nfct_mnl_socket *sock = &_sock;
> > +     struct nfct_mnl_socket *modifier_sock = &_modifier_sock;
> >       struct ct_cmd *cmd, *next;
> >       LIST_HEAD(cmd_list);
> >       int res = 0;
> > @@ -3900,6 +3918,7 @@ int main(int argc, char *argv[])
> >               free(cmd);
> >       }
> >       nfct_mnl_socket_close(sock);
> > +     nfct_mnl_socket_check_close(modifier_sock);
> >
> >       return res < 0 ? EXIT_FAILURE : EXIT_SUCCESS;
> >  }
> > --
> > 2.25.1
> >
