From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 2.6.15.4 1/1][RFC] ipt_owner: inode match supporting both
 incoming and outgoing packets
Date: Mon, 20 Feb 2006 17:42:21 +0100
Message-ID: <43F9F16D.4060802@trash.net>
References: <200602181410.59757.edwin.torok@level7.ro>
	<Pine.LNX.4.64.0602201122330.21034@excalibur.intercode>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: martinmaurer@gmx.at, netfilter-devel@lists.netfilter.org,
	fireflier-devel@lists.sourceforge.net,
	=?ISO-8859-1?Q?T=F6r=F6k_Edwin?= <edwin.torok@level7.ro>,
	linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: James Morris <jmorris@namei.org>
In-Reply-To: <Pine.LNX.4.64.0602201122330.21034@excalibur.intercode>
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

James Morris wrote:
> Have a look at my skfilter patches:
> http://people.redhat.com/jmorris/selinux/skfilter/kernel/
> 
> These implement a scheme for matching incoming packets against sockets by 
> adding a new hook in the socket layer.
> 
> For upstream merge, the issues are:
> - should the new socket hook be used for all incoming packets?
> - ensure IP queuing still works
> 
> Patrick: any other issues?

Confirmation of conntrack entries. They shouldn't be confirmed before
packets have passed the socket hooks. This is the tricky part because
we don't know if packets will be delivered to a raw socket or not
when calling the regular LOCAL_IN hook. The only way to solve this
seems to be to use the socket hooks for all incoming packets, that
way we can defer confirmation unconditionally. The nicest way would
be to just move the regular LOCAL_IN hook to the socket hooks, but
this doesn't work with SNAT in LOCAL_IN because the socket lookup
needs the already NATed address.

I'll probably continue to work on this soon unless someone beats
me to the punch.
