From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: nfnetlink_log: work around uninitialized
 variable warning
Date: Wed, 11 Nov 2015 14:17:42 +0100
Message-ID: <20151111131742.GA6079@salvia>
References: <17817903.Md6b3ydRpX@wuerfel>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org, Ken-ichirou MATSUZAWA <chamaken@gmail.com>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
To: Arnd Bergmann <arnd@arndb.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53689 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752122AbbKKNRq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Nov 2015 08:17:46 -0500
Received: from antivirus1-rhel7.int (antivirus1.int [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 987681392C2
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2015 14:17:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 838114EE81
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2015 14:17:45 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 675F04EE8C
	for <netfilter-devel@vger.kernel.org>; Wed, 11 Nov 2015 14:17:43 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <17817903.Md6b3ydRpX@wuerfel>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 10, 2015 at 01:08:15PM +0100, Arnd Bergmann wrote:
> After a recent (correct) change, gcc started warning about the use
> of the 'flags' variable in nfulnl_recv_config()
> 
> net/netfilter/nfnetlink_log.c: In function 'nfulnl_recv_config':
> net/netfilter/nfnetlink_log.c:320:14: warning: 'flags' may be used uninitialized in this function [-Wmaybe-uninitialized]
> net/netfilter/nfnetlink_log.c:828:6: note: 'flags' was declared here
> 
> The warning first shows up in ARM s3c2410_defconfig with gcc-4.3 or
> higher (including 5.2.1, which is the latest version I checked) I
> tried working around it by rearranging the code but had no success
> with that.
> 
> As a last resort, this initializes the variable to zero, which shuts
> up the warning, but means that we don't get a warning if the code
> is ever changed in a way that actually causes the variable to be
> used without first being written.

Applied, thanks!
