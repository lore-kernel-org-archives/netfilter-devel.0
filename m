From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Changing packet data
Date: Sun, 18 Apr 2004 10:58:37 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0404181046310.4242-100000@filer.marasystems.com>
References: <20040417123252.GA22087@pandora.barbara.eu.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Piotr =?iso-8859-2?Q?Gasid=B3o?= <quaker@pandora.barbara.eu.org>
In-Reply-To: <20040417123252.GA22087@pandora.barbara.eu.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, 17 Apr 2004, Piotr [iso-8859-2] Gasid=B3o wrote:

> I'm trying to develop match which is able to change packet data
> according to perl regular expression, s/.../.../. Finding match is very
> easy. But I'm stuck in replacing it. One thing that bothers me it's how
> to resize packet (replacement can be shorter or taller than match) in
> match() function.

Unless you are doing this in the context of NAT you can only resize UDP
(and other datagram protocols), not TCP. For TCP you need to have the=20
sequence numbers adjusted for all future of the connection if you modify=20
the size of the payload and this function is only available in=20
iptables/netfilter if NAT is enabled.

In NAT this type of manipulation is done in the form of a NAT helper.
There the framework is already fully in place for doing this kind of
things.

Maybe it works using the same framework elsewhere in iptables. See the FT=
P=20
NAT helper for some samples and give it a try. Do not forget locking.

Regards
Henrik
