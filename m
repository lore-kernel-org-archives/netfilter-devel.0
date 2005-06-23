From: Patrick McHardy <kaber@trash.net>
Subject: Re: Status of Netfilter IPSEC patches
Date: Thu, 23 Jun 2005 17:06:22 +0200
Message-ID: <42BACFEE.3020801@trash.net>
References: <42289633.6020804@sysgo.com> <424853B8.9090607@shorewall.net>
	<42485FD2.3020508@trash.net> <42BACCD1.8030403@anduras.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Sven Anders <anders@anduras.de>
In-Reply-To: <42BACCD1.8030403@anduras.de>
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

Sven Anders wrote:
> | Patrick McHardy wrote:
> |
> | Read last weeks netdev archive, turns out the whole idea of skipping
> | netfilter hooks until all IPsec processing is done was wrong. I don't
> | know how to solve it yet.
> 
> Any details about this?
> What problems can arise?

Raw sockets can have policies that allow them to receive packets
in intermediate states. Skipping the hooks on input until the
packet are entirely decrypted makes filtering before these sockets
impossible and is inconsistent with the way filtering can usually
be done.

It seems the only thing that would work is taking the opposite approach,
pass the packets through LOCAL_OUT/POST_ROUTING for each transform on
output and don't skip on input. For filtering in transport mode this
means we need to pass a packet through the stack for each transform on
input, not just for tunnel mode.

> I downloaded the latest patch-o-matic and looked at the state of the
> patches,
> but these are out-of-date. Are these patches unmaintained due to the
> statement
> above?

Yes.

> There are newer ones under:
> ~  http://www.saout.de/misc/linux-2.6.12-ipsec-nat/
> Please update the patches in the patch-o-matic!

If someone sends me a patch for svn I'll apply it.

Regards
Patrick
