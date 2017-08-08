From: Florian Westphal <fw@strlen.de>
Subject: [PATCH nf-next 0/4] netfilter: nftables: tcp mss mangling support
Date: Tue,  8 Aug 2017 15:15:26 +0200
Message-ID: <20170808131530.29194-1-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:34478 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751925AbdHHNPM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 8 Aug 2017 09:15:12 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This series adds the needed kernel parts to support tcp mss mangling.
First two patches rework exthdr so we don't have to copy-paste too much,
patch 3 adds tcp option mangling support.

Last patch allows to retrieve path tcpmss via rt expression, this is so we
can support iptables TCPMSS --clamp-to-pmtu by combining the two, i.e.:

nft add rule inet mangle forward tcp option mss set rt mss

