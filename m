From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Problems with iptables 1.2.9 - iptables: Loop found in table
Date: Fri, 12 Dec 2003 00:07:23 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0312120005390.4649-100000@filer.marasystems.com>
References: <20031211164749.GA11985@moon.ondraszek.ds.polsl.gliwice.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Piotr =?iso-8859-2?Q?Gasid=B3o?= <quaker@ondraszek.eu.org>
In-Reply-To: <20031211164749.GA11985@moon.ondraszek.ds.polsl.gliwice.pl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 11 Dec 2003, Piotr [iso-8859-2] Gasid=B3o wrote:

> # iptables -I INPUT -s 1.1.1.1
> iptables: Loop found in table
>=20
> Already applied: submitted/01_2.4.19
>                  extra/TRACE


Did you remember to rebuild your iptables binary using the correct kernel
headers? The extra/TRACE patch makes core changes requiring a new iptable=
s
binary to be built in order to be able to insert any rules..

Regards
Henrik
