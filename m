From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Help parsing options with iptables extension
Date: Mon, 17 Sep 2012 05:07:44 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1209170457460.13524@nerf07.vanv.qr>
References: <CAGuaRCuz+8_CPsXpouoDOdkg-6ezjuZrgc=UVqe-JqYwz2U2QQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Aft nix <aftnix@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:34758 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403Ab2IQDHs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Sep 2012 23:07:48 -0400
In-Reply-To: <CAGuaRCuz+8_CPsXpouoDOdkg-6ezjuZrgc=UVqe-JqYwz2U2QQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2012-09-15 12:58, Aft nix wrote:
>
>struct enc_info {
>		__u8 key[XT_OBSF_MAX_KEY_LEN];
>		__u8 kl;
>	};
>
>struct pad_info {
>		__u8 s;
>		__u8 e;
>	};

Meaningful member names and a description =C3=A0 la kerneldoc would
help here understanding what these are actually for..
(like, which is to be filled with XT_OBSF_ values)

>
>struct xt_OBSF_tginfo {
>	__u8 flags;
>	struct enc_info *e_info;
>	struct xt_obsf_priv *priv;
>};

You must not use pointers in general. When retrieving the ruleset
from the kernel, they will not have any sensible value. While that
is ok for kernel-private fields like "priv" here, it's not for
e_info and p_info which you will likely want to dump in userspace.

>struct xt_OBSF_tginfo_v1 {
>	__u8 flags;
>	struct enc_info *e_info;
>	struct pad_info *p_info;
>	struct xt_obsf_priv *priv;
>};
>
>What i'm trying to do is following:
>
>struct xt_OBSF_info * info;
>
>--key "key" will go into              info->e_info->key
>--keylen "len" will go into          info->e_info->kl
>--enc-type static/random will set flag in info->flags
>
>--pad if its present then      struct xt_OBSF_info_v1        will be u=
sed.
>--pad-type static/random will set flag into info->flags
>--s "start_value" and --e "end_value" will go info info->p_info->s and
>info->p_info->e
>
>Now i'm confused how i should initialize
>
Barring what I said above about e_info and p_info,

enum {
	O_OBSF_KEY,
	O_OBSF_KEYLEN,
};
enum { /* only if needed */
	F_OBSF_KEY =3D 1 << O_OBSF_KEY,
	...
};
struct xt_option_entry OBSF_opts[] =3D {
	{.name =3D "key", .id =3D O_OBSF_KEY, .type =3D XTTYPE_STRING,
	 .flags =3D XTOPT_PUT, XTOPT_POINTER(struct enc_info, key)},

	--keylen is redundant, because you can devise that from the key itself

	{.name =3D "enc-type", .id =3D O_OBSF_ENC_TYPE, .type =3D XTTYPE_STRIN=
G},
	XTOPT_TABLEEND,
};

static int parse(struct xt_option_call *cb)
{
	struct xt_OBSF_v1 *info =3D cb->data;

	xtables_option_parse(cb);
	switch (cb->entry->id) {
	case O_OBSF_KEY:
		info->e_info->keylen =3D strlen(info->e_info->key);
		break;
	case O_OBSF_ENC_TYPE:
		if (strcmp(cb->arg, "static") =3D=3D 0)
			info->flags |=3D ...
		else if (strcmp(cb->arg, "random") =3D=3D 0)
			...
		break;
	...
	}
}

>I've seen the example for xt_NFQUEUE.c and tried to model my
>initialization after it, but
>its a little confusing.

The getopt structure facilitates placing the values for certain
options (of certain types, like uint32, etc.) directly into the
info without requiring parse code.
=46or things like --enc-type which go beyond generic "put a into b"
you need manual code, done in said parse function.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
