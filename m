From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: TC kernel module
Date: Wed, 14 Jul 2004 17:11:57 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0407141706180.17283-100000@filer.marasystems.com>
References: <1089816302.2782.12.camel@khocegas>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: =?ISO-8859-1?Q?S=EDlvia?= Andreia Oliveira Rocha <srocha@ncc.up.pt>
In-Reply-To: <1089816302.2782.12.camel@khocegas>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 14 Jul 2004, S=EDlvia Andreia Oliveira Rocha wrote:

> Is there a way to find out how the TC module is configured?

There is plenty of documentation on the Linux Traffic Control subsystem.=20
It is far more than "a module". See the Linux Traffic Control HOWTO for a=
=20
good start.

> Is it possible to have no TC action? That is ... is it possible for a
> kernel not to do Traffic Control? Is the the default behavior?

See the CLASSIFY or MARK targets. Both can be used to send instructions t=
o=20
the Traffic Control subsytem from iptables. The concepts involved is=20
explained in the above mentioned document.

Regards
Henrik
