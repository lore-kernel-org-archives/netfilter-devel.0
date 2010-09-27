From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 5/6] conntrack: export lsm context rather than internal
 secid	via netlink
Date: Mon, 27 Sep 2010 13:01:50 +0200
Message-ID: <4CA0799E.4010200@netfilter.org>
References: <20100924204517.28355.42822.stgit@paris.rdu.redhat.com> <20100924204545.28355.92767.stgit@paris.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
	netfilter-devel@vger.kernel.org, jmorris@namei.org,
	sds@tycho.nsa.gov, jengelh@medozas.de, paul.moore@hp.com,
	casey@schaufler-ca.com, linux-security-module@vger.kernel.org,
	netfilter@vger.kernel.org, mr.dash.four@googlemail.com
To: Eric Paris <eparis@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37677 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755632Ab0I0LBD (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 27 Sep 2010 07:01:03 -0400
In-Reply-To: <20100924204545.28355.92767.stgit@paris.rdu.redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 24/09/10 22:45, Eric Paris wrote:
> @@ -172,4 +173,11 @@ enum ctattr_help {
>   };
>   #define CTA_HELP_MAX (__CTA_HELP_MAX - 1)
>
> +enum ctattr_secctx {
> +	CTA_SECCTX_UNSPEC,
> +	CTA_SECCTX_NAME,
> +	__CTA_SECCTX_MAX
> +};
> +#define CTA_SECCTX_MAX (__CTA_SECCTX_MAX - 1)

I guess that you have included this nest for consistency with CTA_HELP. 
My question: do you think that we'll include more attributes in that 
nest in the future? Otherwise, I would remove that nest and put 
CTA_SECCTX_NAME in the first level, since the nest would increase the 
message size.
