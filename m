From: Luuk Paulussen <luuk.paulussen@alliedtelesis.co.nz>
Subject: (unknown)
Date: Wed, 23 Dec 2015 10:50:39 +1300
Message-ID: <1450821040-18837-1-git-send-email-luuk.paulussen@alliedtelesis.co.nz>
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	David Miller <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	linux-api@vger.kernel.org
To: netdev@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from gate2.alliedtelesis.co.nz ([202.36.163.20]:49800 "EHLO
	gate2.alliedtelesis.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932573AbbLVVvA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Dec 2015 16:51:00 -0500
Subject: 
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Sorry for the resend.  I forgot to include relevant netfilter maintainers
in CC list

Changes from v1 are to add dependency on NF_CONNTRACK to Kconfig to resolve
the build issue and some style fixups from checkpatch.
