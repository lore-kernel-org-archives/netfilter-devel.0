From: Tobias DiPasquale <codeslinger@gmail.com>
Subject: Re: 2.6.12: connection tracking broken?
Date: Sat, 18 Jun 2005 11:14:45 -0400
Message-ID: <876ef97a05061808141d503f58@mail.gmail.com>
References: <20050618124359.39052.qmail@web52901.mail.yahoo.com>
	<Pine.LNX.4.61.0506181656250.20828@yvahk01.tjqt.qr>
Reply-To: Tobias DiPasquale <codeslinger@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>, Chris Rankin <rankincj@yahoo.com>
In-Reply-To: <Pine.LNX.4.61.0506181656250.20828@yvahk01.tjqt.qr>
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

On 6/18/05, Jan Engelhardt <jengelh@linux01.gwdg.de> wrote:
> >I have just tried upgrading my firewall to 2.6.12, but neither of the fo=
llowing rules in my
> >FORWARD table was allowing return traffic:
>=20
> You forget about INPUT and OUTPUT. If you drop everything in INPUT, there=
's
> nothing to FORWARD.

No. INPUT/OUTPUT rules have nothing to do with FORWARDed traffic,
since a packet is either locally destined (INPUT), locally originated
(OUTPUT) or being forwarded (FORWARD).

> > 1109  814K ACCEPT     all  --  ppp0   br0     anywhere             anyw=
here         ctstate
> >RELATED,ESTABLISHED
> >  11M   13G ACCEPT     all  --  ppp0   br0     anywhere             anyw=
here         state
> >RELATED,ESTABLISHED
> >
> >I have currently returned to using 2.6.11.11, where the identical config=
uration works fine. br0 is
> >a bridge device containing two e100 devices, and ppp0 is my PPPoE DSL li=
nk. I am using iptables
> >1.3.1.

Did you have /proc/sys/net/ipv4/ip_forward turned on?

--=20
[ Tobias DiPasquale ]
0x636f6465736c696e67657240676d61696c2e636f6d
