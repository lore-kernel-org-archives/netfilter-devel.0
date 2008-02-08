From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: nf_nat_core just using l3proto_find_get
Date: Fri, 8 Feb 2008 03:10:56 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802080309220.25157@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:43093 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762342AbYBHCK5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Feb 2008 21:10:57 -0500
Received: from localhost (localhost [127.0.0.1])
	by sovereign.computergmbh.de (Postfix) with ESMTP id 439161C0E6EE7
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Feb 2008 03:10:56 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,


I just noticed that nf_nat_core.c uses

        l3proto = nf_ct_l3proto_find_get((u_int16_t)AF_INET);

in its nf_nat_init() function. Why is not it using 
nf_ct_l3proto_module_try_get here?
