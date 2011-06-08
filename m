From: Steve Grubb <sgrubb@redhat.com>
Subject: Re: [PATCH 3rd revision] Add SELinux context support to AUDIT target
Date: Wed, 8 Jun 2011 10:49:47 -0400
Message-ID: <201106081049.48026.sgrubb@redhat.com>
References: <4DEDEB99.4070601@netfilter.org> <4DEDFE43.5060402@googlemail.com>
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
Received: from mx1.redhat.com ([209.132.183.28]:31275 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703Ab1FHOut (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jun 2011 10:50:49 -0400
In-Reply-To: <4DEDFE43.5060402@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday, June 07, 2011 06:32:35 AM Mr Dash Four wrote:
> Add SELinux context support to AUDIT target - 3rd revision (style-type
> changes made *only* since 2nd revision of this patch). Typical (raw
> auditd) output after applying this patch would be:

<snip> 

> @@ -163,6 +170,15 @@ audit_tg(struct sk_buff *skb, const struct
> xt_action_param *par) break;
>  	}
> 
> +#ifdef CONFIG_NF_CONNTRACK_SECMARK
> +	if (skb->secmark) {
> +	  	if (!security_secid_to_secctx(skb->secmark, &secctx, &len)) {
> +			audit_log_format(ab, " obj=%s", secctx);
> +			security_release_secctx(secctx, len);
> +		}

else
	audit_log_format(ab, " osid=%u", skb->secmark);

_All_  audit code records the number on a failed conversion.

-Steve


> +	}
> +#endif
> +
>  	audit_log_end(ab);
> 
>  errout:
