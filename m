Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9394EC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed,  8 Jun 2022 11:09:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237912AbiFHLJE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 8 Jun 2022 07:09:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237937AbiFHLJC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 8 Jun 2022 07:09:02 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AECD22162AC
        for <netfilter-devel@vger.kernel.org>; Wed,  8 Jun 2022 04:09:00 -0700 (PDT)
Date:   Wed, 8 Jun 2022 13:08:56 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Cc:     netfilter-devel@vger.kernel.org, mikhail.sennikovsky@gmail.com
Subject: Re: [PATCH 1/1] conntrack: use same modifier socket for bulk ops
Message-ID: <YqCDSFZkF9v+Ki8j@salvia>
References: <20220602163429.52490-1-mikhail.sennikovskii@ionos.com>
 <20220602163429.52490-2-mikhail.sennikovskii@ionos.com>
 <YqA/RNP5jQzIRpon@salvia>
 <CALHVEJZbcASEfTn4Qc0uAf6PpHLZZb_wHgfmMsjdEkaLSRHyQA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALHVEJZbcASEfTn4Qc0uAf6PpHLZZb_wHgfmMsjdEkaLSRHyQA@mail.gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 08, 2022 at 01:02:30PM +0200, Mikhail Sennikovsky wrote:
> Hi Pablo,
> 
> IIRC we never had a code that was using nfct_mnl_socket_check_open for
> CT_EVENT and friends, because it is not needed there, as they can not
> be used in the bulk operations.

Not sure I follow. My question is: is this new events field really required?

> Regards,
> Mikhail
> 
> On Wed, 8 Jun 2022 at 08:18, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > Hi Mikhail,
> >
> > On Thu, Jun 02, 2022 at 06:34:29PM +0200, Mikhail Sennikovsky wrote:
> > > For bulk ct entry loads (with -R option) reusing the same mnl
> > > modifier socket for all entries results in reduction of entries
> > > creation time, which becomes especially signifficant when loading
> > > tens of thouthand of entries.
> > >
> > > Signed-off-by: Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
> > > ---
> > >  src/conntrack.c | 31 +++++++++++++++++++++++++------
> > >  1 file changed, 25 insertions(+), 6 deletions(-)
> > >
> > > diff --git a/src/conntrack.c b/src/conntrack.c
> > > index 27e2bea..be8690b 100644
> > > --- a/src/conntrack.c
> > > +++ b/src/conntrack.c
> > > @@ -71,6 +71,7 @@
> > >  struct nfct_mnl_socket {
> > >       struct mnl_socket       *mnl;
> > >       uint32_t                portid;
> > > +     uint32_t                events;
> > >  };
> > >
> > >  static struct nfct_mnl_socket _sock;
> > > @@ -2441,6 +2442,7 @@ static int nfct_mnl_socket_open(struct nfct_mnl_socket *socket,
> > >               return -1;
> > >       }
> > >       socket->portid = mnl_socket_get_portid(socket->mnl);
> > > +     socket->events = events;
> > >
> > >       return 0;
> > >  }
> > > @@ -2470,6 +2472,25 @@ static void nfct_mnl_socket_close(const struct nfct_mnl_socket *sock)
> > >       mnl_socket_close(sock->mnl);
> > >  }
> > >
> > > +static int nfct_mnl_socket_check_open(struct nfct_mnl_socket *socket,
> > > +                                    unsigned int events)
> > > +{
> > > +     if (socket->mnl != NULL) {
> > > +             assert(events == socket->events);
> > > +             return 0;
> > > +     }
> > > +
> > > +     return nfct_mnl_socket_open(socket, events);
> > > +}
> > > +
> > > +static void nfct_mnl_socket_check_close(struct nfct_mnl_socket *sock)
> > > +{
> > > +     if (sock->mnl) {
> > > +             nfct_mnl_socket_close(sock);
> > > +             memset(sock, 0, sizeof(*sock));
> > > +     }
> > > +}
> > > +
> > >  static int __nfct_mnl_dump(struct nfct_mnl_socket *sock,
> > >                          const struct nlmsghdr *nlh, mnl_cb_t cb, void *data)
> > >  {
> > > @@ -3383,19 +3404,17 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd,
> > >               break;
> > >
> > >       case CT_UPDATE:
> > > -             if (nfct_mnl_socket_open(modifier_sock, 0) < 0)
> > > +             if (nfct_mnl_socket_check_open(modifier_sock, 0) < 0)
> > >                       exit_error(OTHER_PROBLEM, "Can't open handler");
> > >
> > >               nfct_filter_init(cmd);
> > >               res = nfct_mnl_dump(sock, NFNL_SUBSYS_CTNETLINK,
> > >                                   IPCTNL_MSG_CT_GET, mnl_nfct_update_cb,
> > >                                   cmd, NULL);
> > > -
> > > -             nfct_mnl_socket_close(modifier_sock);
> > >               break;
> > >
> > >       case CT_DELETE:
> > > -             if (nfct_mnl_socket_open(modifier_sock, 0) < 0)
> > > +             if (nfct_mnl_socket_check_open(modifier_sock, 0) < 0)
> >
> > No events needed anymore?
> >
> > nfct_mnl_socket_check_open() is now only used by CT_UPDATE and CT_DELETE,
> > right?
> >
> > >                       exit_error(OTHER_PROBLEM, "Can't open handler");
> > >
> > >               nfct_filter_init(cmd);
> > > @@ -3418,8 +3437,6 @@ static int do_command_ct(const char *progname, struct ct_cmd *cmd,
> > >                                   cmd, filter_dump);
> > >
> > >               nfct_filter_dump_destroy(filter_dump);
> > > -
> > > -             nfct_mnl_socket_close(modifier_sock);
> > >               break;
> > >
> > >       case EXP_DELETE:
> > > @@ -3857,6 +3874,7 @@ static const char *ct_unsupp_cmd_file(const struct ct_cmd *cmd)
> > >  int main(int argc, char *argv[])
> > >  {
> > >       struct nfct_mnl_socket *sock = &_sock;
> > > +     struct nfct_mnl_socket *modifier_sock = &_modifier_sock;
> > >       struct ct_cmd *cmd, *next;
> > >       LIST_HEAD(cmd_list);
> > >       int res = 0;
> > > @@ -3900,6 +3918,7 @@ int main(int argc, char *argv[])
> > >               free(cmd);
> > >       }
> > >       nfct_mnl_socket_close(sock);
> > > +     nfct_mnl_socket_check_close(modifier_sock);
> > >
> > >       return res < 0 ? EXIT_FAILURE : EXIT_SUCCESS;
> > >  }
> > > --
> > > 2.25.1
> > >
