From: "David S. Miller" <davem@davemloft.net>
Subject: Re: Can be done? reodering and delay SCTP packages?
Date: Thu, 24 Mar 2005 14:09:44 -0800
Message-ID: <20050324140944.303e3f48.davem@davemloft.net>
References: <33837.200.127.126.201.1111701629.squirrel@200.127.126.201>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, jkriger@cwazy.co.uk
To: jkriger@hotpop.com
In-Reply-To: <33837.200.127.126.201.1111701629.squirrel@200.127.126.201>
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


Have a look at the network emulator packet scheduler (sch_netem.c),
you don't need netfilter to do what you want.
