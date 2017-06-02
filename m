From: Paul Moore <paul@paul-moore.com>
Subject: Re: [PATCH 5/6 RFC] netfilter: add audit operation field
Date: Fri, 2 Jun 2017 11:28:25 -0400
Message-ID: <CAHC9VhQw3=hCp4p6_0Oe657D0pVNsOuPoGhycUCqeW_LDHmWPg@mail.gmail.com>
References: <cover.1495124188.git.rgb@redhat.com>
	<dc0ac01f79f91a817b9a3f1e7c37f5805329c8e5.1495124188.git.rgb@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: Thomas Woerner <twoerner@redhat.com>, Florian Westphal <fw@strlen.de>,
	linux-audit@redhat.com,
	Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>,
	Thomas Graf <tgraf@infradead.org>
To: Richard Guy Briggs <rgb@redhat.com>
Return-path: <linux-audit-bounces@redhat.com>
In-Reply-To: <dc0ac01f79f91a817b9a3f1e7c37f5805329c8e5.1495124188.git.rgb@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/linux-audit>
List-Post: <mailto:linux-audit@redhat.com>
List-Help: <mailto:linux-audit-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/linux-audit>,
	<mailto:linux-audit-request@redhat.com?subject=subscribe>
Sender: linux-audit-bounces@redhat.com
Errors-To: linux-audit-bounces@redhat.com
List-Id: netfilter-devel.vger.kernel.org

On Thu, May 18, 2017 at 1:21 PM, Richard Guy Briggs <rgb@redhat.com> wrote:
> Add the operation performed (register or replace) to the NETFILTER_CFG and
> NETFILTER_CFGSOLO records.
>
> Here are sample records for accompanied:
>   type=NETFILTER_CFG msg=audit(1494981627.248:9764): op=replace family=7 table=broute entries=0
>
> and unaccompanied cases:
>   type=UNKNOWN[1331] msg=audit(1494815998.178:167): auid=4294967295 uid=0 gid=0 ses=4294967295 subj=system_u:system_r:iptables_t:s0 pid=598 comm="ip6tables-resto" exe="/usr/sbin/xtables-multi" op=replace family=10 table=filter entries=4

A reminder to add new fields to the end of the record.

> See: https://github.com/linux-audit/audit-kernel/issues/25
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  net/bridge/netfilter/ebtables.c |    8 ++++----
>  net/netfilter/x_tables.c        |    5 +++--
>  2 files changed, 7 insertions(+), 6 deletions(-)
>
> diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
> index 7499232..59b63a8 100644
> --- a/net/bridge/netfilter/ebtables.c
> +++ b/net/bridge/netfilter/ebtables.c
> @@ -1075,7 +1075,7 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
>                         ab = audit_log_start(current->audit_context, GFP_KERNEL,
>                                              AUDIT_NETFILTER_CFG);
>                         if (ab) {
> -                               audit_log_format(ab, "family=%u table=%s entries=%u",
> +                               audit_log_format(ab, "op=replace family=%u table=%s entries=%u",
>                                                  AF_BRIDGE, repl->name,
>                                                  repl->nentries);
>                                 audit_log_end(ab);
> @@ -1085,7 +1085,7 @@ static int do_replace_finish(struct net *net, struct ebt_replace *repl,
>                                              AUDIT_NETFILTER_CFGSOLO);
>                         if (ab) {
>                                 audit_log_task(ab);
> -                               audit_log_format(ab, " family=%u table=%s entries=%u",
> +                               audit_log_format(ab, " op=replace family=%u table=%s entries=%u",
>                                                  AF_BRIDGE, repl->name,
>                                                  repl->nentries);
>                                 audit_log_end(ab);
> @@ -1259,7 +1259,7 @@ struct ebt_table * ebt_register_table(struct net *net,
>                         ab = audit_log_start(current->audit_context, GFP_KERNEL,
>                                              AUDIT_NETFILTER_CFG);
>                         if (ab) {
> -                               audit_log_format(ab, "family=%u table=%s entries=%u",
> +                               audit_log_format(ab, "op=register family=%u table=%s entries=%u",
>                                                  AF_BRIDGE, repl->name,
>                                                  repl->nentries);
>                                 audit_log_end(ab);
> @@ -1269,7 +1269,7 @@ struct ebt_table * ebt_register_table(struct net *net,
>                                              AUDIT_NETFILTER_CFGSOLO);
>                         if (ab) {
>                                 audit_log_task(ab);
> -                               audit_log_format(ab, " family=%u table=%s entries=%u",
> +                               audit_log_format(ab, " op=register family=%u table=%s entries=%u",
>                                                  AF_BRIDGE, repl->name,
>                                                  repl->nentries);
>                                 audit_log_end(ab);
> diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
> index 8d28fff..395ebd3 100644
> --- a/net/netfilter/x_tables.c
> +++ b/net/netfilter/x_tables.c
> @@ -1199,7 +1199,8 @@ struct xt_table_info *xt_replace_table(struct xt_table *table,
>                         ab = audit_log_start(current->audit_context, GFP_KERNEL,
>                                              AUDIT_NETFILTER_CFG);
>                         if (ab) {
> -                               audit_log_format(ab, "family=%u table=%s entries=%u",
> +                               audit_log_format(ab, "op=%s family=%u table=%s entries=%u",
> +                                                private->number ? "replace" : "register",
>                                                  table->af, table->name,
>                                                  private->number);
>                                 audit_log_end(ab);
> @@ -1209,7 +1210,7 @@ struct xt_table_info *xt_replace_table(struct xt_table *table,
>                                              AUDIT_NETFILTER_CFGSOLO);
>                         if (ab) {
>                                 audit_log_task(ab);
> -                               audit_log_format(ab, " family=%u table=%s entries=%u",
> +                               audit_log_format(ab, " op=replace family=%u table=%s entries=%u",
>                                                  table->af, table->name,
>                                                  private->number);
>                                 audit_log_end(ab);
> --
> 1.7.1

-- 
paul moore
www.paul-moore.com
