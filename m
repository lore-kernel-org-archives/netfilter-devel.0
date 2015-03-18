From: Pavel Odintsov <pavel.odintsov@gmail.com>
Subject: Can't link C++ program to libipset
Date: Wed, 18 Mar 2015 14:20:48 +0300
Message-ID: <CALgsdbeBy=wDnyEpZTrGb0=HKPB9kcS03m=jPzCLfzotyA7P8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-we0-f172.google.com ([74.125.82.172]:35646 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755819AbbCRLUu convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 18 Mar 2015 07:20:50 -0400
Received: by webcq43 with SMTP id cq43so29546629web.2
        for <netfilter-devel@vger.kernel.org>; Wed, 18 Mar 2015 04:20:49 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello, folks!

I trying to integrate ipset to my flood monitoring toolkit
https://github.com/FastVPSEestiOu/fastnetmon but can't link it
correctly.

Here you can find my code:
https://gist.github.com/pavel-odintsov/b2277822e5c88e136550

I installed recent version from Git:
cd /usr/src
git clone git://git.netfilter.org/ipset.git
apt-get install -y automake libtool
=2E/autogen.sh
=2E/configure --prefix=3D/opt/ipset
make install

And tried link my tool with libipset but haven't any success:
g++ ipset.c  -I/opt/ipset/include/ -L/opt/ipset/lib -lipset
ipset.c: In function =E2=80=98int main()=E2=80=99:
ipset.c:15:37: warning: deprecated conversion from string constant to
=E2=80=98char*=E2=80=99 [-Wwrite-strings]
ipset.c:15:37: warning: deprecated conversion from string constant to
=E2=80=98char*=E2=80=99 [-Wwrite-strings]
/tmp/ccWP0vdf.o:ipset.c:function ban_ip(char*, char*): error:
undefined reference to 'ipset_session_init(int (*)(char const*, ...))'
/tmp/ccWP0vdf.o:ipset.c:function ban_ip(char*, char*): error:
undefined reference to 'ipset_parse_setname(ipset_session*, ipset_opt,
char const*)'
/tmp/ccWP0vdf.o:ipset.c:function ban_ip(char*, char*): error:
undefined reference to 'ipset_type_get(ipset_session*, ipset_cmd)'
/tmp/ccWP0vdf.o:ipset.c:function ban_ip(char*, char*): error:
undefined reference to 'ipset_session_error(ipset_session const*)'
/tmp/ccWP0vdf.o:ipset.c:function ban_ip(char*, char*): error:
undefined reference to 'ipset_parse_elem(ipset_session*, bool, char
const*)'
/tmp/ccWP0vdf.o:ipset.c:function ban_ip(char*, char*): error:
undefined reference to 'ipset_session_error(ipset_session const*)'
/tmp/ccWP0vdf.o:ipset.c:function ban_ip(char*, char*): error:
undefined reference to 'ipset_cmd(ipset_session*, ipset_cmd, unsigned
int)'
/tmp/ccWP0vdf.o:ipset.c:function ban_ip(char*, char*): error:
undefined reference to 'ipset_session_fini(ipset_session*)'
collect2: error: ld returned 1 exit status

But if i change g++ to gcc everything passed with flying colors:
gcc ipset.c  -I/opt/ipset/include/ -L/opt/ipset/lib -lipset

My toolkit written in C++ and I need ability to link it directly with l=
ibipset.

Thank you for attention to my problem!

--=20
Sincerely yours, Pavel Odintsov
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
