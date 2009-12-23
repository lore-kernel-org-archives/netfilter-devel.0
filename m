From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: conntrack -B undocumented
Date: Thu, 24 Dec 2009 00:25:15 +0100
Message-ID: <4B32A6DB.1050004@netfilter.org>
References: <20091216174205.GA30937@tkeitel002.bln.innominate.local>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------000803010808000903060002"
Cc: netfilter-devel@vger.kernel.org
To: Tino Keitel <tkeitel@innominate.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52875 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755768AbZLWXZF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Dec 2009 18:25:05 -0500
In-Reply-To: <20091216174205.GA30937@tkeitel002.bln.innominate.local>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000803010808000903060002
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Tino Keitel wrote:
> Hi,
> 
> the example scripts for conntrackd (like primary-backup.sh) use a -B
> option, which seems to be undocumented in the manual page and in the
> command help.  What exactly is it intended for?

It forces a bulk send to other cluster nodes. I have applied the 
following patch to the manpage.

--------------000803010808000903060002
Content-Type: text/x-patch;
 name="doc.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="doc.patch"

conntrackd: document `-B' command

From: Pablo Neira Ayuso <pablo@netfilter.org>

This patch documents the `-B' command in conntrackd that allows you
to force a bulk send to other firewall nodes in the cluster.

Reported-by: Tino Keitel <tkeitel@innominate.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
 conntrackd.8 |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/conntrackd.8 b/conntrackd.8
index f741bc9..0c9054e 100644
--- a/conntrackd.8
+++ b/conntrackd.8
@@ -41,6 +41,10 @@ Flush the internal and/or external cache
 Flush the kernel conntrack table (if you use a Linux kernel >= 2.6.29, this
 option will not flush your internal and external cache).
 .TP
+.BI "-B "
+Force a bulk send to other replica firewalls. With this command, you will
+ask conntrackd to send the state-entries that it owns to others.
+.TP
 .BI "-k "
 Kill the daemon
 .TP

--------------000803010808000903060002--
