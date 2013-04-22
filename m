From: Oliver <olipro@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: nftables kernel repo issue
Date: Mon, 22 Apr 2013 16:53:56 +0200
Message-ID: <1932838.uAVcz4Bni9@gentoovm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:52735 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab3DVPBT (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Apr 2013 11:01:19 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

After pulling the nftables kernel repo from 
http://1984.lsi.us.es/git/nftables/ - I then proceeded to try and rebase this 
on top of 3.8 but got an error when rebasing commit 
1504c7f715af7365bdedaae5c52c130bfa90e851 as the original commit ( 
d542703bdf5733d108cfa4263aa58253af64de52 ) is not accessible.

Could you make a branch within the nftables repo that d542703b is reachable 
from so that I may fetch it.

Thanks,
Oliver
