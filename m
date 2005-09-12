From: Gervasio Bernal <gervasiobernal@speedy.com.ar>
Subject: Re: New target: can't delete rule
Date: Mon, 12 Sep 2005 19:23:36 +0000
Message-ID: <1126553016.15667.0.camel@Pentium>
References: <1126116594.3690.35.camel@Pentium> <431F6A0E.1090707@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-reply-to: <431F6A0E.1090707@eurodev.net>
To: Pablo Neira <pablo@eurodev.net>
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

El mi=C3=A9, 07-09-2005 a las 22:30, Pablo Neira escribi=C3=B3:
> Gervasio Bernal wrote:
> > I'm from Argentina and I'm developing a new target for iptables with a
> > college friend. This new target uses the Linux Cryptographic API.
> >=20
> > We are debbuging the new extension and we noticed a rare behavior.=20
> > First we inserted the rule like this:
> > #iptables -t mangle -A INPUT -s xxx.xxx.xxx.xxx -j NEW --param hello
> > And we don't have problems.=20
> >=20
> > The problem appears when we tried to erase the rule:
> > #iptables -t mangle -D INPUT -s xxx.xxx.xxx.xxx -j NEW --param hello
> > It says: :-(
> > iptables: No chain/target/match by that name
> >=20
> > But, if we put this:
> > #iptables -t mangle -D INPUT 1
> > It erases correctly :-)
> >=20
> > Why it works with a method and not with the another one?
> > It can be because we allocating memory in checkentry function and
> > freeing it  in destroy function?
> > How can we correct this rare behavior?
>=20
> I bet that you have a pointer in the private info section of the target.=20
> See that iptables sets that pointer to NULL at rule creation.=20
> Afterwards, once checkentry() is called, such pointer won't be NULL anymo=
re.
>=20
> At removal, the rule built by iptables sets that pointer to NULL. Such=20
> rule will be compared with the ruleset hold in kernel space but no=20
> matches will be found since the pointers mismatch.
>=20
> This problem is well known and it's very easy to fix up (look for=20
> userspacesize and offsetof in iptables/extensions). See ipt_limit,=20
> ipt_CLUSTERIP...
>=20
> But it's *even* easier to figure out what's wrong with yout module if=20
> you post it here, in the mailing list.
>=20
> --
> Pablo
>=20

Pablo:=20
    I did what you said, but I cannot make walk it.=20

This is my libipt_CRYPT.c=20

static struct iptables_target CRYPT=20
=3D {=20
    .name            =3D "CRYPT",=20
    .version         =3D IPTABLES_VERSION,=20
    .size            =3D IPT_ALIGN(sizeof(struct ipt_CRYPT_info)),=20
    .userspacesize   =3D offsetof(struct ipt_CRYPT_info,
table_alloc_ptr),       =20
    .help            =3D &help,=20
    .init            =3D &init,=20
    .parse           =3D &parse,=20
    .final_check     =3D &final_check,=20
    .print           =3D &print,=20
    .save            =3D &save,=20
    .extra_opts      =3D opts=20
};=20


This is my ipt_CRYPT.h=20

struct ipt_CRYPT_info=20
{=20
        char key[MAX_KEY_SIZE];=20
        unsigned int block_size;=20
        unsigned int key_size;=20

        struct tabla_alloc* table_alloc_ptr;=20
};=20

struct tabla_alloc=20
{=20
        struct crypto_tfm *tfm;=20
        struct tabla_alloc* next;=20
        struct tabla_alloc* ant;=20
};=20

Greetings=20
