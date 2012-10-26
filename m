From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC PATCH 0/1] xtables: allow to monitor table update event
Date: Fri, 26 Oct 2012 10:44:34 +0200
Message-ID: <20121026084434.GA6970@1984>
References: <1348501182-12470-1-git-send-email-nicolas.dichtel@6wind.com>
 <1349183171-4136-1-git-send-email-nicolas.dichtel@6wind.com>
 <507C0B40.5000105@6wind.com>
 <50893620.70107@6wind.com>
 <20121025171911.GA9571@1984>
 <508A4445.5020500@6wind.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, Jan Engelhardt <jengelh@inai.de>
To: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48877 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757408Ab2JZIon (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Oct 2012 04:44:43 -0400
Content-Disposition: inline
In-Reply-To: <508A4445.5020500@6wind.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Nicolas,

On Fri, Oct 26, 2012 at 10:05:25AM +0200, Nicolas Dichtel wrote:
> Le 25/10/2012 19:19, Pablo Neira Ayuso a =E9crit :
> >Hi Nicolas,
> >
> >On Thu, Oct 25, 2012 at 02:52:48PM +0200, Nicolas Dichtel wrote:
> >>Le 15/10/2012 15:10, Nicolas Dichtel a =E9crit :
> >>>Le 02/10/2012 15:06, Nicolas Dichtel a =E9crit :
> >>>>The following patch is an example of a userspace tools (in fact, =
iptables)
> >>>>that use the new netlink API to monitor tables activity.
> >>>>
> >>>>I will also send a patch against libnfnetlink to update linux inc=
ludes with
> >>>>this new feature.
> >>>>
> >>>>Maybe another API can be used for this feature: adding a setsocko=
pt() on an
> >>>>iptc socket to enable monitoring. When a table is updated, a pack=
et (built with
> >>>>CMSG_* macro for example) can be sent over all sockets that monit=
or tables
> >>>>acitivity (like km sockets in IPsec). I know that this socket was=
 used only with
> >>>>[g|s]etsockopt(), but this can avoid adding another netlink API.
> >>>>
> >>>>Comments are welcome.
> >>>Any feedback about this patch or the other proposed API?
> >>
> >>Still no comment about this feature? Maybe another option to solve =
the problem?
> >
> >Adding a new nfnetlink subsystem to just reports table updates seems
> >a bit too much to me.
>
> What about the second proposal? Sending messages through the iptc soc=
ket?
> If you have some other ideas, we can change the design of the
> implementation, it's not a problem.

It's been four weeks since you posted your patch and you've been
asking for feedback *every single week* with no results at all. So,
nobody cares.

I see no existing FOSS projects using using this (apart from you
iptables change to report events).

And I already told you, I don't think it makes sense to maintain more
than one firewalling subsystem using netlink as interface.

Please, stop.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
