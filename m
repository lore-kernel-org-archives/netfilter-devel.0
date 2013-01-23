From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next 06/11] netfilter: timeout: move initial codes
 out of pernet_operations
Date: Wed, 23 Jan 2013 14:13:54 +0100
Message-ID: <20130123131354.GF13799@1984>
References: <1358842234-15005-1-git-send-email-gaofeng@cn.fujitsu.com>
 <1358842234-15005-6-git-send-email-gaofeng@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net,
	canqunzhang@gmail.com, ebiederm@xmission.com
To: Gao feng <gaofeng@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53181 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751159Ab3AWNOB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jan 2013 08:14:01 -0500
Content-Disposition: inline
In-Reply-To: <1358842234-15005-6-git-send-email-gaofeng@cn.fujitsu.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 22, 2013 at 04:10:29PM +0800, Gao feng wrote:
> Move the global initial codes to the module_init/exit context.

I hit a compilation error:

net/netfilter/nf_conntrack_timeout.c: In function =E2=80=98nf_conntrack=
_timeout_init=E2=80=99:
net/netfilter/nf_conntrack_timeout.c:48:1: warning: ISO C90 forbids mix=
ed declarations and code [-Wdeclaration-after-statement]
net/netfilter/nf_conntrack_timeout.c:51:1: error: expected declaration =
or statement at end of input
net/netfilter/nf_conntrack_timeout.c:51:1: warning: control reaches end=
 of non-void function [-Wreturn-type]

int nf_conntrack_timeout_init(void)
{
        int ret =3D nf_ct_extend_register(&timeout_extend);
        if (ret < 0) {
                pr_err("nf_ct_timeout: Unable to register timeout exten=
sion.\n");
        return ret;
}

Unbalanced bracket.

I have fixed this myself and I have applied it to nf-next. Please,
next time make sure you have selected all conntrack / netfilter
modules in your .config file.

Thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
