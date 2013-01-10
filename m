From: Borislav Petkov <bp@alien8.de>
Subject: v3.8-rc3: uninitialized warnings in net/netfilter/xt_CT.c
Date: Thu, 10 Jan 2013 12:18:21 +0100
Message-ID: <20130110111821.GA23008@liondog.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: lkml <linux-kernel@vger.kernel.org>
To: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	coreteam@netfilter.org
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

I get

net/netfilter/xt_CT.c: In function =E2=80=98xt_ct_tg_check_v1=E2=80=99:
net/netfilter/xt_CT.c:250:6: warning: =E2=80=98ret=E2=80=99 may be used=
 uninitialized in this function [-Wmaybe-uninitialized]
net/netfilter/xt_CT.c: In function =E2=80=98xt_ct_tg_check_v0=E2=80=99:
net/netfilter/xt_CT.c:112:6: warning: =E2=80=98ret=E2=80=99 may be used=
 uninitialized in this function [-Wmaybe-uninitialized]

when building 3.8-rc3 here.

And this time, the warnings are real:

static int xt_ct_tg_check_v0(const struct xt_tgchk_param *par)
{
	struct xt_ct_target_info *info =3D par->targinfo;
	struct nf_conntrack_tuple t;
	struct nf_conn *ct;
	int ret;

	if (info->flags & ~XT_CT_NOTRACK)
		return -EINVAL;

	if (info->flags & XT_CT_NOTRACK) {
		ct =3D nf_ct_untracked_get();
		atomic_inc(&ct->ct_general.use);
		goto out;
	}

#ifndef CONFIG_NF_CONNTRACK_ZONES
	if (info->zone)
		goto err1;
#endif
=2E..

ret doesn't get initialized and if the first two if-blocks are false an=
d
CONFIG_NF_CONNTRACK_ZONES is not defined (as is in my case) we do "goto
err1":

err1:
        return ret;

which returns an uninitialized 'ret'.

Now, I don't know the code to know whether if (info->zone) is ever true
but someone better check this before subtle bugs start happening.

Ditto for the xt_ct_tg_check_v1() function.

Thanks.

--=20
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
