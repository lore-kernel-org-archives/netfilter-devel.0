From: Patrick McHardy <kaber@trash.net>
Subject: Re: Typo's in ip_conntrack_rpc_tcp.c ....
Date: Sat, 19 Jun 2004 22:33:44 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40D4A328.5070608@trash.net>
References: <200406181606.35340.mark@vevers.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: mark@vevers.net
In-Reply-To: <200406181606.35340.mark@vevers.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Mark Vevers wrote:

> In the init for ip_conntrack_rpc_tcp the code sets the ports for
> 
>   rpc_helpers[port].mask.dst.u.udp.port = htons(0x0);
> 
> with
>   rpc_helpers[port].tuple.dst.protonum = IPPROTO_TCP;

Patch applied, thanks.

Regards
Patrick
