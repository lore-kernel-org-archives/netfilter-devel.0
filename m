From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/6] secmark: make secmark object handling generic
Date: Sat, 25 Sep 2010 10:39:40 +0200
Message-ID: <4C9DB54C.4010100@netfilter.org>
References: <20100924204517.28355.42822.stgit@paris.rdu.redhat.com> <20100924204524.28355.87206.stgit@paris.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
	netfilter-devel@vger.kernel.org, jmorris@namei.org,
	sds@tycho.nsa.gov, jengelh@medozas.de, paul.moore@hp.com,
	casey@schaufler-ca.com, linux-security-module@vger.kernel.org,
	netfilter@vger.kernel.org, mr.dash.four@googlemail.com
To: Eric Paris <eparis@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54961 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752159Ab0IYIjq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 25 Sep 2010 04:39:46 -0400
In-Reply-To: <20100924204524.28355.87206.stgit@paris.rdu.redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 24/09/10 22:45, Eric Paris wrote:
> Right now secmark has lots of direct selinux calls.  Use all LSM calls and
> remove all SELinux specific knowledge.  The only SELinux specific knowledge
> we leave is the mode.  The only point is to make sure that other LSMs at
> least test this generic code before they assume it works.  (They may also
> have to make changes if they do not represent labels as strings)
> 
> Signed-off-by: Eric Paris <eparis@redhat.com>
> ---
> 
>  include/linux/netfilter/xt_SECMARK.h |   14 ++------
>  include/linux/security.h             |   25 +++++++++++++
>  include/linux/selinux.h              |   63 ----------------------------------
>  net/netfilter/xt_CT.c                |    1 -
>  net/netfilter/xt_SECMARK.c           |   57 +++++++++++++++----------------
>  security/capability.c                |   17 +++++++++
>  security/security.c                  |   18 ++++++++++
>  security/selinux/exports.c           |   49 --------------------------
>  security/selinux/hooks.c             |   24 +++++++++++++
>  security/selinux/include/security.h  |    1 +
>  10 files changed, 116 insertions(+), 153 deletions(-)
> 
> diff --git a/include/linux/netfilter/xt_SECMARK.h b/include/linux/netfilter/xt_SECMARK.h
> index 6fcd344..b8d55c4 100644
> --- a/include/linux/netfilter/xt_SECMARK.h
> +++ b/include/linux/netfilter/xt_SECMARK.h
> @@ -10,19 +10,13 @@
>   * 'mode' refers to the specific security subsystem which the
>   * packets are being marked for.
>   */
> -#define SECMARK_MODE_SEL	0x01		/* SELinux */
> -#define SECMARK_SELCTX_MAX	256
> -
> -struct xt_secmark_target_selinux_info {
> -	__u32 selsid;
> -	char selctx[SECMARK_SELCTX_MAX];
> -};
> +#define SECMARK_MODE_SELINUX	0x01		/* SELinux */
> +#define SECMARK_SECCTX_MAX	256

The SECMARK_MODE_SEL is exposed to user-space, even if we have a copy of
it in the internal iptables tree, I'm not sure if it's a good policy to
change it.
