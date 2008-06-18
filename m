From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH 0/3] Misc fixes
Date: Wed, 18 Jun 2008 17:41:47 +0200
Message-ID: <48592CBB.5000202@netfilter.org>
References: <1213803013-19433-1-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60865 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752881AbYFRPno (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Jun 2008 11:43:44 -0400
In-Reply-To: <1213803013-19433-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> This patchset contains three patches:
>  1. Fix compilation of input plugin when libnetfilter library are non globally available.
>  2. Fix warning about undeclared function.
>  3. Backport of bugzilla 535: PCAP fix
> 
> Patchset statistics:
>  input/flow/Makefile.am           |    3 ++-
>  input/packet/Makefile.am         |    3 ++-
>  input/packet/ulogd_inppkt_ULOG.c |    1 +
>  output/pcap/ulogd_output_PCAP.c  |    2 +-
> 4 files changed, 6 insertions(+), 3 deletions(-)

All applied. Thanks Eric.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
