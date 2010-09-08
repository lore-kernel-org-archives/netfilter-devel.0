From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [ANNOUNCE] libnetfilter_conntrack 0.9.0 release
Date: Wed, 8 Sep 2010 20:17:17 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1009082016280.22870@obet.zrqbmnf.qr>
References: <4C875A2A.6030206@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter@vger.kernel.org, netfilter-announce@lists.netfilter.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, lwn@lwn.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:38666 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752759Ab0IHSRS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Sep 2010 14:17:18 -0400
In-Reply-To: <4C875A2A.6030206@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2010-09-08 11:40, Pablo Neira Ayuso wrote:

>Hi!
>
>The Netfilter project presents libnetfilter_conntrack-0.9.0
>
>libnetfilter_conntrack is a userspace library providing a programming
>interface (API) to the in-kernel connection tracking state table. This
>library requires a linux kernel >= 2.6.18.
>
>This release includes two fixes and the infrastructure to generate API
>documentation in doxygen format. ChangeLog is also attached for more
>details.
>
>Pablo Neira Ayuso (5):                                                          
>      ct: fix regression with helpers for Linux kernel >= 2.6.34
>      build: add libtool m4 support
>      src: convert documentation from kerneldoc to doxygen format

Did you not like the doxygen filter that allows to use kdoc in the .c 
files?
