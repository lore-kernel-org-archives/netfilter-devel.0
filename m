From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: resend your pending patches, please
Date: Tue, 27 Oct 2009 15:02:30 +0100
Message-ID: <4AE6FD76.40705@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>, jkosina@suse.cz,
	"David S. Miller" <davem@davemloft.net>
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53255 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755041AbZJ0OCc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Oct 2009 10:02:32 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,

While Patrick is recovering, I'll temporarily do the netfilter/iptables
kernel-space maintainance. While spinning on the mailing list, I have
found two pending patches that can be qualified as bugfixes:

[PATCH] netfilter: remove CONFIG_NF_CT_ACCT from Jiri Kosina
[PATCH] netfilter: nf_nat: fix NAT issue in 2.6.30.4+

If I'm missing any other patch, please let me know.

Once this bugfix round is done, I'll look at net-next-2.6 patches. I
have seen one patchset from Jan Engelhardt so far.

Thank you!
