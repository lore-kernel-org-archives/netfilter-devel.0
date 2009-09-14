From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: iptables release
Date: Mon, 14 Sep 2009 19:52:08 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0909141950120.13437@obet.zrqbmnf.qr>
References: <4AA8FF29.1030607@trash.net> <alpine.LSU.2.00.0909101928110.32083@obet.zrqbmnf.qr> <4AAE7807.8050701@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:47341 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755368AbZINRwG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 14 Sep 2009 13:52:06 -0400
In-Reply-To: <4AAE7807.8050701@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2009-09-14 19:06, Patrick McHardy wrote:
>
>Sorry, I don't want any features that late in the release stage.
>Feel free to send it to me now that the release is out :)
>


The following changes since commit 352ccfb847dfd290a7b761cd87445a48e551acb5:
  Jan Engelhardt (1):
        manpages: more fixes to minuses, hyphens, dashes

are available in the git repository at:

  git://dev.medozas.de/iptables zero

Jan Engelhardt (1):
      iptables: manpage updates for augmented -Z syntax

Mohit Mehta (1):
      iptables: expose option to zero packet/byte counters for a specific rule

 ip6tables.8.in |    7 ++++---
 ip6tables.c    |   31 ++++++++++++++++++++++++-------
 iptables.8.in  |    7 ++++---
 iptables.c     |   31 ++++++++++++++++++++++++-------
 4 files changed, 56 insertions(+), 20 deletions(-)
