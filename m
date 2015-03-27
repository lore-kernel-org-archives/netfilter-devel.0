From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Re: [PATCH V3 1/2] Add revision field for xt_entry_target
Date: Fri, 27 Mar 2015 12:02:24 +0100
Message-ID: <20150327110224.GA9316@salvia>
References: <1427362410-9255-1-git-send-email-zhangcy@cn.fujitsu.com>
 <1427362410-9255-2-git-send-email-zhangcy@cn.fujitsu.com>
 <20150326124502.GA5372@salvia>
 <A43879EB4A7F5F449E2CA8148EA79E516F33E1@G08CNEXMBPEKD01.g08.fujitsu.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "Zhang, Chunyu" <zhangcy@cn.fujitsu.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58002 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750930AbbC0K6a (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Mar 2015 06:58:30 -0400
Content-Disposition: inline
In-Reply-To: <A43879EB4A7F5F449E2CA8148EA79E516F33E1@G08CNEXMBPEKD01.g08.fujitsu.local>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 27, 2015 at 01:34:06AM +0000, Zhang, Chunyu wrote:
> >From: Pablo Neira Ayuso
> >Date: 2015-03-26
> >To: Zhang, Chunyu/=E7=AB=A0 =E6=98=A5=E5=AE=87
> >Subject: Re: [PATCH V3 1/2] Add revision field for xt_entry_target
> >
> >Could you also resubmit the kernel patch to adds this? Please, no ne=
ed
> >to resend the full userspace series, just send the kernel patch as a
> >follow up.
>=20
> do you mean:
> > -#define ARPT_FUNCTION_MAXNAMELEN 30
>=20
> > +#define ARPT_FUNCTION_MAXNAMELEN 29
> do this in another  patch ,  like this ?

I mean this:

http://patchwork.ozlabs.org/patch/437065/

but never mind, I'll take that original patch. Thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
