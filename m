Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1AC17999
	for <netfilter-devel@vger.kernel.org>; Thu, 19 Sep 2024 04:12:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726719158; cv=none; b=M4ixZddodKxxy/7e78EeA0d/WdBrllb9Si/UJUOSYf4Y7olZtJibcxiMUGoiFj9bF2bYUMMKFTNMBs+MHdEMjlNvI6ZTIdnvNE5dO+hqm8a1fr5f3T+TW2rQZXYQM56OnnKQ9HGFp7Uid5wf2r7Kcf9fFsfljgBBED34NeWcC9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726719158; c=relaxed/simple;
	bh=y3Rdrk0jdWIxNXu58KEUeExpxKZ6+j8wojsMC8QGQ54=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B57Z9CJB1bX6N88oXitzfarThZrBnQvgd0A+sWLYiUYFRxM0dZ4b2v4L3NWwNI5vAbKsxV6ddfK5n2cxTKRLgjnpilrYfa3mZtB/CCyMbnTf2d843fCsmO+8ttWlWKMsLuQowl1CYZNOZKoFnUqBN1FxB8cJvP5CVhVBFCAqKcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=3hNN8V6q; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="3hNN8V6q"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-718e6299191so193458b3a.2
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Sep 2024 21:12:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1726719154; x=1727323954; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vhj7eoldLmr9i8H5W8eBvJiZgSzDnadTkZbFdImGvzI=;
        b=3hNN8V6qj8OYIIH1k8QZRQsAgsuf1N6zS7Y8pkdknBEKi3YzMfmRzQZz2W32GZbhh5
         rSkfRV3sY3mZjnBftNPQkYytkGXwRbs2nHfKel5HSCQ0jrlwxtdBcm/7uAA9oKMeEevL
         HrjATQVQyhTptpFCHUDtl9tlpQfoXEo43/1nJaS9cTRvBx/a1d6eBNp+z9GvGzDRA3nK
         xR6rqGxABy3q8veShUBf5qSv3396M0En8k/o5WwroYuU7ya70gXopWgDCme1a7JS1XzP
         BNt4YVnNIYQHq3EzTjYpOrlDA9VHEupC/h2sHZ/Mi6rtv4VxWdPXIVQM3N1bFlA+YH9C
         vOQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726719154; x=1727323954;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vhj7eoldLmr9i8H5W8eBvJiZgSzDnadTkZbFdImGvzI=;
        b=A2b4Vcq1PVWvOsZwXHMEchWk2TtBufzrZ3LIySFkQUuZI/5WeOT/wvM5l4KV49dYhI
         H6DO4RGxBDqUCWmHVCTFgDfuT6gb3bS86OCG9x+DLTU2PD79js/62u4o3jns50c6RT5A
         yfOak1OrEsZzk7ufYkTRcAJrJwMb7O1/jTptasy19tFtfH8m2Lk2LVPgOrDBi2PPWtyG
         anILzTP6mNGN2nG6ODlZz53XolnPtkr+yAisOcshu/jcN3e7JNy25HBziYgoPj9chq1o
         /UnK8YWhOMD7CDTg/54k5g7qh/QE5V7K1s0RemXiA8pHhE6DRNiTO86uE/RG3mKksSJA
         25Yw==
X-Forwarded-Encrypted: i=1; AJvYcCVW9tyfcclxlXGqvxPJoebupNtJ5XEEtjXrrDnWD1APViCmJmxOHb8TG8fClYI8rPHJMixqFcN6DxIcLeAweAg=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz7YxlcrpwhEwHJDhKQfEBlW9aRwi/TZX2az42I4W41jsX8sm7G
	FsKWmgJl8FISHqfK30fQcrS8a9YdZzhta5fStOKb4LueNDVyCxU2iNlaVWWNLAkB6dHHBiwAfmH
	EFejBOdch+tJmvIa66DvUO6Jgcz/dxf+r7G02
X-Google-Smtp-Source: AGHT+IHxU3A/T9VT99dIR7tZmPI93+XzT0X8J7t1Vs72YYCnvD6heOmknp5ptls6QmqHX+3EAyVo835TgVwj4JEn3z8=
X-Received: by 2002:a05:6a21:9786:b0:1cf:36f2:21cf with SMTP id
 adf61e73a8af0-1cf762385abmr37633240637.44.1726719153490; Wed, 18 Sep 2024
 21:12:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netfilter-devel@vger.kernel.org
