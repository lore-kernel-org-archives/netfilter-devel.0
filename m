From: Tomasz =?utf-8?q?Pr=C3=B3chniak?= <develop@tstd.pl>
Subject: libnetfilter_conntrack and port of router
Date: Mon, 9 Jan 2006 12:30:55 +0100
Message-ID: <200601091230.55167.develop@tstd.pl>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

Hi

=46irst sorry about my English.

I have a important (to me) question.

I have 2.6.14-5 kernel and libnetfilter_conntrack-0.0.28/ and=20
libnfnetlink-0.0.13/

i do not know how to get info about nat (port and ip, witch it will be seen=
 in=20
net)

example: =20
10.0.0.10:8888 ---------->10.0.0.1||88.88.88.88:3333--------->1111:22.22.22=
=2E22
my comp after nat            my router                         comp in net =
 =20


im intrasted about 88.88.88.88 and port 3333

i have struct=20
struct nfct_conntrack {
        struct nfct_tuple tuple[NFCT_DIR_MAX];

        u_int32_t       timeout;
        u_int32_t       mark;
        u_int32_t       status;
        u_int32_t       use;
        u_int32_t       id;

        union nfct_protoinfo protoinfo;
        struct nfct_counters counters[NFCT_DIR_MAX];
        struct nfct_nat nat;       //does this info should be in this struc=
t??
};

but this struct=20
struct nfct_nat {
        u_int32_t min_ip, max_ip;
        union nfct_l4 l4min, l4max;
};

if filled with 0 :(

pleas help me=20

thanks Kornik




=2D-=20
Myli=C4=87 si=C4=99 jest rzecz=C4=85 ludzk=C4=85,
ale =C5=BCeby naprawd=C4=99 co=C5=9B spapra=C4=87
=C2=A0potrzeba komputera.

Edward Morgan Forster
