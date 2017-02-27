From: Florian Westphal <fw@strlen.de>
Subject: [PATCH libnftnl 0/2] object: fix crashes with out-of-tree nft
Date: Mon, 27 Feb 2017 15:56:08 +0100
Message-ID: <20170227145610.12066-1-fw@strlen.de>
To: <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:56066 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751886AbdB0PfR (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Feb 2017 10:35:17 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

While working on ct helper object support I encountered crashes in libnftnl.
This occurs when nft sets unknown object types not supported by libnftnl.

The two patches avoid segfaults in case unsupported types are requested.

