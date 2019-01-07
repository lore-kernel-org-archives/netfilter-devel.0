From: Jacek <wampir990-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Apparmor netfiter support?
Date: Mon, 7 Jan 2019 11:16:13 +0100
Message-ID: <91b5b9f7-bb9a-29d9-bc72-b0077b885726@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============6395670286216889898=="
Cc: apparmor-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org
To: netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Return-path: <apparmor-bounces-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org>
List-Unsubscribe: <https://lists.ubuntu.com/mailman/options/apparmor>,
 <mailto:apparmor-request-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.ubuntu.com/archives/apparmor>
List-Post: <mailto:apparmor-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org>
List-Help: <mailto:apparmor-request-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org?subject=help>
List-Subscribe: <https://lists.ubuntu.com/mailman/listinfo/apparmor>,
 <mailto:apparmor-request-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org?subject=subscribe>
Errors-To: apparmor-bounces-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org
Sender: "AppArmor" <apparmor-bounces-nLRlyDuq1AZFpShjVBNYrg@public.gmane.org>
List-Id: netfilter-devel.vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--===============6395670286216889898==
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="tLQbqWky4mhSg4lF26wA7ujwkztV08f4G"

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--tLQbqWky4mhSg4lF26wA7ujwkztV08f4G
Content-Type: multipart/mixed; boundary="rAONKwYQwIyLBHeEQsN73BLpx1EiYRSt2";
 protected-headers="v1"
From: Jacek <wampir990-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
To: netfilter-devel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: apparmor-nLRlyDuq1AZFpShjVBNYruG/Ez6ZCGd0@public.gmane.org
Message-ID: <91b5b9f7-bb9a-29d9-bc72-b0077b885726-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Apparmor netfiter support?

--rAONKwYQwIyLBHeEQsN73BLpx1EiYRSt2
Content-Type: multipart/alternative;
 boundary="------------3961FC5C7CA439C16905DF0A"
Content-Language: en-US

This is a multi-part message in MIME format.
--------------3961FC5C7CA439C16905DF0A
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi

Apparmor hasn't a Netfilter firewall support module.

Network rules is a good choice for applications that have AA-profiles,
but it does not protect unconfined processes for forbidden network
outgoing connections.

I mean the function of the Security netfiter tables for SElinux, but the
easy way similar to xt_gradm, part of the Grsecurity project:
https://grsecurity.net/stable/grsecurity-2.2.0-iptables.patch

Proposed solution (userspace):
NFtables (next Linux firewall):

nft insert rule ip filter output meta apparmor aapolicy unconfined drop
nft insert rule ip filter output meta apparmor aapolicy enforce accept
nft insert rule ip filter output meta apparmor aapolicy complain log acce=
pt

Iptables (current/old Linux firewall):
iptables -I OUTPUT ! -o lo -m apparmor --aapolicy unconfined -j DROP
iptables -A OUTPUT ! -o lo -m apparmor --aapolicy enforce=C2=A0 -j ACCEPT=

iptables -A OUTPUT ! -o lo -m apparmor --aapolicy complain=C2=A0 -j LOG
--log-prefix "$PROFILE_NAME - complain: $APP_NAME"
iptables -A OUTPUT ! -o lo -m apparmor --aapolicy complain=C2=A0 -j ACCEP=
T



Example log from LSM Integrity IMA (Apparmor Variables - enforce)

/audit: type=3D1800 audit(1546855115.951:3766): pid=3D12211 uid=3D0 auid=3D=
1001
ses=3D4 subj=3D=3D/bin/kmod (enforce) op=3Dappraise_data
cause=3DIMA-signature-required comm=3D"modprobe"
name=3D"/lib64/modules/4.19.13-gt5/kernel/net/sched/sch_codel.ko"
dev=3D"sdb1" ino=3D1334797 res=3D0/

/where:/

Apparmor Profile name & policy:/=C2=A0=C2=A0 //subj=3D=3D/bin/kmod (enfor=
ce) /
Real aplication name:=C2=A0 /comm=3D"modprobe" /

AA-variables - unconfined:

[ 1703.396288] audit: type=3D1800 audit(1546855383.896:3777): pid=3D12347=

