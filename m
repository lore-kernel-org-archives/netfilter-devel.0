From: "Vincent" <cs83152@csie.chu.edu.tw>
Subject: IPT_RETURN is not worked in the kernel 2.6.10
Date: Tue, 20 Sep 2005 16:56:12 +0800
Message-ID: <000501c5bdc1$2a432b30$aa0ba8c0@l7.com.tw>
References: <1127181124.29021.34.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="big5"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
In-Reply-To: <1127181124.29021.34.camel@localhost>
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

Hello folks,

I am currently writing a iptables target. And I want to use the
IPT_RETURN as the return value from target.
But I found that IPT_RETURN will result as NF_ACCEPT does. What I mean
is, while I use IPT_RETURN in my target module.
It will not go back to the upper directory. Does anyone ever experience
the same problem?

Enviroment:=20
linux kernel 2.6.10
Iptables 1.2.9

Vincent

The following code is part of the ipt_do_table in the ip_tables.c
But I don=A1=A6t know how to modify it to fix the bug? :(

            if (!t->u.kernel.target->target) {
                int v;

                v =3D ((struct ipt_standard_target *)t)->verdict;
                if (v < 0) {
                    /* Pop from stack? */
                    if (v !=3D IPT_RETURN) {
                        verdict =3D (unsigned)(-v) - 1;
                        break;
                    }
                    e =3D back;
                    back =3D get_entry(table_base,
                             back->comefrom);
                    continue;
                }
