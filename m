From: James Feeney <james@nurealm.net>
Subject: reject statement - "crazy" parse error?
Date: Tue, 25 Oct 2016 19:30:28 -0600
Message-ID: <aea0c58c-dd68-bffb-859c-81f77ebe8dfd@nurealm.net>
Reply-To: james@nurealm.net
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from resqmta-po-12v.sys.comcast.net ([96.114.154.171]:45857 "EHLO
        resqmta-po-12v.sys.comcast.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753810AbcJZBip (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Oct 2016 21:38:45 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Arch Linux
linux 4.8.4-1

nftables-git 0.6.r96.gbb636b8-1
libnftnl-git 1.0.6.r68.gc26951e-1


/etc/nftables.conf

flush ruleset
define if_WAN = enp3s0

table ip private {
 chain postroute {
  type filter hook postrouting priority 0;
    oifname $if_WAN ip daddr 192.168.0.0/16 reject
 }
}

$ sudo nft -f /etc/nftables.conf
/etc/nftables.conf:4:1-2: Error: Could not process rule: No such file or directory
table ip private {
^^

I'm guessing that that error message is wildly off-base.

Or is "reject" not a proper "terminal statement"?

Or is there something wrong with the syntax?
