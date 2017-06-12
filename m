From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [4.9.y,netfilter] please, cherry-pick da2f27e9e615
Date: Mon, 12 Jun 2017 23:25:23 +0200
Message-ID: <20170612212523.GA12418@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Juergen Schmidt <abcdmail@freenet.de>,
        netfilter-devel@vger.kernel.org
To: stable@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:34242 "EHLO
        ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752883AbdFLVZk (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 12 Jun 2017 17:25:40 -0400
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Resending this, I used the wrong stable email address.

-o-

Hi,

Please, 4.9 stable maintainer, cherry-pick this commit:

commit da2f27e9e615d1c799c9582b15262458da61fddc
Author: Christophe Leroy <christophe.leroy@c-s.fr>
Date:   Wed Mar 1 15:33:26 2017 +0100

    netfilter: nf_conntrack_sip: fix wrong memory initialisation

We have a user complaining about this bug that manifests in 4.9:

http://marc.info/?l=netfilter&m=149577235017072&w=2

Thanks!
