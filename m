From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [PATCH] Fix ip_queue for bridged packets
Date: Wed, 29 Oct 2003 23:25:44 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200310292325.44927.bdschuym@pandora.be>
References: <200310251709.13913.bdschuym@pandora.be> <200310280002.12023.bdschuym@pandora.be> <20031028065610.499a5b01.davem@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "David S. Miller" <davem@redhat.com>
In-Reply-To: <20031028065610.499a5b01.davem@redhat.com>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tuesday 28 October 2003 15:56, David S. Miller wrote:
> Ok, there are other parts of netfilter (both ipv4 and ipv6) that
> call skb_copy_expand() like this and I suspect we'll be copying
> this bridging hack over to those places as well.  Not good.

Note that bridged ipv6 is currently not seen by iptables6.

> skb_copy_expand() is not exactly a fast path, so let's just make
> it copy the header area too.
>
> Bart, does this fix your bug too?  Please test it, thanks.

It fixes the bug.

Thanks,
Bart