uid=3D0 auid=3D1001 ses=3D4 subj=3D=3Dunconfined op=3Dappraise_data
cause=3DIMA-signature-required comm=3D"modprobe"
name=3D"/lib64/modules/4.19.13-gt5/kernel/net/sched/sch_codel.ko"
dev=3D"sdb1" ino=3D1334797 res=3D0

where:

AA-policy: subj=3D=3Dunconfined

aplication name: =C2=A0=C2=A0 comm=3D"modprobe"

AA-variables - complain:

audit: type=3D1800 audit(1546855552.256:3785): pid=3D12402 uid=3D0 auid=3D=
1001
ses=3D4 subj=3D=3D/bin/kmod (complain) op=3Dappraise_data
cause=3DIMA-signature-required comm=3D"insmod"=C2=A0
name=3D"/lib64/modules/4.19.13-gt5/kernel/net/sched/sch_codel.ko"
dev=3D"sdb1" ino=3D1334797 res=3D0

where:

AA - profile & policy:=C2=A0 subj=3D=3D/bin/kmod (complain)

App name:=C2=A0comm=3D"insmod"

I'm not a programmer, is there any chance of adding a similar module in
Apparmor?

Cheers





--------------3961FC5C7CA439C16905DF0A
Content-Type: text/html; charset=utf-8
Content-Transfer-Encoding: quoted-printable

<html>
  <head>

    <meta http-equiv=3D"content-type" content=3D"text/html; charset=3DUTF=
-8">
  </head>
  <body text=3D"#000000" bgcolor=3D"#FFFFFF">
    <p>Hi</p>
    Apparmor hasn't a Netfilter firewall support module.<br>
    <br>
    Network rules is a good choice for applications that have
    AA-profiles,<br>
    but it does not protect unconfined processes for forbidden network<br=
>
    outgoing connections.<br>
    <br>
    I mean the function of the Security netfiter tables for SElinux, but
    the<br>
    easy way similar to xt_gradm, part of the Grsecurity project:<br>
    <a class=3D"moz-txt-link-freetext" href=3D"https://grsecurity.net/sta=
ble/grsecurity-2.2.0-iptables.patch">https://grsecurity.net/stable/grsecu=
rity-2.2.0-iptables.patch</a><br>
    <br>
    Proposed solution (userspace):<br>
    NFtables (next Linux firewall):<br>
    <br>
    nft insert rule ip filter output meta apparmor aapolicy unconfined
    drop<br>
    nft insert rule ip filter output meta apparmor aapolicy enforce
    accept<br>
    nft insert rule ip filter output meta apparmor aapolicy complain log
    accept<br>
    <br>
    Iptables (current/old Linux firewall):<br>
    iptables -I OUTPUT ! -o lo -m apparmor --aapolicy unconfined -j DROP<=
br>
    iptables -A OUTPUT ! -o lo -m apparmor --aapolicy enforce=C2=A0 -j AC=
CEPT<br>
    iptables -A OUTPUT ! -o lo -m apparmor --aapolicy complain=C2=A0 -j L=
OG<br>
    --log-prefix "$PROFILE_NAME - complain: $APP_NAME"<br>
    iptables -A OUTPUT ! -o lo -m apparmor --aapolicy complain=C2=A0 -j
    ACCEPT<br>
    <p><br>
    </p>
    <p><br>
    </p>
    <p>Example log from LSM Integrity IMA (Apparmor Variables - enforce)<=
/p>
    <p><i>audit: type=3D1800 audit(1546855115.951:3766): pid=3D12211 uid=3D=
0
        auid=3D1001 ses=3D4 subj=3D=3D/bin/kmod (enforce) op=3Dappraise_d=
ata
        cause=3DIMA-signature-required comm=3D"modprobe"
        name=3D"/lib64/modules/4.19.13-gt5/kernel/net/sched/sch_codel.ko"=

        dev=3D"sdb1" ino=3D1334797 res=3D0</i></p>
    <p><i>where:</i></p>
    <p>Apparmor Profile name &amp; policy:<i>=C2=A0=C2=A0 </i><i>subj=3D=3D=
/bin/kmod
        (enforce) </i><br>
      Real aplication name:=C2=A0 <i>comm=3D"modprobe" </i></p>
    <p>AA-variables - unconfined:</p>
    <p>[ 1703.396288] audit: type=3D1800 audit(1546855383.896:3777):
      pid=3D12347 uid=3D0 auid=3D1001 ses=3D4 subj=3D=3Dunconfined op=3Da=
