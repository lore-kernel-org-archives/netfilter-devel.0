From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: [PATCH 1/27] remove ipt_TOS.c
Date: Wed, 2 Jan 2008 21:24:53 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0801022124150.14900@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:60563 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753553AbYABUYy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Jan 2008 15:24:54 -0500
In-Reply-To: <Pine.LNX.4.64.0801022037090.14900@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

commit b6e9a26f05e83d8058f1dc56a45e5f5d533ad373
Author: Jan Engelhardt <jengelh@computergmbh.de>
Date:   Wed Jan 2 17:31:42 2008 +0100

    [NETFILTER]: remove ipt_TOS.c
    
    Commit 88c85d81f74f92371745158aebc5cbf490412002 forgot to remove the
    old ipt_TOS file (whose code has been merged into xt_DSCP). Remove
    it now.
    
    Signed-off-by: Jan Engelhardt <jengelh@computergmbh.de>

 net/ipv4/netfilter/ipt_TOS.c |   82 ----------------------------------
 1 files changed, 0 insertions(+), 82 deletions(-)
 delete mode 100644 net/ipv4/netfilter/ipt_TOS.c
