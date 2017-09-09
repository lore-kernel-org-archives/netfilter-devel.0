From: Colin Caine <colin.caine@manchester.ac.uk>
Subject: [nft] Documentation point release/backport
Date: Sat, 9 Sep 2017 05:15:42 +0100
Message-ID: <20170909041541.GA6951@cs.man.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from probity.mcc.ac.uk ([130.88.200.94]:23786 "EHLO
        probity.mcc.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750899AbdIIEbZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 9 Sep 2017 00:31:25 -0400
Received: from asmtp2.its.manchester.ac.uk ([130.88.13.150])
        by probity.mcc.ac.uk with esmtps (TLSv1:DHE-RSA-AES256-SHA:256)
        (Exim 4.85 (FreeBSD))
        (envelope-from <colin.caine@manchester.ac.uk>)
        id 1dqXBH-000OYt-Qj
        for netfilter-devel@vger.kernel.org; Sat, 09 Sep 2017 05:15:43 +0100
Received: from cpc113422-maid7-2-0-cust934.20-1.cable.virginm.net ([86.18.187.167]:44326 helo=cs.man.ac.uk)
        by asmtp2.its.manchester.ac.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.89)
        (envelope-from <colin.caine@manchester.ac.uk>)
        id 1dqXBH-0001Cg-EL
        for netfilter-devel@vger.kernel.org; Sat, 09 Sep 2017 05:15:43 +0100
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The man page distributed with nftables v0.7 is erroneous (add chain
syntax) and misses some important functionality e.g. `list ruleset`, but
the documentation in master is better (Thanks!).

Could the documentation in master be backported as a point release for
users (if v0.8 won't be soon)?

The wiki is OK as a replacement, but it would be very useful to have a
complete and authoritative reference.

Documentation lagging so far behind functionality might suggest that
contributors don't like editing docbook. If the asciidoc patch is
rejected, perhaps contributors who do like editing docbook could share
what tools they use?

My unsolicited two cents: if it were my choice, I'd switch to a readable
and easily writable markup (so contributors actually write it) which can
embed a real programming language (to encourage automation and testing
of the documentation).

Probably Pollen or scribble (racket DSLs) [1]? Neither have man
outputs yet, but you could go Pollen -> markdown -> man, or just extend
either a bit (it's not like the man(7) is complicated).

Thanks for reading,
Colin

[1]: https://docs.racket-lang.org/pollen/
     https://docs.racket-lang.org/scribble/
