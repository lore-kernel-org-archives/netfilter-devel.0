From: Rusty Russell <rusty@rustcorp.com.au>
Subject: [Fwd: ipt_connlimit.c from pom-ng contains error]
Date: Wed, 16 Feb 2005 18:27:09 +1100
Message-ID: <1108538829.13398.8.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-5
Content-Transfer-Encoding: quoted-printable
To: Netfilter development mailing list <netfilter-devel@lists.netfilter.org>
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

-------- Forwarded Message --------
From: Zharovtsev, Anton <warm@stack.ru>
To: rusty@rustcorp.com.au
Subject: ipt_connlimit.c from pom-ng contains error
Date: Wed, 16 Feb 2005 13:02:25 +0600
Hello.

I am sorry for writing this letter directly to You and not to the mail li=
st.
I have no time to subcribe and so on ...


This is from 2.4 linux/netfilter_ipv4/ip_conntrack.h:

        /* Our various nf_ct_info structs specify *what* relation this
           packet has to the conntrack */
        struct nf_ct_info infos[IP_CT_NUMBER];

There is no description of such member of struct ip_conntrack in the 2.6 =
same file ( linux/netfilter_ipv4/ip_conntrack.h )

I am not a programmer, I only applied pom-ng for 2005-02-14 date onto 2.6=
.10 kernel and I got error:

  CC [M]  net/ipv4/netfilter/ipt_connlimit.o
net/ipv4/netfilter/ipt_connlimit.c: In function `count_them':
net/ipv4/netfilter/ipt_connlimit.c:100: error: structure has no member na=
med `infos'
net/ipv4/netfilter/ipt_connlimit.c:107: error: structure has no member na=
med `infos'
make[3]: *** [net/ipv4/netfilter/ipt_connlimit.o] =BE=E8=D8=D1=DA=D0 1
make[2]: *** [net/ipv4/netfilter] Error 2
make[1]: *** [net/ipv4] Error 2
make: *** [net] Error 2
root@wasp:/usr/src/linux#

I will turn off this module, but I think it is very usefull for many peop=
les and.
This letter is my small bug report :-).

Sorry again.
--=20
A bad analogy is like a leaky screwdriver -- Richard Braakman
