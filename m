From: Steve Grubb <sgrubb@redhat.com>
Subject: Re: [PATCH 2nd revision] Add SELinux context support to AUDIT target
Date: Mon, 6 Jun 2011 08:14:12 -0400
Message-ID: <201106060814.12524.sgrubb@redhat.com>
References: <4DDE9194.4030303@netfilter.org> <4DDE87F5.9050606@googlemail.com> <4DEA4B44.8050809@googlemail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Mr Dash Four <mr.dash.four@googlemail.com>,
	netfilter-devel@vger.kernel.org, Thomas Graf <tgraf@redhat.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Eric Paris <eparis@parisplace.org>,
	Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: linux-audit@redhat.com
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:6125 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754624Ab1FFMOc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jun 2011 08:14:32 -0400
In-Reply-To: <4DEA4B44.8050809@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Saturday, June 04, 2011 11:12:04 AM Mr Dash Four wrote:
> Add SELinux context support to AUDIT target (2nd revision). Typical (raw
> auditd) output after applying this patch would be:
> 
> type=NETFILTER_PKT msg=audit(1305852240.082:31012): action=0 hook=1 len=52
> inif=? outif=eth0 saddr=10.1.1.7 daddr=10.1.2.1 ipid=16312 proto=6
> sport=56150 dport=22 obj=system_u:object_r:ssh_packet_t:s0
> type=NETFILTER_PKT msg=audit(1306772064.079:56): action=0 hook=3 len=48
> inif=eth0 outif=? smac=00:05:5d:7c:27:0b dmac=00:02:b3:0a:7f:81
> macproto=0x0800 saddr=10.1.2.1 daddr=10.1.1.7 ipid=462 proto=6 sport=3561
> dport=22 obj=system_u:object_r:ssh_packet_t:s0
> 
> 
> Signed-off-by: Mr Dash Four <mr.dash.four@googlemail.com>
> ---
>  net/netfilter/xt_AUDIT.c |   15 +++++++++++++++
>  1 files changed, 15 insertions(+), 0 deletions(-)
> 
> diff --git a/net/netfilter/xt_AUDIT.c b/net/netfilter/xt_AUDIT.c
> index 363a99e..616cadc 100644
> --- a/net/netfilter/xt_AUDIT.c
> +++ b/net/netfilter/xt_AUDIT.c
> @@ -20,6 +20,9 @@
>  #include <linux/netfilter/x_tables.h>
>  #include <linux/netfilter/xt_AUDIT.h>
>  #include <linux/netfilter_bridge/ebtables.h>
> +#ifdef CONFIG_NF_CONNTRACK_SECMARK
> +#include <linux/security.h>
> +#endif
>  #include <net/ipv6.h>
>  #include <net/ip.h>
> 
> @@ -122,6 +125,10 @@ audit_tg(struct sk_buff *skb, const struct
> xt_action_param *par) {
>  	const struct xt_audit_info *info = par->targinfo;
>  	struct audit_buffer *ab;
> +#ifdef CONFIG_NF_CONNTRACK_SECMARK
> +	u32 len;
> +	char *secctx;
> +#endif
> 
>  	ab = audit_log_start(NULL, GFP_ATOMIC, AUDIT_NETFILTER_PKT);
>  	if (ab == NULL)
> @@ -163,6 +170,14 @@ audit_tg(struct sk_buff *skb, const struct
> xt_action_param *par) break;
>  	}
> 
> +#ifdef CONFIG_NF_CONNTRACK_SECMARK
> +	if (skb->secmark)
> +	  	if (!security_secid_to_secctx(skb->secmark, &secctx, &len)) {
> +			audit_log_format(ab, " obj=%s", secctx);
> +			security_release_secctx(secctx, len);
> +		}

Normally there would be an else here to do something like
audit_log_format(ab, " osid=%u", skb->secmark);
so that its recorded numerically if the context could not be looked up.

> +#endif
> +
>  	audit_log_end(ab);
> 
>  errout:
