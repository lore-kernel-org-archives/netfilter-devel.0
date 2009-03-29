From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: Re: linux-next: Tree for March 27 (netfilter build error)
Date: Sun, 29 Mar 2009 16:27:52 +0400
Message-ID: <20090329122752.GF7255@localhost>
References: <20090328102852.GA7697@localhost> <49CEF882.5000005@oracle.com> <20090329064704.GA7255@localhost> <20090328.234739.26481917.davem@davemloft.net> <49CF62A2.6050803@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>, randy.dunlap@oracle.com,
	sfr@canb.auug.org.au, linux-next@vger.kernel.org,
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
	kaber@trash.net, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <49CF62A2.6050803@netfilter.org>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

[Pablo Neira Ayuso - Sun, Mar 29, 2009 at 01:59:30PM +0200]
... 
| I think that the patch attached is better since it removes the overhead
| of the IPv6 dependency, which is indeed too much for the use of one
| function. Thanks.
| 
...

It's definitely better! Thanks Pablo.

        Cyrill
