From: Horacio =?iso-8859-1?Q?J=2E_Pe=F1a?= <horape@tinuviel.compendium.com.ar>
Subject: Re: what is blocking packets before netfilter?
Date: Mon, 7 Mar 2005 13:01:28 -0300
Message-ID: <20050307160127.GH30357@tinuviel.compendium.com.ar>
References: <20050305184715.GC29199@tinuviel.compendium.com.ar>
	<20050306172045.GA1165@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
To: Phil Oester <kernel@linuxace.com>
Content-Disposition: inline
In-Reply-To: <20050306172045.GA1165@linuxace.com>
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

> > What could be eating the packets? Shouldn't iptables see anything that =
comes to the interface?
> Impossible to answer without knowing if 10.5.0.1 is a local or remote IP.

Remote. Reformulating the question, what is there between the packet
hitting the eth driver and it hitting iptables that could block it. My
first thoughts were IP forwarding (if it would be disabled, packets to
non-local addresses should be blocked) and rp_filter (as the box's route
for the src address isn't that way)

What else is there between the eth driver and iptables INPUT ?

Thanks,
					HoraPe
---
Horacio J. Pe=F1a
horape@compendium.com.ar
horape@uninet.edu
