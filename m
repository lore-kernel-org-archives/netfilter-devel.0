From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Any way of knowing a packet's been defragmented
Date: Thu, 5 Aug 2004 09:55:36 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0408050953440.30895@filer.marasystems.com>
References: <200408042254.41978.bdschuym@pandora.be>
 <Pine.LNX.4.44.0408042300540.18907-100000@filer.marasystems.com>
 <33159.199.107.159.238.1091683285.squirrel@www.osdl.org>
 <200408050812.45887.bdschuym@pandora.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: shemminger@osdl.org, netfilter-devel <netfilter-devel@lists.netfilter.org>,
   bridge <bridge@osdl.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
In-Reply-To: <200408050812.45887.bdschuym@pandora.be>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 5 Aug 2004, Bart De Schuymer wrote:

> It has nothing to do with ebtables. It's all about connection tracking of ipv4
> packets on a transparent bridging firewall. Ct defragments packets, on the
> ipv4 PREROUTING hook, because it makes things easier. Ct on a transparent
> bridge is something people need.

The question on why the bridge needs to drop oversized fragments instead 
of simply letting iptables fragment them remains...

Regards
Henrik
