From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: ip6tables breaks dnssec?
Date: Wed, 27 Apr 2011 12:08:57 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1104271200480.12004@obet.zrqbmnf.qr>
References: <20110427085755.GD2418@omroep.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Leo Baltus <Leo.Baltus@omroep.nl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:36990 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755756Ab1D0KI6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Apr 2011 06:08:58 -0400
In-Reply-To: <20110427085755.GD2418@omroep.nl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2011-04-27 10:57, Leo Baltus wrote:

>Hi,
>
>When doing recusive dns queries to dnssec-enbled servers it looks like
>ip6tables does not assemble udp packets before filtering takes place.
>This results in fragments being dropped.

You need to have nf_defrag_ipv6 loaded for automatic defragmentation. 
There are only a few components that depend on it - nf_conntrack and 
TPROXY, so it may not be autoloaded if you do not use either.