List-Id: <netfilter-devel.vger.kernel.org>
List-Subscribe: <mailto:netfilter-devel+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netfilter-devel+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240917235202.32578-1-casey@schaufler-ca.com> <20240917235202.32578-2-casey@schaufler-ca.com>
In-Reply-To: <20240917235202.32578-2-casey@schaufler-ca.com>
From: Todd Kjos <tkjos@google.com>
Date: Thu, 19 Sep 2024 06:12:18 +0200
Message-ID: <CAHRSSEzJMTiZ0prsbEz6=ROSdf8hUo4FfJ0u0xrnK=Xp3vGWSg@mail.gmail.com>
Subject: Re: [PATCH 1/5] LSM: Replace context+len with lsm_context
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: paul@paul-moore.com, linux-security-module@vger.kernel.org, 
	jmorris@namei.org, serge@hallyn.com, keescook@chromium.org, 
	john.johansen@canonical.com, penguin-kernel@i-love.sakura.ne.jp, 
	stephen.smalley.work@gmail.com, linux-kernel@vger.kernel.org, 
	selinux@vger.kernel.org, mic@digikod.net, netdev@vger.kernel.org, 
	audit@vger.kernel.org, netfilter-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 18, 2024 at 1:52=E2=80=AFAM Casey Schaufler <casey@schaufler-ca=
.com> wrote:
>
> Replace the (secctx,seclen) pointer pair with a single
> lsm_context pointer to allow return of the LSM identifier
> along with the context and context length. This allows
> security_release_secctx() to know how to release the
> context. Callers have been modified to use or save the
> returned data from the new structure.
>
> security_secid_to_secctx() and security_lsmproc_to_secctx()
> will now return the length value on success instead of 0.
>
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> Cc: netdev@vger.kernel.org
> Cc: audit@vger.kernel.org
> Cc: netfilter-devel@vger.kernel.org
> Cc: Todd Kjos <tkjos@google.com>

Reviewed-by: Todd Kjos <tkjos@google.com>

> ---
>  drivers/android/binder.c                |  5 ++-
>  include/linux/lsm_hook_defs.h           |  5 ++-
>  include/linux/security.h                |  9 +++---
>  include/net/scm.h                       |  5 ++-
>  kernel/audit.c                          |  9 +++---
>  kernel/auditsc.c                        | 16 ++++------
>  net/ipv4/ip_sockglue.c                  |  4 +--
>  net/netfilter/nf_conntrack_netlink.c    |  8 ++---
>  net/netfilter/nf_conntrack_standalone.c |  4 +--
>  net/netfilter/nfnetlink_queue.c         | 27 +++++++---------
>  net/netlabel/netlabel_unlabeled.c       | 13 +++-----
>  net/netlabel/netlabel_user.c            |  3 +-
>  security/apparmor/include/secid.h       |  5 ++-
>  security/apparmor/secid.c               | 26 +++++++--------
>  security/security.c                     | 34 +++++++++-----------
>  security/selinux/hooks.c                | 23 +++++++++++---
>  security/smack/smack_lsm.c              | 42 +++++++++++++++----------
>  17 files changed, 118 insertions(+), 120 deletions(-)
>
> diff --git a/drivers/android/binder.c b/drivers/android/binder.c
> index b32416f8f9cd..59081edb3370 100644
> --- a/drivers/android/binder.c
> +++ b/drivers/android/binder.c
> @@ -3289,9 +3289,8 @@ static void binder_transaction(struct binder_proc *=
proc,
>                 size_t added_size;
>
>                 security_cred_getsecid(proc->cred, &secid);
> -               ret =3D security_secid_to_secctx(secid, &lsmctx.context,
> -                                              &lsmctx.len);
> -               if (ret) {
> +               ret =3D security_secid_to_secctx(secid, &lsmctx);
> +               if (ret < 0) {
>                         binder_txn_error("%d:%d failed to get security co=
ntext\n",
>                                 thread->pid, proc->pid);
>                         return_error =3D BR_FAILED_REPLY;
> diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.=
h
> index 418611f21831..95c7640919ba 100644
> --- a/include/linux/lsm_hook_defs.h
> +++ b/include/linux/lsm_hook_defs.h
> @@ -292,10 +292,9 @@ LSM_HOOK(int, -EINVAL, getprocattr, struct task_stru=
ct *p, const char *name,
>          char **value)
>  LSM_HOOK(int, -EINVAL, setprocattr, const char *name, void *value, size_=
t size)
>  LSM_HOOK(int, 0, ismaclabel, const char *name)
> -LSM_HOOK(int, -EOPNOTSUPP, secid_to_secctx, u32 secid, char **secdata,
> -        u32 *seclen)
> +LSM_HOOK(int, -EOPNOTSUPP, secid_to_secctx, u32 secid, struct lsm_contex=
t *cp)
>  LSM_HOOK(int, -EOPNOTSUPP, lsmprop_to_secctx, struct lsm_prop *prop,
> -        char **secdata, u32 *seclen)
> +        struct lsm_context *cp)
>  LSM_HOOK(int, 0, secctx_to_secid, const char *secdata, u32 seclen, u32 *=
secid)
>  LSM_HOOK(void, LSM_RET_VOID, release_secctx, struct lsm_context *cp)
>  LSM_HOOK(void, LSM_RET_VOID, inode_invalidate_secctx, struct inode *inod=
e)
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 432bd4763703..2604ea16cd6d 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -569,8 +569,8 @@ int security_getprocattr(struct task_struct *p, int l=
smid, const char *name,
>  int security_setprocattr(int lsmid, const char *name, void *value, size_=
t size);
>  int security_netlink_send(struct sock *sk, struct sk_buff *skb);
>  int security_ismaclabel(const char *name);
> -int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen);
> -int security_lsmprop_to_secctx(struct lsm_prop *prop, char **secdata, u3=
2 *seclen);
> +int security_secid_to_secctx(u32 secid, struct lsm_context *cp);
> +int security_lsmprop_to_secctx(struct lsm_prop *prop, struct lsm_context=
 *cp);
>  int security_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid=
);
>  void security_release_secctx(struct lsm_context *cp);
>  void security_inode_invalidate_secctx(struct inode *inode);
> @@ -1530,14 +1530,13 @@ static inline int security_ismaclabel(const char =
*name)
>         return 0;
>  }
>
> -static inline int security_secid_to_secctx(u32 secid, char **secdata,
> -                                          u32 *seclen)
> +static inline int security_secid_to_secctx(u32 secid, struct lsm_context=
 *cp)
