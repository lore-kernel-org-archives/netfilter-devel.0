From: shemminger@osdl.org
Subject: Re: Any way of knowing a packet's been defragmented
Date: Wed, 4 Aug 2004 22:21:25 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <33159.199.107.159.238.1091683285.squirrel@www.osdl.org>
References: <200408042254.41978.bdschuym@pandora.be>
    <Pine.LNX.4.44.0408042300540.18907-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: "Bart De Schuymer" <bdschuym@pandora.be>,
   "netfilter-devel" <netfilter-devel@lists.netfilter.org>,
   "bridge" <bridge@osdl.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.44.0408042300540.18907-100000@filer.marasystems.com>
To: "Henrik Nordstrom" <hno@marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> On Wed, 4 Aug 2004, Bart De Schuymer wrote:
>
>> Due to a recent change in the bridge code, we now need a way of knowing
>> if
>> a packet has been defragmented. The bridge code now checks on the packet
>> size and drops packets that are too big for the output port.
>> Defragmented
>> packets will get refragmented later, so they shouldn't be dropped.
>
> Well.. iptables does not really care why the packet is oversized. It
> fragments any oversized packets.
>
> Why does the bridge need to?
>

The bridge doesn't even know it's IP.  The there appears to be some
ebtables code path that defragments packets, and in the process can
decide to send a skb greater than the MTU of the device. Because of
recent changes to allow bridging of an MTU size (previous limit was always
1500), the bridge now drops skb if skb->len > dev->mtu.

Perhaps the problem is that ebtables filter is defragments because it
is looking at the mtu of the incoming interface?
