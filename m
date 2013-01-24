From: Gao feng <gaofeng@cn.fujitsu.com>
Subject: Re: [PATCH nf-next 06/11] netfilter: timeout: move initial codes
 out of pernet_operations
Date: Thu, 24 Jan 2013 08:43:31 +0800
Message-ID: <510083B3.7070507@cn.fujitsu.com>
References: <1358842234-15005-1-git-send-email-gaofeng@cn.fujitsu.com> <1358842234-15005-6-git-send-email-gaofeng@cn.fujitsu.com> <20130123131354.GF13799@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net,
	canqunzhang@gmail.com, ebiederm@xmission.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:20582 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752823Ab3AXAnB convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jan 2013 19:43:01 -0500
In-Reply-To: <20130123131354.GF13799@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2013/01/23 21:13, Pablo Neira Ayuso wrote:
> On Tue, Jan 22, 2013 at 04:10:29PM +0800, Gao feng wrote:
>> Move the global initial codes to the module_init/exit context.
>=20
> I hit a compilation error:
>=20
> net/netfilter/nf_conntrack_timeout.c: In function =E2=80=98nf_conntra=
ck_timeout_init=E2=80=99:
> net/netfilter/nf_conntrack_timeout.c:48:1: warning: ISO C90 forbids m=
ixed declarations and code [-Wdeclaration-after-statement]
> net/netfilter/nf_conntrack_timeout.c:51:1: error: expected declaratio=
n or statement at end of input
> net/netfilter/nf_conntrack_timeout.c:51:1: warning: control reaches e=
nd of non-void function [-Wreturn-type]
>=20
> int nf_conntrack_timeout_init(void)
> {
>         int ret =3D nf_ct_extend_register(&timeout_extend);
>         if (ret < 0) {
>                 pr_err("nf_ct_timeout: Unable to register timeout ext=
ension.\n");
>         return ret;
> }
>=20
> Unbalanced bracket.
>=20
> I have fixed this myself and I have applied it to nf-next. Please,
> next time make sure you have selected all conntrack / netfilter
> modules in your .config file.
>

I'm sorry.will take care of it next time. :)

Thanks!
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
