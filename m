From: "Gao Feng" <gfree.wind@foxmail.com>
Subject: RE: [PATCH nf v5 2/3] netfilter: nat_helper: Make sure every proto nat module uses its nat_helper
Date: Mon, 17 Apr 2017 08:50:35 +0800
Message-ID: <001e01d2b714$a702c050$f50840f0$@foxmail.com>
References: <cover.1490955730.git.fgao@ikuai8.com> <74aaa9aaa69d65fa46d56faf5c4de671abf4a5cf.1490955730.git.fgao@ikuai8.com> <20170414001107.GA28754@salvia> <000001d2b4b8$97256c40$c57044c0$@foxmail.com> <20170414010249.GA29837@salvia>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@vger.kernel.org>
To: "'Pablo Neira Ayuso'" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbgsg2.qq.com ([54.254.200.128]:52636 "EHLO smtpbgsg2.qq.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1756951AbdDQAux (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 16 Apr 2017 20:50:53 -0400
In-Reply-To: <20170414010249.GA29837@salvia>
Content-Language: zh-cn
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

> From: netfilter-devel-owner@vger.kernel.org
> [mailto:netfilter-devel-owner@vger.kernel.org] On Behalf Of Pablo Neira
> Ayuso
> On Fri, Apr 14, 2017 at 08:46:44AM +0800, Gao Feng wrote:
> > > -----Original Message-----
> > > From: Pablo Neira Ayuso [mailto:pablo@netfilter.org] On Fri, Mar 31,
> > > 2017 at 06:38:20PM +0800, gfree.wind@foxmail.com wrote:
> > > > +static struct nf_ct_nat_helper pptp_nat = {
> > > > +	.name			= "pptp_nat",
> > >
> > > Why all these with "xyz_nat" names?
> >
> > I just used the variable name before.
> > How about rename it to "xyz_nat_helper"?
> > >
> > > This is going to break ctnetlink, as this is the name that
> > > identifies the
> > NAT
> > > helper to be used.
> 
> This name is exposed to userspace, right?
> 
> So FTP uses to rely on the "nat-follow-master" expectfn. But now the name
will
> be "ftp_nat".
> 
> If that is the case, this would break backward.

I am a little confusing.
The " struct nf_ct_nat_helper ftp_nat ftp_nat" is one new variable, while
the original variable 
"struct nf_ct_nat_helper follow_master_nat" name still is "
"nat-follow-master".

I couldn't figure about how could this break backward.
Do you think the name " ftp_nat " should use " ftp_nat_follow_master"?

BTW, how about use nat_helper pointer instead of expect fn?
As I mentioned before, it could avoid two assignment. 
Is it ok?

Regards
Feng

> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel"
in the
> body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html



