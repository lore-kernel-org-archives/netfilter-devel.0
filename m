From: Thomas Heinz <creatix@hipac.org>
Subject: Re: [Fwd: ACCEPT/DROP]
Date: Wed, 25 Dec 2002 12:48:41 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E099B19.50705@hipac.org>
References: <Pine.LNX.4.44.0212241649520.27999-100000@el-zoido.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Patrick

You wrote:
> This may be true for code, but iptables rules describe sets of packets

This is true for the basic cases only. In general the matches of a rule
must be considered to be arbitrary packet action (ACCEPT, DROP,
CONTINUE) returning functions that may even return different actions for
the same packet. The only constraint for matches is that they should
work read-only on the packet content, i.e. not modify it.

Of course your statement is correct in the context of the classical
packet classification problem.


Thomas
