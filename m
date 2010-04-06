From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables pull: osf and misc
Date: Tue, 06 Apr 2010 16:15:54 +0200
Message-ID: <4BBB421A.3060703@trash.net>
References: <1270551164-2945-1-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58729 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab0DFOPy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Apr 2010 10:15:54 -0400
In-Reply-To: <1270551164-2945-1-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> The following changes since commit 21d1283750d9c4df7ca80165d2b9dc0b9bd214eb:
>   Jan Engelhardt (1):
>         iptables: correctly check for too-long chain/target/match names
> 
> are available in the git repository at:
> 
>   git://dev.medozas.de/iptables master
> 
> Jan Engelhardt (5):
>       doc: libxt_MARK: no longer restricted to mangle table
>       doc: remove claim that TCPMSS is limited to mangle
>       libxt_recent: add a missing space in output
>       doc: add manpage for libxt_osf
>       libxt_osf: import nfnl_osf program

This introduces a new dependency on libnfnetlink. I'd prefer if it would
only build the osf utils when the library is present.
