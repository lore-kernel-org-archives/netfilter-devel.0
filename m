From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Entry point
Date: Fri, 28 May 2004 10:31:24 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0405281027240.28317-100000@filer.marasystems.com>
References: <20040527165420.M91799@linkexpress.com.br>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: =?ISO-8859-1?Q?Daniel_Corr=EAa_de_A?=zevedo <nielca@linkexpress.com.br>
In-Reply-To: <20040527165420.M91799@linkexpress.com.br>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 27 May 2004, Daniel Corr=EAa de Azevedo wrote:

>    I wonder if you guys could point me where should I place some code i=
nto=20
> iptables that should fire an event whenever any rule or chain is add,=20
> edited, or removed. I mean, is there any function that commits changes =
like=20
> the "iptc_commit" from libiptc?

The kernel operates on iptables, not individual rules.

In the official API there is the check function of each match/target. Thi=
s=20
is useful if you need to prepare something before your match/target is=20
activated. It can also be used as a psuedo-trigger on loading new=20
rulesets by using a dummy rule with your special target acting as "on=20
change" trigger.

If you want to do it by hacking the iptables core code then see the
do_replace function in ip_tables.c.

Regards
Henrik
