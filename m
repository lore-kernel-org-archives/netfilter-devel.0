From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft 2/2] doc: payload and conntrack statement
Date: Fri, 9 Sep 2016 00:30:15 +0200
Message-ID: <20160908223015.GB29687@salvia>
References: <1473373016-24078-1-git-send-email-fw@strlen.de>
 <1473373016-24078-2-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, nevola@gmail.com
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57568 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752327AbcIHWaY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 8 Sep 2016 18:30:24 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id EAE0F231675
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Sep 2016 00:30:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id DA7E71B357C
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Sep 2016 00:30:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C402A1B32DE
        for <netfilter-devel@vger.kernel.org>; Fri,  9 Sep 2016 00:30:20 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1473373016-24078-2-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 09, 2016 at 12:16:56AM +0200, Florian Westphal wrote:
> Signed-off-by: Florian Westphal <fw@strlen.de>

Acked-by: Pablo Neira Ayuso <pablo@netfilter.org>

BTW, related to payload mangling, Laura sent me this report:

When adding this rule:

  # nft add rule netdev filter ingress \
        ip daddr 192.168.0.92 tcp dport 80 \
        ether daddr set 00:03:2d:2b:74:ec fwd to enp3s0

The listing shows:

  # nft list ruleset
  table netdev filter {
      chain ingress {
         type filter hook ingress device enp0s25 priority 0; policy accept;
         ip daddr 192.168.0.92 tcp dport http ether daddr set ec:74:2b:2d:03:00 fwd to "enp3s0"
                                                              ^^^^^^^^^^^^^^^^^

Note that the MAC address is reversed, probably something wrong in the
delinearize path. In case you have some spare cycle, I didn't look at
this yet.

Another issue she also reported another problem with integers from
sets when using jhash and numgen, actually it's again the lack of
specific endianess of integer_type that is causing the problem so it
is not specific of the new expression.

 # nft --debug=netlink add rule x y meta mark set meta cpu map { 0 : 1, 1 : 2 }
 __map%d x b
 __map%d x 0
        element 00000000  : 00000001 0 [end]    element 01000000  : 00000002 0 [end]
                                                        ^^^^^^^^

note this is also in the wrong byteorder. This one, I'm working on it.
