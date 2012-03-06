From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH 1/6] netfilter: ebtables: fix wrong name length while
 copying to user-space
Date: Tue, 06 Mar 2012 15:15:10 -0500 (EST)
Message-ID: <20120306.151510.2151198631476043192.davem@davemloft.net>
References: <1331032975-5303-1-git-send-email-pablo@netfilter.org>
	<1331032975-5303-2-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <1331032975-5303-2-git-send-email-pablo@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: pablo@netfilter.org
Date: Tue,  6 Mar 2012 12:22:50 +0100

> From: Santosh Nayak <santoshprasadnayak@gmail.com>
> 
> user-space ebtables expects 32 bytes-long names, but xt_match names
> use 29 bytes. We have to copy less 29 bytes and then, make sure we
> fill the remaining bytes with zeroes.
> 
> Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Applied.
