From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH 4/6 RFC] netfilter: ebtables: audit table registration
Date: Fri, 2 Jun 2017 11:27:05 -0400
Message-ID: <CAHC9VhR_9LdeeYz9a2it-deXJwfLtNX2dhQs779r9ji9cskGAw@mail.gmail.com>
References: <cover.1495124188.git.rgb@redhat.com> <d3dbe9460fbe3b1b264c65237111b5c0e2b8ebf9.1495124188.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>, linux-audit@redhat.com,
        Florian Westphal <fw@strlen.de>,
        Thomas Woerner <twoerner@redhat.com>,
        Thomas Graf <tgraf@infradead.org>
To: Richard Guy Briggs <rgb@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:35793 "EHLO
        mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750813AbdFBP1H (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 2 Jun 2017 11:27:07 -0400
Received: by mail-lf0-f67.google.com with SMTP id v20so2049798lfa.2
        for <netfilter-devel@vger.kernel.org>; Fri, 02 Jun 2017 08:27:07 -0700 (PDT)
In-Reply-To: <d3dbe9460fbe3b1b264c65237111b5c0e2b8ebf9.1495124188.git.rgb@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 18, 2017 at 1:21 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
> Generate audit NETFILTER_CFG records on ebtables table registration.
>
> Previously this was only being done for all x_tables operations and ebtables
> table replacement.
>
> Audit only when there is an existing syscall audit rule, otherwise issue a
> standalone record only on table modification rather than empty table creation.
> Include subject attributes to the new standalone NETFILTER_CFGSOLO record using
> audit_log_task().
>
> Here is a sample accompanied record:
>   type=NETFILTER_CFG msg=audit(1494907217.558:5403): family=7 table=filter entries=0
>
> and unaccompanied case:
>   type=UNKNOWN[1331] msg=audit(1494723394.832:111): auid=4294967295 uid=0 gid=0 ses=4294967295 subj=system_u:system_r:iptables_t:s0 pid=556 comm="ebtables-restor" exe="/usr/sbin/ebtables-restore" family=7 table=broute entries=1
>
> See: https://github.com/linux-audit/audit-kernel/issues/43
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  net/bridge/netfilter/ebtables.c |   26 ++++++++++++++++++++++++++
>  1 files changed, 26 insertions(+), 0 deletions(-)
>
> diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
> index 743f9e6..7499232 100644
> --- a/net/bridge/netfilter/ebtables.c
> +++ b/net/bridge/netfilter/ebtables.c
> @@ -1251,6 +1251,32 @@ struct ebt_table * ebt_register_table(struct net *net,
>         }
>         list_add(&table->list, &net->xt.tables[NFPROTO_BRIDGE]);
>         mutex_unlock(&ebt_mutex);
> +#ifdef CONFIG_AUDIT
> +       if (audit_enabled) {
> +               struct audit_buffer *ab;
> +
> +               if(!audit_dummy_context()) {
> +                       ab = audit_log_start(current->audit_context, GFP_KERNEL,
> +                                            AUDIT_NETFILTER_CFG);
> +                       if (ab) {
> +                               audit_log_format(ab, "family=%u table=%s entries=%u",
> +                                                AF_BRIDGE, repl->name,
> +                                                repl->nentries);
> +                               audit_log_end(ab);
> +                       }
> +               } else if(repl->nentries) {
> +                       ab = audit_log_start(NULL, GFP_KERNEL,
> +                                            AUDIT_NETFILTER_CFGSOLO);
> +                       if (ab) {
> +                               audit_log_task(ab);
> +                               audit_log_format(ab, " family=%u table=%s entries=%u",
> +                                                AF_BRIDGE, repl->name,
> +                                                repl->nentries);
> +                               audit_log_end(ab);
> +                       }
> +               }
> +       }
> +#endif

Similar comments from patch 3/6 apply here, let's stick with a single
audit record type.

-- 
paul moore
www.paul-moore.com