>  {
>         return -EOPNOTSUPP;
>  }
>
>  static inline int security_lsmprop_to_secctx(struct lsm_prop *prop,
> -                                            char **secdata, u32 *seclen)
> +                                            struct lsm_context *cp)
>  {
>         return -EOPNOTSUPP;
>  }
> diff --git a/include/net/scm.h b/include/net/scm.h
> index f75449e1d876..22bb49589fde 100644
> --- a/include/net/scm.h
> +++ b/include/net/scm.h
> @@ -109,10 +109,9 @@ static inline void scm_passec(struct socket *sock, s=
truct msghdr *msg, struct sc
>         int err;
>
>         if (test_bit(SOCK_PASSSEC, &sock->flags)) {
> -               err =3D security_secid_to_secctx(scm->secid, &ctx.context=
,
> -                                              &ctx.len);
> +               err =3D security_secid_to_secctx(scm->secid, &ctx);
>
> -               if (!err) {
> +               if (err >=3D 0) {
>                         put_cmsg(msg, SOL_SOCKET, SCM_SECURITY, ctx.len,
>                                  ctx.context);
>                         security_release_secctx(&ctx);
> diff --git a/kernel/audit.c b/kernel/audit.c
> index 32a9864c648b..5ae0b26e5d92 100644
> --- a/kernel/audit.c
> +++ b/kernel/audit.c
> @@ -1473,9 +1473,8 @@ static int audit_receive_msg(struct sk_buff *skb, s=
truct nlmsghdr *nlh,
>         case AUDIT_SIGNAL_INFO:
>                 if (lsmprop_is_set(&audit_sig_lsm)) {
>                         err =3D security_lsmprop_to_secctx(&audit_sig_lsm=
,
> -                                                        &lsmctx.context,
> -                                                        &lsmctx.len);
> -                       if (err)
> +                                                        &lsmctx);
> +                       if (err < 0)
>                                 return err;
>                 }
>                 sig_data =3D kmalloc(struct_size(sig_data, ctx, lsmctx.le=
n),
> @@ -2188,8 +2187,8 @@ int audit_log_task_context(struct audit_buffer *ab)
>         if (!lsmprop_is_set(&prop))
>                 return 0;
>
> -       error =3D security_lsmprop_to_secctx(&prop, &ctx.context, &ctx.le=
n);
> -       if (error) {
> +       error =3D security_lsmprop_to_secctx(&prop, &ctx);
> +       if (error < 0) {
>                 if (error !=3D -EINVAL)
>                         goto error_path;
>                 return 0;
> diff --git a/kernel/auditsc.c b/kernel/auditsc.c
> index f2fed7a37e22..268117628a2c 100644
> --- a/kernel/auditsc.c
> +++ b/kernel/auditsc.c
> @@ -1109,7 +1109,7 @@ static int audit_log_pid_context(struct audit_conte=
xt *context, pid_t pid,
>                          from_kuid(&init_user_ns, auid),
>                          from_kuid(&init_user_ns, uid), sessionid);
>         if (lsmprop_is_set(prop)) {
> -               if (security_lsmprop_to_secctx(prop, &ctx.context, &ctx.l=
en)) {
> +               if (security_lsmprop_to_secctx(prop, &ctx) < 0) {
>                         audit_log_format(ab, " obj=3D(none)");
>                         rc =3D 1;
>                 } else {
> @@ -1370,7 +1370,6 @@ static void audit_log_time(struct audit_context *co=
ntext, struct audit_buffer **
>
>  static void show_special(struct audit_context *context, int *call_panic)
>  {
> -       struct lsm_context lsmcxt;
>         struct audit_buffer *ab;
>         int i;
>
> @@ -1393,16 +1392,14 @@ static void show_special(struct audit_context *co=
ntext, int *call_panic)
>                                  from_kgid(&init_user_ns, context->ipc.gi=
d),
>                                  context->ipc.mode);
>                 if (lsmprop_is_set(&context->ipc.oprop)) {
> -                       char *ctx =3D NULL;
> -                       u32 len;
> +                       struct lsm_context lsmctx;
>
>                         if (security_lsmprop_to_secctx(&context->ipc.opro=
p,
> -                                                      &ctx, &len)) {
> +                                                      &lsmctx) < 0) {
>                                 *call_panic =3D 1;
>                         } else {
> -                               audit_log_format(ab, " obj=3D%s", ctx);
> -                               lsmcontext_init(&lsmcxt, ctx, len, 0);
> -                               security_release_secctx(&lsmcxt);
> +                               audit_log_format(ab, " obj=3D%s", lsmctx.=
context);
> +                               security_release_secctx(&lsmctx);
>                         }
>                 }
>                 if (context->ipc.has_perm) {
> @@ -1563,8 +1560,7 @@ static void audit_log_name(struct audit_context *co=
ntext, struct audit_names *n,
>         if (lsmprop_is_set(&n->oprop)) {
>                 struct lsm_context ctx;
>
> -               if (security_lsmprop_to_secctx(&n->oprop, &ctx.context,
> -                                              &ctx.len)) {
> +               if (security_lsmprop_to_secctx(&n->oprop, &ctx) < 0) {
>                         if (call_panic)
>                                 *call_panic =3D 2;
>                 } else {
> diff --git a/net/ipv4/ip_sockglue.c b/net/ipv4/ip_sockglue.c
> index a8180dcc2a32..dadbf619b20f 100644
> --- a/net/ipv4/ip_sockglue.c
> +++ b/net/ipv4/ip_sockglue.c
> @@ -136,8 +136,8 @@ static void ip_cmsg_recv_security(struct msghdr *msg,=
 struct sk_buff *skb)
>         if (err)
>                 return;
>
> -       err =3D security_secid_to_secctx(secid, &ctx.context, &ctx.len);
> -       if (err)
> +       err =3D security_secid_to_secctx(secid, &ctx);
> +       if (err < 0)
>                 return;
>
>         put_cmsg(msg, SOL_IP, SCM_SECURITY, ctx.len, ctx.context);
> diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conn=
track_netlink.c
> index e02e088b8794..5a93804e5cdb 100644
> --- a/net/netfilter/nf_conntrack_netlink.c
> +++ b/net/netfilter/nf_conntrack_netlink.c
> @@ -360,8 +360,8 @@ static int ctnetlink_dump_secctx(struct sk_buff *skb,=
 const struct nf_conn *ct)
>         struct lsm_context ctx;
>         int ret;
>
> -       ret =3D security_secid_to_secctx(ct->secmark, &ctx.context, &ctx.=
len);
> -       if (ret)
> +       ret =3D security_secid_to_secctx(ct->secmark, &ctx);
> +       if (ret < 0)
>                 return 0;
>
>         ret =3D -1;
> @@ -669,8 +669,8 @@ static inline int ctnetlink_secctx_size(const struct =
nf_conn *ct)
>  #ifdef CONFIG_NF_CONNTRACK_SECMARK
>         int len, ret;
>
> -       ret =3D security_secid_to_secctx(ct->secmark, NULL, &len);
> -       if (ret)
> +       ret =3D security_secid_to_secctx(ct->secmark, NULL);
> +       if (ret < 0)
>                 return 0;
>
>         return nla_total_size(0) /* CTA_SECCTX */
> diff --git a/net/netfilter/nf_conntrack_standalone.c b/net/netfilter/nf_c=
onntrack_standalone.c
> index 5f7fd23b7afe..502cf10aab41 100644
> --- a/net/netfilter/nf_conntrack_standalone.c
> +++ b/net/netfilter/nf_conntrack_standalone.c
> @@ -175,8 +175,8 @@ static void ct_show_secctx(struct seq_file *s, const =
struct nf_conn *ct)
>         struct lsm_context ctx;
>         int ret;
>
> -       ret =3D security_secid_to_secctx(ct->secmark, &ctx.context, &ctx.=
len);
> -       if (ret)
> +       ret =3D security_secid_to_secctx(ct->secmark, &ctx);
> +       if (ret < 0)
>                 return;
>
>         seq_printf(s, "secctx=3D%s ", ctx.context);
> diff --git a/net/netfilter/nfnetlink_queue.c b/net/netfilter/nfnetlink_qu=
eue.c
> index aaf54900de3c..e43767c35930 100644
> --- a/net/netfilter/nfnetlink_queue.c
> +++ b/net/netfilter/nfnetlink_queue.c
> @@ -470,18 +470,18 @@ static int nfqnl_put_sk_classid(struct sk_buff *skb=
, struct sock *sk)
>         return 0;
>  }
>
> -static u32 nfqnl_get_sk_secctx(struct sk_buff *skb, char **secdata)
> +static u32 nfqnl_get_sk_secctx(struct sk_buff *skb, struct lsm_context *=
ctx)
>  {
>         u32 seclen =3D 0;
>  #if IS_ENABLED(CONFIG_NETWORK_SECMARK)
> +
>         if (!skb || !sk_fullsock(skb->sk))
>                 return 0;
>
>         read_lock_bh(&skb->sk->sk_callback_lock);
>
>         if (skb->secmark)
> -               security_secid_to_secctx(skb->secmark, secdata, &seclen);
> -
> +               seclen =3D security_secid_to_secctx(skb->secmark, ctx);
>         read_unlock_bh(&skb->sk->sk_callback_lock);
>  #endif
>         return seclen;
> @@ -559,8 +559,7 @@ nfqnl_build_packet_message(struct net *net, struct nf=
qnl_instance *queue,
>         enum ip_conntrack_info ctinfo =3D 0;
>         const struct nfnl_ct_hook *nfnl_ct;
>         bool csum_verify;
> -       struct lsm_context scaff; /* scaffolding */
> -       char *secdata =3D NULL;
> +       struct lsm_context ctx;
>         u32 seclen =3D 0;
>         ktime_t tstamp;
>
> @@ -635,8 +634,8 @@ nfqnl_build_packet_message(struct net *net, struct nf=
qnl_instance *queue,
>         }
>
>         if ((queue->flags & NFQA_CFG_F_SECCTX) && entskb->sk) {
> -               seclen =3D nfqnl_get_sk_secctx(entskb, &secdata);
> -               if (seclen)
> +               seclen =3D nfqnl_get_sk_secctx(entskb, &ctx);
> +               if (seclen >=3D 0)
>                         size +=3D nla_total_size(seclen);
>         }
>
> @@ -775,7 +774,7 @@ nfqnl_build_packet_message(struct net *net, struct nf=
qnl_instance *queue,
>         if (nfqnl_put_sk_classid(skb, entskb->sk) < 0)
>                 goto nla_put_failure;
>
> -       if (seclen && nla_put(skb, NFQA_SECCTX, seclen, secdata))
> +       if (seclen && nla_put(skb, NFQA_SECCTX, ctx.len, ctx.context))
>                 goto nla_put_failure;
>
>         if (ct && nfnl_ct->build(skb, ct, ctinfo, NFQA_CT, NFQA_CT_INFO) =
< 0)
> @@ -803,10 +802,8 @@ nfqnl_build_packet_message(struct net *net, struct n=
fqnl_instance *queue,
>         }
>
>         nlh->nlmsg_len =3D skb->len;
> -       if (seclen) {
> -               lsmcontext_init(&scaff, secdata, seclen, 0);
> -               security_release_secctx(&scaff);
> -       }
> +       if (seclen >=3D 0)
> +               security_release_secctx(&ctx);
>         return skb;
>
>  nla_put_failure:
> @@ -814,10 +811,8 @@ nfqnl_build_packet_message(struct net *net, struct n=
fqnl_instance *queue,
>         kfree_skb(skb);
>         net_err_ratelimited("nf_queue: error creating packet message\n");
>  nlmsg_failure:
> -       if (seclen) {
> -               lsmcontext_init(&scaff, secdata, seclen, 0);
> -               security_release_secctx(&scaff);
> -       }
> +       if (seclen >=3D 0)
> +               security_release_secctx(&ctx);
>         return NULL;
>  }
>
> diff --git a/net/netlabel/netlabel_unlabeled.c b/net/netlabel/netlabel_un=
labeled.c
> index 8303bbcfc543..dfda9ea61971 100644
> --- a/net/netlabel/netlabel_unlabeled.c
> +++ b/net/netlabel/netlabel_unlabeled.c
> @@ -437,8 +437,7 @@ int netlbl_unlhsh_add(struct net *net,
>  unlhsh_add_return:
>         rcu_read_unlock();
>         if (audit_buf !=3D NULL) {
> -               if (security_secid_to_secctx(secid, &ctx.context,
> -                                            &ctx.len) =3D=3D 0) {
> +               if (security_secid_to_secctx(secid, &ctx) >=3D 0) {
>                         audit_log_format(audit_buf, " sec_obj=3D%s", ctx.=
context);
>                         security_release_secctx(&ctx);
>                 }
> @@ -491,8 +490,7 @@ static int netlbl_unlhsh_remove_addr4(struct net *net=
,
>                                           addr->s_addr, mask->s_addr);
>                 dev_put(dev);
>                 if (entry !=3D NULL &&
> -                   security_secid_to_secctx(entry->secid, &ctx.context,
> -                                            &ctx.len) =3D=3D 0) {
> +                   security_secid_to_secctx(entry->secid, &ctx) >=3D 0) =
{
>                         audit_log_format(audit_buf, " sec_obj=3D%s", ctx.=
context);
>                         security_release_secctx(&ctx);
>                 }
> @@ -550,8 +548,7 @@ static int netlbl_unlhsh_remove_addr6(struct net *net=
,
>                                           addr, mask);
>                 dev_put(dev);
>                 if (entry !=3D NULL &&
> -                   security_secid_to_secctx(entry->secid, &ctx.context,
> -                                            &ctx.len) =3D=3D 0) {
> +                   security_secid_to_secctx(entry->secid, &ctx) >=3D 0) =
{
>                         audit_log_format(audit_buf, " sec_obj=3D%s", ctx.=
context);
>                         security_release_secctx(&ctx);
>                 }
> @@ -1122,8 +1119,8 @@ static int netlbl_unlabel_staticlist_gen(u32 cmd,
>                 secid =3D addr6->secid;
>         }
>
> -       ret_val =3D security_secid_to_secctx(secid, &ctx.context, &ctx.le=
n);
> -       if (ret_val !=3D 0)
> +       ret_val =3D security_secid_to_secctx(secid, &ctx);
> +       if (ret_val < 0)
>                 goto list_cb_failure;
>         ret_val =3D nla_put(cb_arg->skb,
>                           NLBL_UNLABEL_A_SECCTX,
> diff --git a/net/netlabel/netlabel_user.c b/net/netlabel/netlabel_user.c
> index f5e7a9919df1..0d04d23aafe7 100644
> --- a/net/netlabel/netlabel_user.c
> +++ b/net/netlabel/netlabel_user.c
> @@ -98,8 +98,7 @@ struct audit_buffer *netlbl_audit_start_common(int type=
,
>                          audit_info->sessionid);
>
>         if (lsmprop_is_set(&audit_info->prop) &&
> -           security_lsmprop_to_secctx(&audit_info->prop, &ctx.context,
> -                                      &ctx.len) =3D=3D 0) {
> +           security_lsmprop_to_secctx(&audit_info->prop, &ctx) > 0) {
>                 audit_log_format(audit_buf, " subj=3D%s", ctx.context);
>                 security_release_secctx(&ctx);
>         }
> diff --git a/security/apparmor/include/secid.h b/security/apparmor/includ=
e/secid.h
> index 8b92f90b6921..550a8d3ed527 100644
> --- a/security/apparmor/include/secid.h
> +++ b/security/apparmor/include/secid.h
> @@ -25,9 +25,8 @@ struct aa_label;
>  extern int apparmor_display_secid_mode;
>
>  struct aa_label *aa_secid_to_label(u32 secid);
> -int apparmor_secid_to_secctx(u32 secid, char **secdata, u32 *seclen);
> -int apparmor_lsmprop_to_secctx(struct lsm_prop *prop, char **secdata,
> -                              u32 *seclen);
> +int apparmor_secid_to_secctx(u32 secid, struct lsm_context *cp);
> +int apparmor_lsmprop_to_secctx(struct lsm_prop *prop, struct lsm_context=
 *cp);
>  int apparmor_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid=
);
>  void apparmor_release_secctx(struct lsm_context *cp);
>
> diff --git a/security/apparmor/secid.c b/security/apparmor/secid.c
> index 8d9ced8cdffd..5d92fc3ab8b4 100644
> --- a/security/apparmor/secid.c
> +++ b/security/apparmor/secid.c
> @@ -61,23 +61,21 @@ struct aa_label *aa_secid_to_label(u32 secid)
>         return xa_load(&aa_secids, secid);
>  }
>
> -static int apparmor_label_to_secctx(struct aa_label *label, char **secda=
ta,
> -                                   u32 *seclen)
> +static int apparmor_label_to_secctx(struct aa_label *label,
> +                                   struct lsm_context *cp)
>  {
>         /* TODO: cache secctx and ref count so we don't have to recreate =
*/
>         int flags =3D FLAG_VIEW_SUBNS | FLAG_HIDDEN_UNCONFINED | FLAG_ABS=
_ROOT;
>         int len;
>
> -       AA_BUG(!seclen);
> -
>         if (!label)
>                 return -EINVAL;
>
>         if (apparmor_display_secid_mode)
>                 flags |=3D FLAG_SHOW_MODE;
>
> -       if (secdata)
> -               len =3D aa_label_asxprint(secdata, root_ns, label,
> +       if (cp)
> +               len =3D aa_label_asxprint(&cp->context, root_ns, label,
>                                         flags, GFP_ATOMIC);
>         else
>                 len =3D aa_label_snxprint(NULL, 0, root_ns, label, flags)=
;
> @@ -85,26 +83,28 @@ static int apparmor_label_to_secctx(struct aa_label *=
label, char **secdata,
>         if (len < 0)
>                 return -ENOMEM;
>
> -       *seclen =3D len;
> +       if (cp) {
> +               cp->len =3D len;
> +               cp->id =3D LSM_ID_APPARMOR;
> +       }
>
> -       return 0;
> +       return len;
>  }
>
> -int apparmor_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
> +int apparmor_secid_to_secctx(u32 secid, struct lsm_context *cp)
>  {
>         struct aa_label *label =3D aa_secid_to_label(secid);
>
> -       return apparmor_label_to_secctx(label, secdata, seclen);
> +       return apparmor_label_to_secctx(label, cp);
>  }
>
> -int apparmor_lsmprop_to_secctx(struct lsm_prop *prop, char **secdata,
> -                              u32 *seclen)
> +int apparmor_lsmprop_to_secctx(struct lsm_prop *prop, struct lsm_context=
 *cp)
>  {
>         struct aa_label *label;
>
>         label =3D prop->apparmor.label;
>
> -       return apparmor_label_to_secctx(label, secdata, seclen);
> +       return apparmor_label_to_secctx(label, cp);
>  }
>
>  int apparmor_secctx_to_secid(const char *secdata, u32 seclen, u32 *secid=
)
> diff --git a/security/security.c b/security/security.c
> index 4f73cc52ad5d..58f5fe1eb6c0 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -4190,40 +4190,36 @@ EXPORT_SYMBOL(security_ismaclabel);
>  /**
>   * security_secid_to_secctx() - Convert a secid to a secctx
>   * @secid: secid
> - * @secdata: secctx
> - * @seclen: secctx length
> + * @cp: the LSM context
>   *
> - * Convert secid to security context.  If @secdata is NULL the length of=
 the
> - * result will be returned in @seclen, but no @secdata will be returned.=
  This
> + * Convert secid to security context.  If @cp is NULL the length of the
> + * result will be returned, but no data will be returned.  This
>   * does mean that the length could change between calls to check the len=
gth and
> - * the next call which actually allocates and returns the @secdata.
> + * the next call which actually allocates and returns the data.
>   *
> - * Return: Return 0 on success, error on failure.
> + * Return: Return length of data on success, error on failure.
>   */
> -int security_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
> +int security_secid_to_secctx(u32 secid, struct lsm_context *cp)
>  {
> -       return call_int_hook(secid_to_secctx, secid, secdata, seclen);
> +       return call_int_hook(secid_to_secctx, secid, cp);
>  }
>  EXPORT_SYMBOL(security_secid_to_secctx);
>
>  /**
>   * security_lsmprop_to_secctx() - Convert a lsm_prop to a secctx
>   * @prop: lsm specific information
> - * @secdata: secctx
> - * @seclen: secctx length
> + * @cp: the LSM context
>   *
> - * Convert a @prop entry to security context.  If @secdata is NULL the
> - * length of the result will be returned in @seclen, but no @secdata
> - * will be returned.  This does mean that the length could change betwee=
n
> - * calls to check the length and the next call which actually allocates
> - * and returns the @secdata.
> + * Convert a @prop entry to security context.  If @cp is NULL the
> + * length of the result will be returned. This does mean that the
> + * length could change between calls to check the length and the
> + * next call which actually allocates and returns the @cp.
>   *
> - * Return: Return 0 on success, error on failure.
> + * Return: Return length of data on success, error on failure.
>   */
> -int security_lsmprop_to_secctx(struct lsm_prop *prop, char **secdata,
> -                              u32 *seclen)
> +int security_lsmprop_to_secctx(struct lsm_prop *prop, struct lsm_context=
 *cp)
>  {
> -       return call_int_hook(lsmprop_to_secctx, prop, secdata, seclen);
> +       return call_int_hook(lsmprop_to_secctx, prop, cp);
>  }
>  EXPORT_SYMBOL(security_lsmprop_to_secctx);
>
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index 2b027c08168f..01e44a14d3d4 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -6616,15 +6616,28 @@ static int selinux_ismaclabel(const char *name)
>         return (strcmp(name, XATTR_SELINUX_SUFFIX) =3D=3D 0);
>  }
>
> -static int selinux_secid_to_secctx(u32 secid, char **secdata, u32 *secle=
n)
> +static int selinux_secid_to_secctx(u32 secid, struct lsm_context *cp)
>  {
> -       return security_sid_to_context(secid, secdata, seclen);
> +       u32 seclen;
> +       u32 ret;
> +
> +       if (cp) {
> +               cp->id =3D LSM_ID_SELINUX;
> +               ret =3D security_sid_to_context(secid, &cp->context, &cp-=
>len);
> +               if (ret < 0)
> +                       return ret;
> +               return cp->len;
> +       }
> +       ret =3D security_sid_to_context(secid, NULL, &seclen);
> +       if (ret < 0)
> +               return ret;
> +       return seclen;
>  }
>
> -static int selinux_lsmprop_to_secctx(struct lsm_prop *prop, char **secda=
ta,
> -                                    u32 *seclen)
> +static int selinux_lsmprop_to_secctx(struct lsm_prop *prop,
> +                                    struct lsm_context *cp)
>  {
> -       return selinux_secid_to_secctx(prop->selinux.secid, secdata, secl=
en);
> +       return selinux_secid_to_secctx(prop->selinux.secid, cp);
>  }
>
>  static int selinux_secctx_to_secid(const char *secdata, u32 seclen, u32 =
*secid)
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index e5b47342c274..e85efe894ac3 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c
> @@ -4836,22 +4836,35 @@ static int smack_ismaclabel(const char *name)
>         return (strcmp(name, XATTR_SMACK_SUFFIX) =3D=3D 0);
>  }
>
> +/**
> + * smack_to_secctx - fill a lsm_context
> + * @skp: Smack label
> + * @cp: destination
> + *
> + * Fill the passed @cp and return the length of the string
> + */
> +static int smack_to_secctx(struct smack_known *skp, struct lsm_context *=
cp)
> +{
> +       int len =3D strlen(skp->smk_known);
> +
> +       if (cp) {
> +               cp->context =3D skp->smk_known;
> +               cp->len =3D len;
> +               cp->id =3D LSM_ID_SMACK;
> +       }
> +       return len;
> +}
> +
>  /**
>   * smack_secid_to_secctx - return the smack label for a secid
>   * @secid: incoming integer
> - * @secdata: destination
> - * @seclen: how long it is
> + * @cp: destination
>   *
>   * Exists for networking code.
>   */
> -static int smack_secid_to_secctx(u32 secid, char **secdata, u32 *seclen)
> +static int smack_secid_to_secctx(u32 secid, struct lsm_context *cp)
>  {
> -       struct smack_known *skp =3D smack_from_secid(secid);
> -
> -       if (secdata)
> -               *secdata =3D skp->smk_known;
> -       *seclen =3D strlen(skp->smk_known);
> -       return 0;
> +       return smack_to_secctx(smack_from_secid(secid), cp);
>  }
>
>  /**
> @@ -4862,15 +4875,10 @@ static int smack_secid_to_secctx(u32 secid, char =
**secdata, u32 *seclen)
>   *
>   * Exists for audit code.
>   */
> -static int smack_lsmprop_to_secctx(struct lsm_prop *prop, char **secdata=
,
> -                                  u32 *seclen)
> +static int smack_lsmprop_to_secctx(struct lsm_prop *prop,
> +                                  struct lsm_context *cp)
>  {
> -       struct smack_known *skp =3D prop->smack.skp;
> -
> -       if (secdata)
> -               *secdata =3D skp->smk_known;
> -       *seclen =3D strlen(skp->smk_known);
> -       return 0;
> +       return smack_to_secctx(prop->smack.skp, cp);
>  }
>
>  /**
> --
> 2.46.0
>
