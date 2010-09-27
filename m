From: Casey Schaufler <casey@schaufler-ca.com>
Subject: Re: [PATCH 4/6] security: secid_to_secctx returns len when data is
 NULL
Date: Mon, 27 Sep 2010 06:49:59 -0700
Message-ID: <4CA0A107.3020903@schaufler-ca.com>
References: <20100924204517.28355.42822.stgit@paris.rdu.redhat.com> <20100924204538.28355.32426.stgit@paris.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: linux-kernel@vger.kernel.org, selinux@tycho.nsa.gov,
	netfilter-devel@vger.kernel.org, jmorris@namei.org,
	sds@tycho.nsa.gov, jengelh@medozas.de, paul.moore@hp.com,
	linux-security-module@vger.kernel.org, netfilter@vger.kernel.org,
	mr.dash.four@googlemail.com
To: Eric Paris <eparis@redhat.com>
Return-path: <linux-security-module-owner@vger.kernel.org>
In-Reply-To: <20100924204538.28355.32426.stgit@paris.rdu.redhat.com>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

 On 9/24/2010 1:45 PM, Eric Paris wrote:
> With the (long ago) interface change to have the secid_to_secctx functions
> do the string allocation instead of having the caller do the allocation we
> lost the ability to query the security server for the length of the
> upcoming string.  The SECMARK code would like to allocate a netlink skb
> with enough length to hold the string but it is just too unclean to do the
> string allocation twice or to do the allocation the first time and hold
> onto the string and slen.  This patch adds the ability to call
> security_secid_to_secctx() with a NULL data pointer and it will just set
> the slen pointer.
>
> Signed-off-by: Eric Paris <eparis@redhat.com>

Acked-by: Casey Schaufler <casey@schaufler-ca.com>

For the Smack bit at least.


> ---
>
>  security/selinux/ss/services.c |   11 +++++++++--
>  security/smack/smack_lsm.c     |    3 ++-
>  2 files changed, 11 insertions(+), 3 deletions(-)
>
> diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
> index 73508af..1d4955a 100644
> --- a/security/selinux/ss/services.c
> +++ b/security/selinux/ss/services.c
> @@ -998,7 +998,8 @@ static int context_struct_to_string(struct context *context, char **scontext, u3
>  {
>  	char *scontextp;
>  
> -	*scontext = NULL;
> +	if (scontext)
> +		*scontext = NULL;
>  	*scontext_len = 0;
>  
>  	if (context->len) {
> @@ -1015,6 +1016,9 @@ static int context_struct_to_string(struct context *context, char **scontext, u3
>  	*scontext_len += strlen(sym_name(&policydb, SYM_TYPES, context->type - 1)) + 1;
>  	*scontext_len += mls_compute_context_len(context);
>  
> +	if (!scontext)
> +		return 0;
> +
>  	/* Allocate space for the context; caller must free this space. */
>  	scontextp = kmalloc(*scontext_len, GFP_ATOMIC);
>  	if (!scontextp)
> @@ -1054,7 +1058,8 @@ static int security_sid_to_context_core(u32 sid, char **scontext,
>  	struct context *context;
>  	int rc = 0;
>  
> -	*scontext = NULL;
> +	if (scontext)
> +		*scontext = NULL;
>  	*scontext_len  = 0;
>  
>  	if (!ss_initialized) {
> @@ -1062,6 +1067,8 @@ static int security_sid_to_context_core(u32 sid, char **scontext,
>  			char *scontextp;
>  
>  			*scontext_len = strlen(initial_sid_to_string[sid]) + 1;
> +			if (!scontext)
> +				goto out;
>  			scontextp = kmalloc(*scontext_len, GFP_ATOMIC);
>  			if (!scontextp) {
>  				rc = -ENOMEM;
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index c448d57..b95d7b1 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -3005,7 +3005,8 @@ static int smack_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
>  {
>  	char *sp = smack_from_secid(secid);
>  
> -	*secdata = sp;
> +	if (secdata)
> +		*secdata = sp;
>  	*seclen = strlen(sp);
>  	return 0;
>  }
>
>

