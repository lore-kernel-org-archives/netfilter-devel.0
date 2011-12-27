From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xt_ecn revisited
Date: Tue, 27 Dec 2011 17:08:59 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1112271707400.24481@frira.zrqbmnf.qr>
References: <1324999681-22479-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:32809 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754047Ab1L0QJB (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Dec 2011 11:09:01 -0500
In-Reply-To: <1324999681-22479-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2011-12-27 16:27, Jan Engelhardt wrote:

>
>fatal: Unable to look up  (port 9418) (No address associated with hostname)
>warn: No branch of git://dev.medozas.de is at:
>warn:   806e172: netfilter: xtables: collapse conditions in xt_ecn
>warn: Are you sure you pushed HEAD there?

Grumble. It's just because I have url=/srv/git/... that it can't find 
it.

>The following changes since commit c5e1fd8ccae09f574d6f978c90c2b968ee29030c:
>  Merge branch 'nf-next' of git://1984.lsi.us.es/net-next (2011-12-25 02:21:45 -0500)
>are available in the git repository at:
>
>  git://dev.medozas.de ..BRANCH.NOT.VERIFIED..

   git://dev.medozas.de  xtecn


>Jan Engelhardt (3):
>      netfilter: xtables: move ipt_ecn to xt_ecn
>      netfilter: xtables: give xt_ecn its own name
>      netfilter: xtables: collapse conditions in xt_ecn
>
>Patrick McHardy (1):
>      netfilter: xtables: add an IPv6 capable version of the ECN match
>
> include/linux/netfilter/Kbuild         |    1 +
> include/linux/netfilter/xt_ecn.h       |   35 ++++++
> include/linux/netfilter_ipv4/ipt_ecn.h |   38 ++-----
> net/ipv4/netfilter/Kconfig             |   10 +-
> net/ipv4/netfilter/Makefile            |    1 -
> net/ipv4/netfilter/ipt_ecn.c           |  127 ----------------------
> net/netfilter/Kconfig                  |    9 ++
> net/netfilter/Makefile                 |    1 +
> net/netfilter/xt_ecn.c                 |  179 ++++++++++++++++++++++++++++++++
> 9 files changed, 239 insertions(+), 162 deletions(-)
> create mode 100644 include/linux/netfilter/xt_ecn.h
> delete mode 100644 net/ipv4/netfilter/ipt_ecn.c
> create mode 100644 net/netfilter/xt_ecn.c
