From: Patrick McHardy <kaber@trash.net>
Subject: [PATCH 0/2] nftables: fix big endian bugs
Date: Sat, 12 Apr 2014 11:09:57 +0200
Message-ID: <1397293799-2600-1-git-send-email-kaber@trash.net>
Cc: arturo.borrero.glez@gmail.com, netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:41747 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754024AbaDLJKD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Apr 2014 05:10:03 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The following two patches fix the remaining big endian bugs in nftables
I could find during my testing.

Patch 1 addresses the problem that a constant expression is allocated with
data from a variable that is larger than the data size. On big endian we
can't simply use &var but need to calculate the address of the data
dependant on the size of the variable and the size of the data we want.

Patch 2 fixes the GMP import/export functions for BYTEORDER_HOST_ENDIAN
to use the proper word order dependant on the host endianess. This is needed
because we always use a word size of 1 and the word order basically
determines the byte order.

With these patches in place, everything appears to work fine. A single
fix for the kernel is also needed, this will be sent seperately.
