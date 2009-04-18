From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: some unused netfilter config vars?
Date: Sat, 18 Apr 2009 16:24:34 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0904181624001.19265@fbirervta.pbzchgretzou.qr>
References: <alpine.LFD.2.00.0904180909580.499@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:52082 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756228AbZDROYh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 18 Apr 2009 10:24:37 -0400
In-Reply-To: <alpine.LFD.2.00.0904180909580.499@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2009-04-18 15:10, Robert P. J. Day wrote:

>
>===== IP_NF_MATCH_TTL
>net/ipv4/netfilter/Kconfig:95:config IP_NF_MATCH_TTL
>===== IP_NF_TARGET_TTL
>net/ipv4/netfilter/Kconfig:325:config IP_NF_TARGET_TTL
>===== IP6_NF_MATCH_HL
>net/ipv6/netfilter/Kconfig:97:config IP6_NF_MATCH_HL
>===== IP6_NF_TARGET_HL
>net/ipv6/netfilter/Kconfig:133:config IP6_NF_TARGET_HL
>
>  nothing seems to refer to any of the above.

The commit message stated why - compatibilityophobia ;-)
