From: Patrick Schaaf <bof@bof.de>
Subject: Re: LAND check: 2.4.20
Date: Wed, 16 Mar 2005 07:29:35 +0100
Message-ID: <20050316062935.GA13567@oknodo.bof.de>
References: <BB6D74C75CC76A419B6D6FA7C38317B26A26DE@sinett-sbs.SiNett.LAN>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org,
	Cedric Blancher <blancher@cartel-securite.fr>, Martijn Lievaart <m@rtij.nl>
To: Vishwas Manral <Vishwas@sinett.com>
Content-Disposition: inline
In-Reply-To: <BB6D74C75CC76A419B6D6FA7C38317B26A26DE@sinett-sbs.SiNett.LAN>
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

> 3. I am not sure which routing code checks for Source IP Address? Can you point me to some code (destroy it as a packet with local IP as source must be received on loopback)?

net/ipv4/fib_frontend.c, function fib_validate_source().

The logic will be: destroy it because the route back to that source IP
resolves to destination device lo, and not the device the packet came from.

> The solution as done by most firewalls is to add a simple check in the check_tcp and check_udp. I think we need to add this to the iptables code.

No, we don't.

best regards
  Patrick
