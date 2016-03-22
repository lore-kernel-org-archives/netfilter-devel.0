From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v4] configure: Show support for connlabel
Date: Tue, 22 Mar 2016 19:34:58 +0100
Message-ID: <20160322183458.GA3232@salvia>
References: <20160322051306.GA9115@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35675 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750735AbcCVSfJ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Mar 2016 14:35:09 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 70877C1240
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Mar 2016 19:35:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 63BE9DA380
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Mar 2016 19:35:06 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id F370DDA385
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Mar 2016 19:35:03 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160322051306.GA9115@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 22, 2016 at 10:43:06AM +0530, Shivani Bhardwaj wrote:
> Add the --disable-connlabel option and the appropriate functionality
> associated with it.
> 
> After this patch, iptables configuration shows up as:
> 
> Iptables Configuration:
>   IPv4 support:                         yes
>   IPv6 support:                         yes
>   Devel support:                        yes
>   IPQ support:                          no
>   Large file support:                   yes
>   BPF utils support:                    no
>   nfsynproxy util support:              no
>   nftables support:                     yes
>   connlabel support:                    yes

Applied, thanks Shivani.
