From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Any way of knowing a packet's been defragmented
Date: Wed, 4 Aug 2004 23:04:47 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0408042300540.18907-100000@filer.marasystems.com>
References: <200408042254.41978.bdschuym@pandora.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>,
   bridge <bridge@osdl.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
In-Reply-To: <200408042254.41978.bdschuym@pandora.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 4 Aug 2004, Bart De Schuymer wrote:

> Due to a recent change in the bridge code, we now need a way of knowing if
> a packet has been defragmented. The bridge code now checks on the packet
> size and drops packets that are too big for the output port. Defragmented
> packets will get refragmented later, so they shouldn't be dropped.

Well.. iptables does not really care why the packet is oversized. It
fragments any oversized packets.

Why does the bridge need to?

Regards
Henrik
