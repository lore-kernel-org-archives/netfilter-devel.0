From: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Subject: Re: [iptables-nftables PATCH 3/5] nft: nft_xtables_config_load()
 called only in nft_init()
Date: Mon, 29 Jul 2013 09:14:16 +0300
Message-ID: <51F60838.5070208@linux.intel.com>
References: <1374836719-27596-1-git-send-email-giuseppelng@gmail.com> <1374836719-27596-3-git-send-email-giuseppelng@gmail.com> <20130726145902.GA28833@localhost> <CAFpD06Q8JTHwAqiVFLb7p9v=eWUN_Y4bgAJm5D7b3f1D0T4aNg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:48324 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752912Ab3G2GOU (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Jul 2013 02:14:20 -0400
In-Reply-To: <CAFpD06Q8JTHwAqiVFLb7p9v=eWUN_Y4bgAJm5D7b3f1D0T4aNg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Giuseppe,

> The idea is to initialize nft_handle h without nft_init and after load
> the file, otherwise using nft_init the file is load 2 times. (First in
> nft_init and after with nft_xtables_config_load).

Indeed, and if given filename is different than default one then it's 
worse yes, you load the default one and the given one.

Tomasz
