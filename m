From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: NAT question
Date: Wed, 30 Jun 2004 16:21:46 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0406301620200.10756-100000@filer.marasystems.com>
References: <20040630132511.BC8004C079@spy10.spymac.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Kiran Kumar Immidi <immidi@spymac.com>
In-Reply-To: <20040630132511.BC8004C079@spy10.spymac.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 30 Jun 2004, Kiran Kumar Immidi wrote:

> Suppose I have connections=A0from A and B (both with coincidentally the=
 same local port, say 3000),
> both connecting to the same dest ip, port (say D:80). Now both are SNAT=
ted at C. Firstly, Is this possible?

Yes, but one of them will be assigned another local port after the SNAT=20
(SNAT gateway <-> web server)

> Then how about ICMP, suppose A and B send ICMP echo request to a machin=
e D, and the
> requests are NATted at C, the reply in both cases would be from D to C.=
 Then would this be
> allowed?

There is magics with the request number for these. Is in all aspects=20
similar to the port number of TCP/UDP except that there is only one (not=20
source+destinattion).

Regards
Henrik
