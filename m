From: Rolf Wuerdemann <rowue@digitalis.org>
Subject: Re: iptables accounting and promiscuous mode
Date: Sun, 24 Nov 2002 15:04:31 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3DE0DC6F.7572F71F@digitalis.org>
References: <3DDD2101.3030006@smidl.cz>
Reply-To: rowue@digitalis.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jakub Urban <jakub.urban@smidl.cz>, netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Jakub Urban schrieb:
> =

> hi all

Hi Jakob ...
> =

> it's posible to use iptables for passive IP accounting on linux box wit=
h
> one NIC sets to promisc mode?
> if yes - which version?
> if no - is this feature plan to the future?

As far as i know it isn't possible to do nettfilter-based-accounting
with
an NIC in Promisc mode - it's based on the fact that you have to route =

packets to use netfilter (otherwise netfilter doesn't make sense ...)

On the other hand I've developed an Target for
netfilter-based-accounting
for our routers that is running stable since 2 1/2 Months, where =

I've permissions and will to release ;) (but I've to apply some patches
and to set up an cvs before)

If you want to get an "prerelease" - just mail me ;)

> =

> i cant't find any info in the docs, i only find patch for iptables-1.2.=
3
> on
> http://www.fokus.gmd.de/research/cc/glone/employees/sebastian.zander/pr=
ivate/netfilter.html
> =

> thanks
> jakub urban

regards

	Rolf W=FCrdemann
	Wieske's Crew KG

PS: perhaps I'll should set myself an "dead-line" to release, so it will
released
sometimes (and not in 23 years ;)
