From: David Miller <davem@davemloft.net>
Subject: Re: [PATCH] netfilter: fix non-ANSI func. decl.
Date: Thu, 07 Dec 2006 01:17:40 -0800 (PST)
Message-ID: <20061207.011740.93626467.davem@davemloft.net>
References: <20061205193713.e6f106a3.randy.dunlap@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, netfilter-devel@lists.netfilter.org
Return-path: <netdev-owner@vger.kernel.org>
To: randy.dunlap@oracle.com
In-Reply-To: <20061205193713.e6f106a3.randy.dunlap@oracle.com>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>
Date: Tue, 5 Dec 2006 19:37:13 -0800

> From: Randy Dunlap <randy.dunlap@oracle.com>
> 
> Fix non-ANSI function declaration:
> net/netfilter/nf_conntrack_core.c:1096:25: warning: non-ANSI function declaration of function 'nf_conntrack_flush'
> 
> Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>

Applied, thanks Randy.
