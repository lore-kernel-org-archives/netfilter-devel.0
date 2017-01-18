From: Doug Anderson <dianders@chromium.org>
Subject: Re: [RFC/PATCH 1/3] netfilter: ctnetlink: Fix regression in
 CTA_TIMEOUT processing
Date: Wed, 18 Jan 2017 10:54:24 -0800
Message-ID: <CAD=FV=Xb4SoPON-AK4J741r1oumRc7x_OOjFQQjE-_bRvxQFdw@mail.gmail.com>
References: <1484630048-25416-1-git-send-email-cernekee@chromium.org> <1484630048-25416-2-git-send-email-cernekee@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
To: Kevin Cernekee <cernekee@chromium.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1484630048-25416-2-git-send-email-cernekee@chromium.org>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

On Mon, Jan 16, 2017 at 9:14 PM, Kevin Cernekee <cernekee@chromium.org> wrote:
> Commit b7bd1809e078 ("netfilter: nfnetlink_queue: get rid of
> nfnetlink_queue_ct.c") introduced a new check on the return value
> from the NFQA_CT parser (currently ctnetlink_glue_parse_ct()).
> Prior to Linux 4.4, nfqnl_ct_parse() would process the NFQA_EXP
> attribute even if there were errors in the NFQA_CT attribute.
> After Linux 4.4, this is no longer true, so any error in the NFQA_CT
> attribute will cause the kernel to silently fail to create an
> expectation.
>
> The new check is causing user conntrack helpers to fail.  If a user
> program sends an NFQA_CT attribute containing a CTA_TIMEOUT attribute
> before the connection is confirmed (i.e. before the initial
> ACCEPT/DROP decision has been made), del_timer() in
> ctnetlink_change_timeout() will fail, and all further processing will be
> aborted.  The (simplified) calling sequence looks like:
>
>     nfnetlink_rcv_msg
>       nfqnl_recv_verdict
>         nfqnl_ct_parse
>           ctnetlink_glue_parse_ct
>             ctnetlink_change_timeout
>               del_timer [ERROR]
>         nf_reinject
>           __nf_conntrack_confirm
>
> Fix this by adding a case to ctnetlink_change_timeout() to handle
> unconfirmed connections.
>
> Also, if a timeout of 0 is set for an unconfirmed connection, restore the
> old behavior of ignoring it (rather than setting up a connection that
> expires immediately).
>
> Signed-off-by: Kevin Cernekee <cernekee@chromium.org>
> ---
>  net/netfilter/nf_conntrack_netlink.c | 12 ++++++++----
>  1 file changed, 8 insertions(+), 4 deletions(-)

I'm not an expert (I'd never looked at netlink code before yesterday),
but Kevin's explanation and proposal seem sane to me.  In case it's
helpful:

Reviewed-by: Douglas Anderson <dianders@chromium.org>
