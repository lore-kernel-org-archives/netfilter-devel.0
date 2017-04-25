From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrack-tools PATCH 2/4] conntrackd: warn users about queue
 allocation errors
Date: Tue, 25 Apr 2017 15:16:53 +0200
Message-ID: <20170425131653.GA1050@salvia>
References: <149270928083.1751.9498250834672625764.stgit@nfdev2.cica.es>
 <149270928606.1751.8172963085482513292.stgit@nfdev2.cica.es>
 <20170425113401.GA5355@salvia>
 <CAOkSjBh8rV0U1FjWYsOetKBzGyzMH4dx44ir+h6CikZdrWS5Eg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55862 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1947692AbdDYNQ6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Apr 2017 09:16:58 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 817E61A0987
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 15:16:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 710D5FF145
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 15:16:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 33709FF2C8
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Apr 2017 15:16:50 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <CAOkSjBh8rV0U1FjWYsOetKBzGyzMH4dx44ir+h6CikZdrWS5Eg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 25, 2017 at 02:40:45PM +0200, Arturo Borrero Gonzalez wrote:
> On 25 April 2017 at 13:34, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Thu, Apr 20, 2017 at 07:28:06PM +0200, Arturo Borrero Gonzalez wrote:
> >> These warnings, if they happen, should help users.
> >>
> >> Signed-off-by: Arturo Borrero Gonzalez <arturo@debian.org>
> >> ---
> >>  src/channel.c  |    6 +++++-
> >>  src/queue_tx.c |   11 +++++++++--
> >>  2 files changed, 14 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/src/channel.c b/src/channel.c
> >> index acbfa7d..b2f114d 100644
> >> --- a/src/channel.c
> >> +++ b/src/channel.c
> >> @@ -19,6 +19,7 @@
> >>  #include "channel.h"
> >>  #include "network.h"
> >>  #include "queue.h"
> >> +#include "log.h"
> >>
> >>  static struct channel_ops *ops[CHANNEL_MAX];
> >>  extern struct channel_ops channel_mcast;
> >> @@ -161,8 +162,11 @@ static void channel_enqueue_errors(struct channel *c)
> >>       struct channel_error *error;
> >>
> >>       qobj = queue_object_new(Q_ELEM_ERR, sizeof(struct channel_error));
> >> -     if (qobj == NULL)
> >> +     if (qobj == NULL) {
> >> +             dlog(LOG_WARNING, "could not enqueue channel errors, failed to"
> >> +                  " allocate memory");
> >
> > Did you ever hit this?
> >
>
> I don't know, no way to know in a production system since this happen silently.

No problem. I just wanted to know if you're addressing a real issue or
you just found this spot with not log message when passing by.

> Since conntrackd can be of critical importance in some environments I
> guess it doesn't harm to be more verbose. This concrete memory
> allocation failure isn't interesting per se, but it could be related
> to other more serious issues on the system.

Yes, but this is going to full the logs if ever happen.

Better add stats:

        /* statistics */
        struct {
                uint64_t        msg_rcv_malformed;
                uint32_t        msg_rcv_bad_version;
                uint32_t        msg_rcv_bad_payload;
                uint32_t        msg_rcv_bad_header;
                uint32_t        msg_rcv_bad_type;
                uint32_t        msg_rcv_truncated;
                uint32_t        msg_rcv_bad_size;
                uint32_t        msg_snd_malformed;
                uint64_t        msg_rcv_lost;
                uint64_t        msg_rcv_before;
        } error;

A quick glance at the code to see how we're globaling deal with lack
of memory would be good. There's little we can do in that situation,
and in my experience this most likely point to a memory leak.

So better follow a less agressive way than filling the logs, OK? We
indeed have a way to report this via the existing -s options.
