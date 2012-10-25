From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC PATCH 0/1] xtables: allow to monitor table update event
Date: Thu, 25 Oct 2012 19:19:11 +0200
Message-ID: <20121025171911.GA9571@1984>
References: <1348501182-12470-1-git-send-email-nicolas.dichtel@6wind.com>
 <1349183171-4136-1-git-send-email-nicolas.dichtel@6wind.com>
 <507C0B40.5000105@6wind.com>
 <50893620.70107@6wind.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43242 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935930Ab2JYRTT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Oct 2012 13:19:19 -0400
Content-Disposition: inline
In-Reply-To: <50893620.70107@6wind.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Nicolas,

On Thu, Oct 25, 2012 at 02:52:48PM +0200, Nicolas Dichtel wrote:
> Le 15/10/2012 15:10, Nicolas Dichtel a =E9crit :
> >Le 02/10/2012 15:06, Nicolas Dichtel a =E9crit :
> >>The following patch is an example of a userspace tools (in fact, ip=
tables)
> >>that use the new netlink API to monitor tables activity.
> >>
> >>I will also send a patch against libnfnetlink to update linux inclu=
des with
> >>this new feature.
> >>
> >>Maybe another API can be used for this feature: adding a setsockopt=
() on an
> >>iptc socket to enable monitoring. When a table is updated, a packet=
 (built with
> >>CMSG_* macro for example) can be sent over all sockets that monitor=
 tables
> >>acitivity (like km sockets in IPsec). I know that this socket was u=
sed only with
> >>[g|s]etsockopt(), but this can avoid adding another netlink API.
> >>
> >>Comments are welcome.
> >Any feedback about this patch or the other proposed API?
>
> Still no comment about this feature? Maybe another option to solve th=
e problem?

Adding a new nfnetlink subsystem to just reports table updates seems
a bit too much to me.

I'd aim to the nftables proposal that I just made. If this doesn't
happen in a reasonable amount of time, get back to the mailing list
and push us again to get this in.

Thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
