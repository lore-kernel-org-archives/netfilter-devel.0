From: Francesco Ciocchetti <primero@fastwebnet.it>
Subject: Re: libiptc ... and matches , seg fault
Date: Fri, 15 Jul 2005 11:57:23 +0200
Message-ID: <42D78883.9010008@fastwebnet.it>
References: <42D6AD2C.5070304@fastwebnet.it>	<Pine.LNX.4.63.0507142117170.29183@localhost.localdomain>	<42D76E84.7080906@fastwebnet.it>	<Pine.LNX.4.61.0507151008050.20435@yvahk01.tjqt.qr>	<42D77F23.80403@fastwebnet.it>
	<Pine.LNX.4.63.0507151142180.29785@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: =?windows-1252?Q?Tom=E1=B9_Macek?= <maca02@atlas.cz>
In-Reply-To: <Pine.LNX.4.63.0507151142180.29785@localhost.localdomain>
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

Tom=E1=9A Macek wrote:

> The strcmp() function will try to compare/get the 0x0 memory pointed
> by the me->version pointer and this (in the strcmp() function) raises
> the sigseg error.


Yes :)

> You could try this:
>
> if (me->version !=3D NULL && strcmp(me->version, program_version) !=3D =
0) {
> ...
> }
>
> If the first condition "if (me->version !=3D NULL)" failes, the rest
> will be not processed.
>
My problem is that the "register_match" function is not a function of my
program, but a function from iptables.c that is called by init function
in libipt_tcp.c ... what i'm wondering now is why my "me->version" could
be or is NULL or maybe program_version could be NULL too.

this is the extract from libipt_tcp.c

static
struct iptables_match tcp
=3D { NULL,
"tcp",
IPTABLES_VERSION,
IPT_ALIGN(sizeof(struct ipt_tcp)),
IPT_ALIGN(sizeof(struct ipt_tcp)),
&help,
&init,
&parse,
&final_check,
&print,
&save,
opts };

void
_init(void)
{
register_match(&tcp);
}



so it seems that the field version of tcp structure is filled, at
compilation time, by IPTABLES_VERSION ...

what i do in my program is just a call to

find_match("tcp",TRY_LOAD,&matches)

where matches is just :

struct iptables_rule_match *matches =3D NULL;


as is done in iptables.c ...



bye
Francesco