ppraise_data
      cause=3DIMA-signature-required comm=3D"modprobe"
      name=3D"/lib64/modules/4.19.13-gt5/kernel/net/sched/sch_codel.ko"
      dev=3D"sdb1" ino=3D1334797 res=3D0<br>
    </p>
    <p>where:</p>
    <p>AA-policy: subj=3D=3Dunconfined</p>
    <p>aplication name: =C2=A0=C2=A0 comm=3D"modprobe" <br>
    </p>
    <p>AA-variables - complain:</p>
    <p>audit: type=3D1800 audit(1546855552.256:3785): pid=3D12402 uid=3D0=

      auid=3D1001 ses=3D4 subj=3D=3D/bin/kmod (complain) op=3Dappraise_da=
ta
      cause=3DIMA-signature-required comm=3D"insmod"=C2=A0
      name=3D"/lib64/modules/4.19.13-gt5/kernel/net/sched/sch_codel.ko"
      dev=3D"sdb1" ino=3D1334797 res=3D0<br>
    </p>
    <p>where:<br>
    </p>
    <p>AA - profile &amp; policy:=C2=A0 subj=3D=3D/bin/kmod (complain)</p=
>
    <p>App name:=C2=A0comm=3D"insmod" <br>
    </p>
    I'm not a programmer, is there any chance of adding a similar module
    in<br>
    Apparmor?<br>
    <br>
    Cheers<br>
    <br>
    <br>
    <br>
    <br>
  </body>
</html>

--------------3961FC5C7CA439C16905DF0A--

--rAONKwYQwIyLBHeEQsN73BLpx1EiYRSt2--

--tLQbqWky4mhSg4lF26wA7ujwkztV08f4G
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEsq/Hyleni+6nqiBAOu067AdQmvEFAlwzJu4ACgkQOu067AdQ
mvFlYw/+M0rowJHxd19OJ56w3ffSBJ+oNia1OSKr7OvaYYdt7X4Yigvxb0IAjMSN
KHfU3Ju9/OHTusXEjBkK9n+VbyZu+Y/exAuwBpj7wE7hAa7UMqEtYdwOk7eYM5WA
e4eZpB1FO/GT0+f+FoxkynHfCnxoccGqSihHRtvjZUJtkMuKl6V9MvbYHXswhOvV
WMPmiFnrwGAqg3LJkCZJ/dEo49lYjHO8M7rPE4A+KFFhlUw7wqNU64fNhahghS8P
KiT0mpt9xUE7H4LBX6U6MY4hB0G4xm5zl6hX5SiMNzn8ykdn8aUO+Ykfx1t4y0rq
AIXWZDHR6Q+gLE3wWEQ1KjnaDaCUvU/UiaMtY/PrDCQpVHE4IjSlJ2WhJ+q2RBx9
VEO6Uj3DXWoi4tr1PIy3d2mNW5ULdLKO4Ke9rfAX8ba3eXztdn5Lyb/E67m+2nQU
G1JBhmGn+H6NMBcro+zW1FW5V7+VgFvGzmKf6icoTm6K8V/Nv2ph/g2TrcxLAL4J
YcH47faNG4f52i5c5jjA1c2hBWSMjrXxq8T1mW1lsaYjj4NU+DXwdea9ZYxI5HYZ
X3mQejFJzDsZMz/qPxEbslbnmmfr2BaqNmStvckL28yg5oRgexFeXcXP5ngYjvBX
I8TihTWQ1pK4co003bP59Cw+5afyE5w964iE19/ZA8Uh2lYWtcE=
=Y+jc
-----END PGP SIGNATURE-----

--tLQbqWky4mhSg4lF26wA7ujwkztV08f4G--


--===============6395670286216889898==
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: base64
Content-Disposition: inline

LS0gCkFwcEFybW9yIG1haWxpbmcgbGlzdApBcHBBcm1vckBsaXN0cy51YnVudHUuY29tCk1vZGlm
eSBzZXR0aW5ncyBvciB1bnN1YnNjcmliZSBhdDogaHR0cHM6Ly9saXN0cy51YnVudHUuY29tL21h
aWxtYW4vbGlzdGluZm8vYXBwYXJtb3IK

--===============6395670286216889898==--
