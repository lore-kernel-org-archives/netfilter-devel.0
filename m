From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch -mainline] netfilter: ipset: small potential read beyond
 the end of buffer
Date: Tue, 11 Nov 2014 01:38:06 +0300
Message-ID: <20141110223806.GB5351@mwanda>
References: <20141107062140.GA10905@mwanda>
 <20141110142446.GA29586@salvia>
 <alpine.DEB.2.10.1411101526480.2913@blackhole.kfki.hu>
 <20141110161121.GA7398@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Patrick McHardy <kaber@trash.net>,
	"David S. Miller" <davem@davemloft.net>,
	Sergey Popovich <popovich_sergei@mail.ru>,
	Masanari Iida <standby24x7@gmail.com>,
	Anton Danilov <littlesmilingcloud@gmail.com>,
	stephen hemminger <stephen@networkplumber.org>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernddel.org, kernel-janitors@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:41185 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751152AbaKJWjV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Nov 2014 17:39:21 -0500
Content-Disposition: inline
In-Reply-To: <20141110161121.GA7398@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 10, 2014 at 05:11:21PM +0100, Pablo Neira Ayuso wrote:

> OK, then does this look fine to you? I took over Dan's patch and gave
> it another spin. See it attached, thanks.

Looks good to me, thanks.

regards,
dan carpenter

