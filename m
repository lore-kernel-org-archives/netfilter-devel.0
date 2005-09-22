From: "Vincent" <cs83152@csie.chu.edu.tw>
Subject: RE: IPT_RETURN is not worked in the kernel 2.6.10
Date: Thu, 22 Sep 2005 13:34:37 +0800
Message-ID: <007001c5bf37$55629e00$aa0ba8c0@l7.com.tw>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
In-Reply-To: 
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

Sorry, after understanding the meaning of ipt_do_table function. I know
currently the IPT_RETURN is only available in the standard target.=20
But I wonder why don't we have the IPT_RETURN in the user defined
target?=20
Can we create a IPT_RETURN in the user defined target. So that we can
use the IPT_RETURN in our target to return to the upper chain.

What I mean is "can we port the IPT_RETURN to the user defined target in
the ipt_do_table function?"

Vincent

> -----Original Message-----
> From: Vincent [mailto:cs83152@csie.chu.edu.tw]
> Sent: Tuesday, September 20, 2005 4:56 PM
> To: 'netfilter-devel@lists.netfilter.org'
> Subject: IPT_RETURN is not worked in the kernel 2.6.10
>=20
>=20
> Hello folks,
>=20
> I am currently writing a iptables target. And I want to use
> the IPT_RETURN as the return value from target. But I found=20
> that IPT_RETURN will result as NF_ACCEPT does. What I mean=20
> is, while I use IPT_RETURN in my target module. It will not=20
> go back to the upper directory. Does anyone ever experience=20
> the same problem?
>=20
> Enviroment:
> linux kernel 2.6.10
> Iptables 1.2.9
>=20
> Vincent
>=20
> The following code is part of the ipt_do_table in the
> ip_tables.c But I don=A1=A6t know how to modify it to fix the bug? :(
>=20
>             if (!t->u.kernel.target->target) {
>                 int v;
>=20
>                 v =3D ((struct ipt_standard_target *)t)->verdict;
>                 if (v < 0) {
>                     /* Pop from stack? */
>                     if (v !=3D IPT_RETURN) {
>                         verdict =3D (unsigned)(-v) - 1;
>                         break;
>                     }
>                     e =3D back;
>                     back =3D get_entry(table_base,
>                              back->comefrom);
>                     continue;
>                 }
>=20
