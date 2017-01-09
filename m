From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH v2 2/2] tcp: fix mark propagation with fwmark_reflect
 enabled
Date: Mon, 09 Jan 2017 12:23:25 -0500 (EST)
Message-ID: <20170109.122325.1271058988063839396.davem@davemloft.net>
References: <20170106193328.24272-1-pau.espin@tessares.net>
        <20170106193328.24272-2-pau.espin@tessares.net>
        <20170109170007.GB25948@salvia>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: pau.espin@tessares.net, netfilter-devel@vger.kernel.org,
        pespin.shar@gmail.com, lorenzo@google.com
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from shards.monkeyblade.net ([184.105.139.130]:43354 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1035128AbdAIRX1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 9 Jan 2017 12:23:27 -0500
In-Reply-To: <20170109170007.GB25948@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Pablo Neira Ayuso <pablo@netfilter.org>
Date: Mon, 9 Jan 2017 18:00:07 +0100

> @David, unless you want me to follow a different path, I'll take this
> small chunk into my nf tree.

No objection.
