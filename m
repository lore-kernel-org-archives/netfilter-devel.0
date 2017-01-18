From: Doug Anderson <dianders@chromium.org>
Subject: Re: [RFC/PATCH 3/3] netfilter: ctnetlink: Fix regression in CTA_HELP processing
Date: Wed, 18 Jan 2017 11:08:55 -0800
Message-ID: <CAD=FV=VW7zwsuL5GVg1svdi_XhKYAhsYLM3qLBCpUBWa+rt+vA@mail.gmail.com>
References: <1484630048-25416-1-git-send-email-cernekee@chromium.org> <1484630048-25416-4-git-send-email-cernekee@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: pablo@netfilter.org, netfilter-devel@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>
To: Kevin Cernekee <cernekee@chromium.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f51.google.com ([74.125.82.51]:36385 "EHLO
        mail-wm0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753669AbdARTI6 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 18 Jan 2017 14:08:58 -0500
Received: by mail-wm0-f51.google.com with SMTP id c85so257730811wmi.1
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Jan 2017 11:08:57 -0800 (PST)
In-Reply-To: <1484630048-25416-4-git-send-email-cernekee@chromium.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Mon, Jan 16, 2017 at 9:14 PM, Kevin Cernekee <cernekee@chromium.org> wrote:
> If a user program specifies CTA_HELP but the argument matches the
> current conntrack helper name, ignore it instead of generating an error.

The "subject" of this patch says that it fixes a regression, but that
regression isn't explained anywhere.  The description of this patch
should make it obvious that the regression is the same as described in
your previous patch in this series: "netfilter: ctnetlink: Fix
regression in CTA_TIMEOUT processing".

Specifically: calling this twice with the same value has always
returned an error for the 2nd call, but that error didn't affect
things in quite the same way before commit b7bd1809e078 ("netfilter:
nfnetlink_queue: get rid of nfnetlink_queue_ct.c").


> Signed-off-by: Kevin Cernekee <cernekee@chromium.org>
> ---
>  net/netfilter/nf_conntrack_netlink.c | 13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
>
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
> index cc59f388928e..2912f582da65 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -1472,14 +1472,19 @@ ctnetlink_change_helper(struct nf_conn *ct, const struct nlattr * const cda[])
>         struct nlattr *helpinfo = NULL;
>         int err;
>
> -       /* don't change helper of sibling connections */
> -       if (ct->master)
> -               return -EBUSY;
> -
>         err = ctnetlink_parse_help(cda[CTA_HELP], &helpname, &helpinfo);
>         if (err < 0)
>                 return err;
>
> +       /* don't change helper of sibling connections */
> +       if (ct->master) {

As discussed in the Chromium OS review system:

https://chromium-review.googlesource.com/c/428494/1..2/net/netfilter/nf_conntrack_netlink.c

It feels like we need a comment here.  There you added:

* If we try to change the helper to the same thing twice,
* treat the second attempt as a no-op instead of returning
* an error.

That seems like a good comment.

> +               if (help && help->helper &&
> +                   !strcmp(help->helper->name, helpname))

I was also curious: do you need to also compare helpinfo to
helper->to_nlattr() ?

...effectively right now if you call this function twice with the same
value you want to avoid returning an error for the 2nd call, right?
...you just want to treat it as a no-op.  It seems like checking
"helpinfo" would be safer to really detect two calls with the same
value, but maybe I'm being paranoid...

> +                       return 0;
> +               else
> +                       return -EBUSY;
> +       }
> +
>         if (!strcmp(helpname, "")) {
>                 if (help && help->helper) {
>                         /* we had a helper before ... */
> --
> 2.7.4
>
