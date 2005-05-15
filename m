From: Tobias DiPasquale <codeslinger@gmail.com>
Subject: Re: QUEUE target and IPT_CONTINUE verdict ?
Date: Sun, 15 May 2005 18:12:13 -0400
Message-ID: <876ef97a05051515127fbbf066@mail.gmail.com>
References: <200505131729.39430.laurent.guyon@adelux.fr>
	<876ef97a05051510053c6827c2@mail.gmail.com>
	<Pine.LNX.4.61.0505152244290.28907@filer.marasystems.com>
Reply-To: Tobias DiPasquale <codeslinger@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: Laurent Guyon <laurent.guyon@adelux.fr>,
	nf-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.61.0505152244290.28907@filer.marasystems.com>
Content-Disposition: inline
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

On 5/15/05, Henrik Nordstrom <hno@marasystems.com> wrote:
> -j QUEUE
>=20
> makes iptables return the IPT_QUEUE verdict to the netfilter kernel, whic=
h
> then sends this to the queue handler (normally ip_queue with it's netlink
> socket). On reinject netfilter continues on the next hook handler of the
> same hook, or returns the packet to the kernel if there is no more
> handlers on this hook.

Is this also the reason that there can be only one ip_queue handler at a ti=
me?

--=20
[ Tobias DiPasquale ]
0x636f6465736c696e67657240676d61696c2e636f6d
