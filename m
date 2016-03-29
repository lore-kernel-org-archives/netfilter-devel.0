From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables-translate: Initializing comment member in
 xt_xlate structure
Date: Tue, 29 Mar 2016 12:58:45 +0200
Message-ID: <20160329105845.GA10458@salvia>
References: <20160328190436.GA19755@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Guruswamy Basavaiah <guru2018@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33891 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756739AbcC2K6y (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Mar 2016 06:58:54 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 841974B0FC
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Mar 2016 12:58:52 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3F23DDA383
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Mar 2016 12:58:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id CDF3DDA394
	for <netfilter-devel@vger.kernel.org>; Tue, 29 Mar 2016 12:58:50 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160328190436.GA19755@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 29, 2016 at 12:34:36AM +0530, Guruswamy Basavaiah wrote:
> Initializing comment member in xt_xlate structure. 
> 
> Because of not initializing, when translating iptables command with multiple
> ip addresses, In the translated commands --comment field is getting added.
> 
> Before fix:
> inbhdhcp21574:basavaia$>sudo ./iptables-translate -A INPUT --source "40.0.0.1, 30.0.0.1" --dest "20.0.0.1, 60.0.0.1" -j ACCEPT
> nft add rule ip filter INPUT ip saddr 40.0.0.1 ip daddr 20.0.0.1 counter accept
> add rule ip filter INPUT ip saddr 40.0.0.1 ip daddr 60.0.0.1 counter comment \" \" accept
> add rule ip filter INPUT ip saddr 30.0.0.1 ip daddr 20.0.0.1 counter comment \" \" accept
> add rule ip filter INPUT ip saddr 30.0.0.1 ip daddr 60.0.0.1 counter comment \" \" accept

Thanks, I already pushed something similar yesterday.

http://git.netfilter.org/iptables/commit/?id=c93850d1d78c7040709d78aee5514c5c5035c4ab
