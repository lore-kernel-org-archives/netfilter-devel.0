From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [PATCH v2 1/2] iptables: support match info fixup after
 tc_init
Date: Mon, 18 Sep 2017 20:04:57 +0200 (CEST)
Message-ID: <nycvar.YFH.7.76.1709182004310.12641@n3.vanv.qr>
References: <20170917112031.8644-1-shmulik@nsof.io>        <20170917112031.8644-2-shmulik@nsof.io>        <20170918162811.GA6091@salvia> <20170918200042.3189aa0f@pixies>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        Willem de Bruijn <willemb@google.com>, rbk@nsof.io,
        Rafael Buchbinder <rafi@rbk.ms>
To: Shmulik Ladkani <shmulik@nsof.io>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a3.inai.de ([88.198.180.161]:59800 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753479AbdIRSE7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 18 Sep 2017 14:04:59 -0400
In-Reply-To: <20170918200042.3189aa0f@pixies>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Monday 2017-09-18 19:00, Shmulik Ladkani wrote:
>
>This must occur after every load of entries, as the xt_bpf match needs
>a fixup once read from kernel.

So you could use the check function for it, do you not?
