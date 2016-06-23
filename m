From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: nft shell tests
Date: Thu, 23 Jun 2016 12:43:20 +0200
Message-ID: <20160623104320.GA13710@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49389 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751656AbcFWKnZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jun 2016 06:43:25 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 0EDD2E7DA8
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 12:43:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0072F9EBA3
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 12:43:24 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E8D1B9EBA8
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 12:43:21 +0200 (CEST)
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Arturo,

I think it would be good if the run-test.sh script uses the binary
in this tree, just like nft-tests.py. Instead of using the one that is
available on the system.

Let me know, thanks.
