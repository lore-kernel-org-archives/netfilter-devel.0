From: =?iso-8859-1?q?Asbj=F8rn_Sloth_T=F8nnesen?= <ast@fiberby.dk>
Subject: Re: [PATCH conntrack 4/5 v2] conntrack: add support for netmask
 filtering
Date: Mon, 01 Feb 2016 12:17:02 +0000
Message-ID: <1454329022.4393.1@x201s.roaming.asbjorn.biz>
References: <20160201110423.GH8095@salvia>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-XQgFMfpATaGigVe22NUd"
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.asbjorn.biz ([185.38.24.25]:50423 "EHLO mail.asbjorn.biz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932110AbcBANin (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Feb 2016 08:38:43 -0500
In-Reply-To: <20160201110423.GH8095@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--=-XQgFMfpATaGigVe22NUd
Content-Type: text/plain; charset=UTF-8

Hi Pablo,

On Mon, 1 Feb 2016 12:04:23 +0100, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Jan 25, 2016 at 11:15:47AM +0000, Asbjørn Sloth Tønnesen wrote:
> > This patch extends --mask-src and --mask-dst to also work
> > with the conntrack table, with commands -L, -D, -E and -U.
> > 
> > Signed-off-by: Asbjørn Sloth Tønnesen <ast@fiberby.dk>
> > ---
> > 
> > Notes:
> >     This is almost completely backward compatible,
> >     since the --mask-* arguments previously gave
> >     an error is used with these commands and the
> >     conntrack table.
> >     
> >     I have changed the global_family to filter_family,
> >     and it is only used to pass the family to the callback,
> >     the alternative would be to change the data argument of
> >     the callbacks to a struct.
> 
> I see changes with regards to previous patchset, not we don't use
> cidr. I think this is better since it allows a more compact way.
> 
> I prefer the cidr-based approach, any reason to drop it?

I decided to split them up in several patchsets, each having its
own merits. The netmask and CIDR patches are related, but one is about
filtering, and the other about adding some sugar to the option parsing.

BTW: I mistakenly also marked the test patch v2, but this only is the only one
in this patchset from the old one.

-- 
Best regards
Asbjørn Sloth Tønnesen
Network Engineer
Fiberby ApS - AS42541

--=-XQgFMfpATaGigVe22NUd--
