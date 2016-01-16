From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 3/3] netfilter: bridge: copy back VLAN header for
 bridge packet queued to userspace
Date: Sat, 16 Jan 2016 12:06:19 +0100
Message-ID: <20160116110619.GA28299@breakpoint.cc>
References: <1452847734-3766-1-git-send-email-stephane.ml.bryant@gmail.com>
 <1452847734-3766-4-git-send-email-stephane.ml.bryant@gmail.com>
 <20160115110218.GA2361@salvia>
 <20160115140412.GD7462@breakpoint.cc>
 <20160115163315.GA1276@salvia>
 <569A22C8.9030707@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Florian Westphal <fw@strlen.de>,
	netfilter-devel@vger.kernel.org
To: =?iso-8859-15?Q?st=E9phane?= bryant <stephane.ml.bryant@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:40934 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751610AbcAPLGX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 Jan 2016 06:06:23 -0500
Content-Disposition: inline
In-Reply-To: <569A22C8.9030707@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

st=E9phane bryant <stephane.ml.bryant@gmail.com> wrote:

Please don't top-post, thanks.

> Regarding the entire L2 header attribute. I assume it would be a
> separate attribute from the existing NFQA_HWADDR?

Yes, it would just contain mac header start to skb->data, i.e. without
VLAN header.  VLAN header would go into a new attribute too.

> Or would it make sense
> to collapse these 2 into one (potentially with helpers to access each
> relevant field) to avoid duplicating information (and redundancy, and
> potential discrepancies)?

Yes but we cannot do it due to backwards compatibility.
We *can* omit NFQA_HWADDR in the family =3D=3D NFPROTO_BRIDGE case of
course.

Thanks for working on this,
=46lorian
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
