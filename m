Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9F52C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jun 2022 14:16:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241014AbiFHOQu (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Jun 2022 10:16:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241002AbiFHOQt (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Jun 2022 10:16:49 -0400
Received: from mail-lf1-x130.google.com (mail-lf1-x130.google.com [IPv6:2a00:1450:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 306D93E0EC
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Jun 2022 07:16:47 -0700 (PDT)
Received: by mail-lf1-x130.google.com with SMTP id y32so33458550lfa.6
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Jun 2022 07:16:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jApBwNk7J2ekigizB6Id94lYW0gLArd9bKHGBpcVuY4=;
        b=WVoCZ1pDyLPNI4uYLLMJB0kjoaKXZ7FCEXLanaxwU47j7ITnJM2BDbALqV4bXiTCxR
         56wLFgsOzovHjuqi7H8z7xGUMeJZz5gWwkTZtiDuWJgtpMhhSHtSAVBt6tOlJh/cuXr4
         kXgc1zF4bku15uz1H2UVq7+LDKjX0lzZr6U+WelgAoM48+jvd4HPlXE4L3q4D9NCH15g
         eE0MStbC7LYR3qiDvlUsCStCVuBNKcFiz4ry4MB6r1ns1tFKrzMMcQac4nsIG/azqr6u
         cDwPxNooaDhezX+yf1w/uhDCDiTqsU7awXvzkeehAeI51MX6ekA1hO0DZSREWK58tYYM
         B1bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jApBwNk7J2ekigizB6Id94lYW0gLArd9bKHGBpcVuY4=;
        b=FNTwx4m0PtQhm1nSCRjSPCG/DZVTxv2YfZBRRg9GkBT4YWom4SmFihJAgVFlor6917
         ZyBdncMDLqbE7emPE7A9zr9diiDkIalJG/qS1f6IfQQJHlWyHwOAqycBzG8hrFYOLK3D
         RUMlBKI9Yq2TXYY3HPJdDHYJfkAS8VSyw8kpjbou82OKrJoC+t7w3b/M3Jw70xAqiwJY
         8EfzScIT+MYEg6j+rom8t7pO7r5d1xrZTAbCwGyofIUh60lxxcN5kEIln5DoPB1sPObF
         xnyCmB36B4SJJDx3xkxOvYOi5FAUYnXQm/XPaNA8DkMP4R0pHRkf04LX8OAQRWbDq6/G
         ArEQ==
X-Gm-Message-State: AOAM532E2cK6ztBwnndZYrLjlgVei2/yho66mutX5L4bUPQ11WOx8nMj
        MM6C5ZCxb+A9YLWdRMnPTudhxAkllGpSMo+Qgih3rQ==
X-Google-Smtp-Source: ABdhPJyZwd7+b/t0Ai0V1R4wUlO3ahje/Uk2WRcK7bpUv+EocWq9vMNUXu5vdLLZDRDDL6u/V8hD26U73h7xfkUy3pk=
X-Received: by 2002:a05:6512:3401:b0:479:4000:fbe1 with SMTP id
 i1-20020a056512340100b004794000fbe1mr10732154lfr.228.1654697806125; Wed, 08
 Jun 2022 07:16:46 -0700 (PDT)
MIME-Version: 1.0
References: <20220602163429.52490-1-mikhail.sennikovskii@ionos.com>
 <20220602163429.52490-2-mikhail.sennikovskii@ionos.com> <YqA/RNP5jQzIRpon@salvia>
 <CALHVEJZbcASEfTn4Qc0uAf6PpHLZZb_wHgfmMsjdEkaLSRHyQA@mail.gmail.com>
 <YqCDSFZkF9v+Ki8j@salvia> <YqCFrd8SDwnHr+rE@salvia>
In-Reply-To: <YqCFrd8SDwnHr+rE@salvia>
From:   Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Date:   Wed, 8 Jun 2022 16:16:34 +0200
Message-ID: <CALHVEJZ1X+yige_5=daMGfjPcFjQeFmeb2RCDW1=_hSk7eR+wA@mail.gmail.com>
Subject: Re: [PATCH 1/1] conntrack: use same modifier socket for bulk ops
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, mikhail.sennikovsky@gmail.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

Then I misunderstood you, my bad.
Yes, _check is never used for events, and the socket->events is not
used anywhere except the assert(events == socket->events); assertion
check which I found useful as a sanity check for potential future uses
of the nfct_mnl_socket_check_open.
If you find it unneeded however, I'm fine with removing it.

Mikhail

On Wed, 8 Jun 2022 at 13:19, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> On Wed, Jun 08, 2022 at 01:08:56PM +0200, Pablo Neira Ayuso wrote:
> > On Wed, Jun 08, 2022 at 01:02:30PM +0200, Mikhail Sennikovsky wrote:
> > > Hi Pablo,
> > >
> > > IIRC we never had a code that was using nfct_mnl_socket_check_open for
> > > CT_EVENT and friends, because it is not needed there, as they can not
> > > be used in the bulk operations.
> >
> > Not sure I follow. My question is: is this new events field really required?
>
> sock->mnl is always set on at the beginning of the batch processing.
> That remains unaltered.
>
> Then we have the modifier socket, which is used for update and delete.
> This is conditionally opened. The new _check function just checks if
> this socket is open, if so re-use it.
>
> _check is now never used for events.
>
> Correct?
>
> > > Regards,
> > > Mikhail
> > >
> > > On Wed, 8 Jun 2022 at 08:18, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > > >
> > > > Hi Mikhail,
> > > >
> > > > On Thu, Jun 02, 2022 at 06:34:29PM +0200, Mikhail Sennikovsky wrote:
> > > > > For bulk ct entry loads (with -R option) reusing the same mnl
> > > > > modifier socket for all entries results in reduction of entries
> > > > > creation time, which becomes especially signifficant when loading
> > > > > tens of thouthand of entries.
> > > > >
> > > > > Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
> > > > > ---
> > > > >  src/conntrack.c | 31 +++++++++++++++++++++++++------
> > > > >  1 file changed, 25 insertions(+), 6 deletions(-)
> > > > >
> > > > > diff --git a/src/conntrack.c b/src/conntrack.c
> > > > > index 27e2bea..be8690b 100644
> > > > > --- a/src/conntrack.c
> > > > > +++ b/src/conntrack.c
> > > > > @@ -71,6 +71,7 @@
> > > > >  struct nfct_mnl_socket {
> > > > >       struct mnl_socket       *mnl;
> > > > >       uint32_t                portid;
> > > > > +     uint32_t                events;
> > > > >  };
> > > > >
> > > > >  static struct nfct_mnl_socket _sock;
> > > > > @@ -2441,6 +2442,7 @@ static int nfct_mnl_socket_open(struct nfct_mnl_socket *socket,
> > > > >               return -1;
> > > > >       }
> > > > >       socket->portid = mnl_socket_get_portid(socket->mnl);
> > > > > +     socket->events = events;
> > > > >
> > > > >       return 0;
> > > > >  }
> > > > > @@ -2470,6 +2472,25 @@ static void nfct_mnl_socket_close(const struct nfct_mnl_socket *sock)
> > > > >       mnl_socket_close(sock->mnl);
> > > > >  }
> > > > >
> > > > > +static int nfct_mnl_socket_check_open(struct nfct_mnl_socket *socket,
> > > > > +                                    unsigned int events)
> > > > > +{
> > > > > +     if (socket->mnl != NULL) {
> > > > > +             assert(events == socket->events);
> > > > > +             return 0;
> > > > > +     }
> > > > > +
> > > > > +     return nfct_mnl_socket_open(socket, events);
> > > > > +}
> > > > > +
> > > > > +static void nfct_mnl_socket_check_close(struct nfct_mnl_socket *sock)
> > > > > +{
> > > > > +     if (sock->mnl) {
> > > > > +             nfct_mnl_socket_close(sock);
> > > > > +             memset(sock, 0, sizeof(*sock));
> > > > > +     }
> > > > > +}
> > > > > +
> > > > >  static int __nfct_mnl_dump(struct nfct_mnl_socket *sock,
> > > > >                          const struct nlmsghdr *nlh, mnl_cb_t cb, void *data)
> > > > >  {
> > > > > @@ -3383,19 +3404,17 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd,
> > > > >               break;
> > > > >
> > > > >       case CT_UPDATE:
> > > > > -             if (nfct_mnl_socket_open(modifier_sock, 0) < 0)
> > > > > +             if (nfct_mnl_socket_check_open(modifier_sock, 0) < 0)
> > > > >                       exit_error(OTHER_PROBLEM, "Can't open handler");
> > > > >
> > > > >               nfct_filter_init(cmd);
> > > > >               res = nfct_mnl_dump(sock, NFNL_SUBSYS_CTNETLINK,
>
>
>
>
>
>
> > > > >                                   IPCTNL_MSG_CT_GET, mnl_nfct_update_cb,
> > > > >                                   cmd, NULL);
> > > > > -
> > > > > -             nfct_mnl_socket_close(modifier_sock);
> > > > >               break;
> > > > >
> > > > >       case CT_DELETE:
> > > > > -             if (nfct_mnl_socket_open(modifier_sock, 0) < 0)
> > > > > +             if (nfct_mnl_socket_check_open(modifier_sock, 0) < 0)
> > > >
> > > > No events needed anymore?
> > > >
> > > > nfct_mnl_socket_check_open() is now only used by CT_UPDATE and CT_DELETE,
> > > > right?
> > > >
> > > > >                       exit_error(OTHER_PROBLEM, "Can't open handler");
> > > > >
> > > > >               nfct_filter_init(cmd);
> > > > > @@ -3418,8 +3437,6 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd,
> > > > >                                   cmd, filter_dump);
> > > > >
> > > > >               nfct_filter_dump_destroy(filter_dump);
> > > > > -
> > > > > -             nfct_mnl_socket_close(modifier_sock);
> > > > >               break;
> > > > >
> > > > >       case EXP_DELETE:
> > > > > @@ -3857,6 +3874,7 @@ static const char *ct_unsupp_cmd_file(const struct ct_cmd *cmd)
> > > > >  int main(int argc, char *argv[])
> > > > >  {
> > > > >       struct nfct_mnl_socket *sock = &_sock;
> > > > > +     struct nfct_mnl_socket *modifier_sock = &_modifier_sock;
> > > > >       struct ct_cmd *cmd, *next;
> > > > >       LIST_HEAD(cmd_list);
> > > > >       int res = 0;
> > > > > @@ -3900,6 +3918,7 @@ int main(int argc, char *argv[])
> > > > >               free(cmd);
> > > > >       }
> > > > >       nfct_mnl_socket_close(sock);
> > > > > +     nfct_mnl_socket_check_close(modifier_sock);
> > > > >
> > > > >       return res < 0 ? EXIT_FAILURE : EXIT_SUCCESS;
> > > > >  }
> > > > > --
> > > > > 2.25.1
> > > > >
