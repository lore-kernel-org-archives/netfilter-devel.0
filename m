From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/3] libiptc: remove libiptc.so
Date: Fri, 30 Dec 2011 12:54:44 +0100
Message-ID: <20111230115444.GB12204@1984>
References: <1325209595-23244-1-git-send-email-jengelh@medozas.de>
 <1325209595-23244-2-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49721 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753024Ab1L3Lyq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Dec 2011 06:54:46 -0500
Content-Disposition: inline
In-Reply-To: <1325209595-23244-2-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 30, 2011 at 02:46:32AM +0100, Jan Engelhardt wrote:
> When Linux distributions started to ship binutils-ld defaulting to
> -Wl,--as-needed, we had to add a hack (-Wl,--no-as-needed) to the
> iptables build such that libiptc.so continued to link to libip4tc.so
> and libip6tc.so despite not requesting any symbols from there.
> 
> Given that distros start shipping binutils-ld defaulting to
> -Wl,--no-copy-dt-needed-entries, 3rd-party programs linking
> to -liptc will ignore libiptc.so's DT_NEEDED entries by default and
> not search for symbols there. So libiptc.so has finally become
> useless, so remove it. Dependent programs should have been using the
> pkg-config infrastructure, where quering for "iptc" returned "-lip4tc
> -lip6tc" for long enough.

My only concern here, as usual, is if people with old distros (I know
a handful of them that use it in productive environments as firewalls,
with very basic package set, that only update necessary things
like iptables and the Linux kernel) may experience problems.

So, my question is since how long do distros include this mechanism?
Which replies to how many people will experience problems on using
iptables since these changes are applied.
