From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [ANNOUNCE] Proceedings of Netfilter Developer Workshop 2004
Date: Mon, 27 Sep 2004 16:58:23 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0409271655070.18264@filer.marasystems.com>
References: <20040925213322.GJ3236@sunbeam.de.gnumonks.org>
	<20040927143116.GB18298@barbara.eu.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=X-UNKNOWN; format=flowed
Content-Transfer-Encoding: quoted-printable
Cc: lwn@lwn.net, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Piotr =?iso-8859-2?Q?Gasid=B3o?=
	<quaker@pandora.barbara.ds.polsl.gliwice.pl>
In-Reply-To: <20040927143116.GB18298@barbara.eu.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, 27 Sep 2004, Piotr [iso-8859-2] Gasid=B3o wrote:

> Target is useful when using MASQUERADE or SNAT. Using tc we are *unable=
*
> to put outgoing trafic from single IP (behind masquerade) into queue
> created on outgoing interface. With this target we can mark packets fro=
m
> each internal IP and then, using tc filter fw put it into queues. This
> target replaces many MARK rules, which can be really CPU hog.

How I think this should be addressed is via tc filter which looks into=20
conntrack to find the original addresses before NAT. See the conntrack=20
match for clues.

Another approach would be to use the CLASSIFY target instead of tc=20
filters.

Regards
Henrik
