From: Aft nix <aftnix@gmail.com>
Subject: Help parsing options with iptables extension
Date: Sat, 15 Sep 2012 16:58:09 +0600
Message-ID: <CAGuaRCuz+8_CPsXpouoDOdkg-6ezjuZrgc=UVqe-JqYwz2U2QQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ie0-f174.google.com ([209.85.223.174]:57438 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752869Ab2IOK6K (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 15 Sep 2012 06:58:10 -0400
Received: by ieje11 with SMTP id e11so7536953iej.19
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Sep 2012 03:58:09 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,
It seems writing actual kernel module is easier then writing its
iptables counterpart :)

I'm trying to write a userspace plugin for my in kernel netfilter module.

Data structure i'm trying to populate is following :

#define XT_OBSF_MAX_KEY_LEN 32
enum {
	XT_OBSF_ENC_ARC4 = 1 << 0,
	XT_OBSF_ENC_AES = 1 << 1,
	XT_OBSF_PAD_STATIC = 1 << 2,
	XT_OBSF_PAD_RANDOM = 1 << 3,
	XT_OBSF_ENC_ENC = 1 << 4,
	XT_OBSF_ENC_DEC = 1 << 5,
	XT_OBSF_PAD_ADD = 1 << 6,
	XT_OBSF_PAD_REM = 1 << 7
};

struct enc_info {
		__u8 key[XT_OBSF_MAX_KEY_LEN];
		__u8 kl;
	};

struct pad_info {
		__u8 s;
		__u8 e;
	};

struct xt_OBSF_tginfo {
	__u8 flags;
	struct enc_info *e_info;
	struct xt_obsf_priv *priv;
};

struct xt_OBSF_tginfo_v1 {
	__u8 flags;
	struct enc_info *e_info;
	struct pad_info *p_info;
	struct xt_obsf_priv *priv;
};

The structure of options are :

static void OBSF_help(void)
{
	printf(
		"OBSF target obtions\n"
		"  --key key --keylen kln "
			"key is <32 byte valued"
                    --enc-type aes/arc4

		""
		);
}

static void OBSF_help_v1(void)
{
	OBSF_help();
	printf(
		"  --pad yes/no --pad-type static/random --s start value ---e end value"
				"start/end value 0-255"
				"start > end"
		""
		);
}

What i'm trying to do is following:

struct xt_OBSF_info * info;

--key "key" will go into              info->e_info->key
--keylen "len" will go into          info->e_info->kl
--enc-type static/random will set flag in info->flags

--pad if its present then      struct xt_OBSF_info_v1        will be used.
--pad-type static/random will set flag into info->flags
--s "start_value" and --e "end_value" will go info info->p_info->s and
info->p_info->e

Now i'm confused how i should initialize

struct xt_option_entry OBSF_opts[] = {

......
......
......

}

I've seen the example for xt_NFQUEUE.c and tried to model my
initialization after it, but
its a little confusing.

Thanks in advance.
-aft
