From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: Any way of knowing a packet's been defragmented
Date: Thu, 5 Aug 2004 08:12:45 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200408050812.45887.bdschuym@pandora.be>
References: <200408042254.41978.bdschuym@pandora.be> <Pine.LNX.4.44.0408042300540.18907-100000@filer.marasystems.com> <33159.199.107.159.238.1091683285.squirrel@www.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: "netfilter-devel" <netfilter-devel@lists.netfilter.org>,
	"bridge" <bridge@osdl.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: shemminger@osdl.org, "Henrik Nordstrom" <hno@marasystems.com>
In-Reply-To: <33159.199.107.159.238.1091683285.squirrel@www.osdl.org>
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

On Thursday 05 August 2004 07:21, shemminger@osdl.org wrote:
> > Well.. iptables does not really care why the packet is oversized. It
> > fragments any oversized packets.
> >
> > Why does the bridge need to?
>
> The bridge doesn't even know it's IP.  The there appears to be some
> ebtables code path that defragments packets, and in the process can
> decide to send a skb greater than the MTU of the device. Because of
> recent changes to allow bridging of an MTU size (previous limit was always
> 1500), the bridge now drops skb if skb->len > dev->mtu.
>
> Perhaps the problem is that ebtables filter is defragments because it
> is looking at the mtu of the incoming interface?

It has nothing to do with ebtables. It's all about connection tracking of ipv4 
packets on a transparent bridging firewall. Ct defragments packets, on the 
ipv4 PREROUTING hook, because it makes things easier. Ct on a transparent 
bridge is something people need.

cheers,
Bart
