From: "Samuel Jean" <sj-netfilter@cookinglinux.org>
Subject: Re: SNAT multicast traffic
Date: Wed, 9 Feb 2005 08:55:43 -0500 (EST)
Message-ID: <26663.142.169.215.10.1107957343.squirrel@142.169.215.10>
References: <420882B9.3050108@inwind.it>
	<20050208144638.GQ6878@sunbeam.de.gnumonks.org>
	<4208C405.9020907@inwind.it>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
In-Reply-To: <4208C405.9020907@inwind.it>
To: "Paolo Rossi" <paolo_76@inwind.it>
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

On Tue, February 8, 2005 8:52 am, Paolo Rossi said:

> Is it possible to perform stateless nat in Linux ?

No, the NAT subsystem works on the behalf of conntrack subsystem.
There's no NAT without conntrack.

Also, once the conntrack knows the NAT action for a particular
tuple; the packet doesn't hit PREROUTING of nat table anymore.

HTH,
Samuel
