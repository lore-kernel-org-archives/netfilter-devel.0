From: Marek Kierdelewicz <marek@piasta.pl>
Subject: xtables-addons - problem including nf_nat.h in userspace plugin
Date: Sun, 21 Nov 2010 22:47:31 +0100
Message-ID: <20101121224731.22fced2b@catus>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from psyche.piasta.pl ([83.175.144.5]:44880 "EHLO psyche.piasta.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754336Ab0KUWQX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 21 Nov 2010 17:16:23 -0500
Received: from [10.15.100.1] (helo=catus)
	by psyche.piasta.pl with esmtpsa (TLS1.0:DHE_RSA_AES_128_CBC_SHA1:16)
	(Pocztex KoBa)
	(envelope-from <marek@piasta.pl>)
	id 1PKHkw-0002au-2p
	for netfilter-devel@vger.kernel.org; Sun, 21 Nov 2010 22:47:30 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I'm writing a new netfilter module and I'm using xtables-addons
infrastructure version 1.31 as described in paragraph 2.9.1 of
"Writing Netfilter modules" ebook[1]. 

Iptables userspace plugin for the module needs definition of "struct
nf_nat_multi_range", so I added following line to libxt_xxxx.c:
#include <net/netfilter/nf_nat.h>

Unfortunately I get following message during make: 
warning: net/netfilter/nf_nat.h: No such file or directory
... and compilation fails.

I was able to make it work by copying nf_nat.h and nf_conntrack_tuple.h
to extension directory in xtables-addons tree and by modifying include
in libxt_xxxx.c to "nf_nat.h", but this doesn't seem to be the proper
way of doing things.

How can I make it work without copying header files to xtables-addons
tree?

Please CC me in reply as I'm not subscribed to netfilter-devel. Thx!

[1] http://jengelh.medozas.de/documents/Netfilter_Modules.pdf

Best regards,
Marek
