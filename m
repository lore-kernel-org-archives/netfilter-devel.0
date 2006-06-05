From: Patrick Schaaf <bof@bof.de>
Subject: Re: POSTROUTING hooks
Date: Mon, 5 Jun 2006 19:25:17 +0200
Message-ID: <20060605172517.GF8333@oknodo.bof.de>
References: <0633E0EDB4F25F43A2D7179CA11FAFAB255453@xavier.staff.greatlakes.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick Schaaf <bof@bof.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Eliot, Wireless and Server Administrator,
	Great Lakes Internet" <support8@greatlakes.net>
Content-Disposition: inline
In-Reply-To: <0633E0EDB4F25F43A2D7179CA11FAFAB255453@xavier.staff.greatlakes.net>
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

> So, given that the kernel keeps a mapping of the IP->MAC and the packet
> contains the destination IP, why can't we just look up the destination
> MAC for that IP in the kernel table, if it exists.

I think that's what destination MAC matching did, before it was removed.

If I remember correctly, ARP stuff happens in a sufficiently different
locking context from iptables processing, so nobody wanted to (could sanely)
maintain an external access to the ARP structures just for the sake of a
destination MAC iptables match.

Maybe I misremember. Corrections welcome.

best regards
  Patrick
