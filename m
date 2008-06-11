From: Rainer Sabelka <sabelka@iue.tuwien.ac.at>
Subject: Re: conntrackd [ERROR] commit: Invalid argument
Date: Wed, 11 Jun 2008 15:45:17 +0200
Message-ID: <200806111545.18856.sabelka@iue.tuwien.ac.at>
References: <e1aa27e00806090621r3fa83ac0s7bb89d903de3be41@mail.gmail.com> <484FD25F.2010800@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Marco Barbero <marco.barbero@gmail.com>, netfilter@vger.kernel.org,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mr1-n.kom.tuwien.ac.at ([128.130.2.109]:58578 "EHLO
	mr.tuwien.ac.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750794AbYFKNq7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jun 2008 09:46:59 -0400
In-Reply-To: <484FD25F.2010800@netfilter.org>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 11 June 2008 15:25, Pablo Neira Ayuso wrote:
> Hi Marco,
> Marco Barbero wrote:
> > conntrack-tools-0.9.7
> > libnetfilter_conntrack-0.0.94
> > libnfnetlink-0.0.38
> >
> > kernel 2.6.25.5
> > Mode ALARM
> >
> > conntrackd -c from node master:
> >
> > looking logs:
> >
> > a lot of  [ERROR] commit: Invalid argument
> > Mon Jun  9 15:01:26 2008        tcp      6 180 TIME_WAIT
> > src=192.168.200.14 dst=62.149.195.137 sport=47144 dport=80 src=x.x.x.x
> > dst=192.168.200.14 sport=80 dport=47144 [ASSURED] mark=0
> >
> > and at the end:
> >
> > [Mon Jun  9 15:01:26 2008] (pid=13176) [notice] Committed 1172 new
> > entries [Mon Jun  9 15:01:26 2008] (pid=13176) [notice] 3294 entries
> > can't be committed
> >
> > Any hints?
>
> Are your scripts committing the entries twice (ie. invoking conntrackd
> -c several times)? 

In my case - yes I did.

> The only way to reproduce this that I have found is 
> to double insert an existing conntrack with some NAT handling. In the
> upcoming 2.6.26 you'll get a EBUSY instead of EINVAL which sounds more
> reasonable.
>
> Anyhow, does the patch attached fix this behaviour? The idea behind it
> is to check if there is a conntrack present in kernel, if so, just
> update the attributes of the conntrack object that are changeable to
> avoid the error. Would you mind testing it?

Thanks for the patch!
Now I see no more "commit: Invalid argument" in the logs. Instead I get 
something like this, which looks much fiendlier:

Jun 11 15:36:48 fw1b conntrack-tools[13273]: committing external cache
Jun 11 15:36:48 fw1b conntrack-tools[13273]: Committed 69 new entries
Jun 11 15:36:48 fw1b conntrack-tools[13273]: 53 entries ignored, already exist

But in rare cases I can see "commit-create: Cannot allocate memory".
I also noticed this a few times before applying this patch. Is this something 
I should worry about?

Jun 11 15:40:07 fw1b conntrack-tools[13383]: committing external cache
Jun 11 15:40:07 fw1b conntrack-tools[13383]: commit-create: Cannot allocate 
memory
Jun 11 15:40:07 fw1b conntrack-tools[13383]: Committed 33 new entries
Jun 11 15:40:07 fw1b conntrack-tools[13383]: 25 entries ignored, already exist
Jun 11 15:40:07 fw1b conntrack-tools[13383]: 1 entries can't be committed

Thanks,
-Rainer
