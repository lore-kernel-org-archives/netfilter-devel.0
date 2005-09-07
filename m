From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [NETFILTER 2/8]: Add NetBIOS name service helper
Date: Tue, 06 Sep 2005 19:56:49 -0700 (PDT)
Message-ID: <20050906.195649.54560179.davem@davemloft.net>
References: <431DD813.8010309@trash.net> <431DDB7C.3010503@trash.net>
	<m2slwh617b.fsf@cerbere.dyndns.info>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: sbellabes@mandriva.com
In-Reply-To: <m2slwh617b.fsf@cerbere.dyndns.info>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

From: Samir Bellabes <sbellabes@mandriva.com>
Subject: Re: [NETFILTER 2/8]: Add NetBIOS name service helper
Date: Wed, 07 Sep 2005 04:50:16 +0200

> [NETFILTER] Return NF_DROP if expectation failed for Netbios conntrack
> 
> Fix the returned value when it's not possible to allocate expectation
> or if ip_conntrack_expect_related() failed.
> 
> Signed-off-by: Samir Bellabes <sbellabes@mandriva.com>

Patrick, I've applied this, I hope you don't mind :)
