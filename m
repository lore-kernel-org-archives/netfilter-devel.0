From: Ricardo Klein <klein.rfk@gmail.com>
Subject: Re: ipset 6.16 kernel panic on bitmap:hash,ip
Date: Tue, 27 Nov 2012 11:56:06 -0200
Message-ID: <CADuigkUGcYNBYjgB+fLp4A5M-pDd779E-6WCpfVv5tqvpnfpUQ@mail.gmail.com>
References: <CADuigkVyCJVe5yKVvcKweZ=FmnTTWE1JQ55a35LrCLi2oWBHoQ@mail.gmail.com>
	<alpine.DEB.2.00.1211271352350.14623@blackhole.kfki.hu>
	<CADuigkX8Q0AJ_-PHyzn+1orKuXfqgrdPPC3yZ1aORBJrdcxBLg@mail.gmail.com>
	<alpine.DEB.2.00.1211271403550.14623@blackhole.kfki.hu>
	<CADuigkUwmj1d2PWW7wWvu12e7J9K6V9gvs+8BiM_J8QjYT5RGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oa0-f46.google.com ([209.85.219.46]:42455 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755168Ab2K0N4H convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 27 Nov 2012 08:56:07 -0500
In-Reply-To: <CADuigkUwmj1d2PWW7wWvu12e7J9K6V9gvs+8BiM_J8QjYT5RGw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

So did I foud a bug? If yes, glad to help \o/

Well, with 6.15 it builds OK...
BUT, I cant use bitmap:ip,mac on iptables rules... check this:

# CLEAR ALL IPTABLES RULES
iptables -F

#CRIATE SET
ipset destroy SET_MACS_ADM
ipset -N SET_MACS_ADM macipmap range 10.0.0.0/16
sleep 1

# POPULATE SET
ipset -A SET_MACS_ADM 10.0.34.32,00:1F:3B:xx:xx:xx
*(xx:xx:xx was intentional to hide my mac address)

# CREATE IPTABLES RULE
iptables -A INPUT -m set --set SET_MACS_ADM src -j DROP

it is not blocking traffic coming from that machine...
--
Att...

Ricardo Felipe Klein
klein.rfk@gmail.com


On Tue, Nov 27, 2012 at 11:36 AM, Ricardo Klein <klein.rfk@gmail.com> w=
rote:
> crap... I didnt saw the compilation error on make modules:
> [root@fw01 ipset-6.16]# make modules
> make -C /lib/modules/`uname -r`/build M=3D$PWD/kernel/net/netfilter V=
=3D \
> IP_SET_MAX=3D256 KDIR=3D$PWD/kernel modules
> make[1]: Entering directory `/usr/src/kernels/2.6.32-279.14.1.el6.x86=
_64'
>   CC [M]  /root/div/ipset-6.16/kernel/net/netfilter/xt_set.o
>   CC [M]  /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core=
=2Eo
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:34:
> error: expected =91=3D=92, =91,=92, =91;=92, =91asm=92 or =91__attrib=
ute__=92 before =91*=92
> token
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c: In
> function =91ip_set_rcu_get=92:
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:369:
> error: =91ip_set_list=92 undeclared (first use in this function)
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:369:
> error: (Each undeclared identifier is reported only once
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:369:
> error: for each function it appears in.)
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:369:
> warning: type defaults to =91int=92 in declaration of =91_________p1=92
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:369:
> warning: type defaults to =91int=92 in declaration of =91type name=92
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:369:
> error: subscripted value is neither array nor pointer
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c: In
> function =91ip_set_get_byname=92:
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:473:
> error: =91ip_set_list=92 undeclared (first use in this function)
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:473:
> warning: type defaults to =91int=92 in declaration of =91_________p1=92
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:473:
> warning: type defaults to =91int=92 in declaration of =91type name=92
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:473:
> error: subscripted value is neither array nor pointer
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c: In
> function =91ip_set_put_byindex=92:
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:499:
> error: =91ip_set_list=92 undeclared (first use in this function)
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:499:
> warning: type defaults to =91int=92 in declaration of =91_________p1=92
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:499:
> warning: type defaults to =91int=92 in declaration of =91type name=92
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:499:
> error: subscripted value is neither array nor pointer
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c: In
> function =91ip_set_nfnl_get=92:
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:545:
> error: implicit declaration of function =91rcu_dereference_protected=92
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:545:
> error: =91ip_set_list=92 undeclared (first use in this function)
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c: In
> function =91ip_set_nfnl_get_byindex=92:
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:573:
> error: =91ip_set_list=92 undeclared (first use in this function)
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c: In
> function =91ip_set_nfnl_put=92:
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:596:
> error: =91ip_set_list=92 undeclared (first use in this function)
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c: In
> function =91find_set_and_id=92:
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:663:
> error: =91ip_set_list=92 undeclared (first use in this function)
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c: In
> function =91find_free_id=92:
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:688:
> error: =91ip_set_list=92 undeclared (first use in this function)
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c: In
> function =91ip_set_create=92:
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:809:
> error: =91ip_set_list=92 undeclared (first use in this function)
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c: In
> function =91ip_set_destroy_set=92:
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:851:
> error: =91ip_set_list=92 undeclared (first use in this function)
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c: In
> function =91ip_set_destroy=92:
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:887:
> error: =91ip_set_list=92 undeclared (first use in this function)
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c: In
> function =91ip_set_flush=92:
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:943:
> error: =91ip_set_list=92 undeclared (first use in this function)
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c: In
> function =91ip_set_rename=92:
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:996:
> error: =91ip_set_list=92 undeclared (first use in this function)
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c: In
> function =91ip_set_swap=92:
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:1053:
> error: =91ip_set_list=92 undeclared (first use in this function)
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c: In
> function =91ip_set_dump_done=92:
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:1074:
> error: =91ip_set_list=92 undeclared (first use in this function)
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c: In
> function =91ip_set_dump_start=92:
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:1172:
> error: =91ip_set_list=92 undeclared (first use in this function)
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c: In
> function =91ip_set_sockfn_get=92:
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:1806:
> error: =91ip_set_list=92 undeclared (first use in this function)
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c: In
> function =91ip_set_init=92:
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:1850:
> error: =91ip_set_list=92 undeclared (first use in this function)
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c: In
> function =91ip_set_fini=92:
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:1872:
> error: =91ip_set_list=92 undeclared (first use in this function)
> make[3]: *** [/root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_=
core.o]
> Error 1
> make[2]: *** [/root/div/ipset-6.16/kernel/net/netfilter/ipset] Error =
2
> make[1]: *** [_module_/root/div/ipset-6.16/kernel/net/netfilter] Erro=
r 2
> make[1]: Leaving directory `/usr/src/kernels/2.6.32-279.14.1.el6.x86_=
64'
> make: *** [modules] Error 2
>
> Sorry, I will try 6.15 again.
> --
> Att...
>
> Ricardo Felipe Klein
> klein.rfk@gmail.com
>
>
> On Tue, Nov 27, 2012 at 11:11 AM, Jozsef Kadlecsik
> <kadlec@blackhole.kfki.hu> wrote:
>> On Tue, 27 Nov 2012, Ricardo Klein wrote:
>>
>>> I know, I have 6.15 tested, but the problem came back in 6.16
>>
>> Can't be, I have verified before replying to you.
>>
>> Kernel, running 6.16 modules:
>>
>> # ipset -N SET_MACS bitmap:ip,mac range 0.0.0.0/0
>> ipset v6.16: The range you specified exceeds the size limit of the s=
et
>> type
>> # ipset-6.14 -N SET_MACS bitmap:ip,mac range 0.0.0.0/0
>> ipset v6.14: The range you specified exceeds the size limit of the s=
et
>> type
>>
>> Best regards,
>> Jozsef
>>
>>> On Tue, Nov 27, 2012 at 10:58 AM, Jozsef Kadlecsik
>>> <kadlec@blackhole.kfki.hu> wrote:
>>> > On Tue, 27 Nov 2012, Ricardo Klein wrote:
>>> >
>>> >> When I creta an ipset like this:
>>> >> ipset -N SET_MACS bitmap:ip,mac range 0.0.0.0/0
>>> >>
>>> >> I got kernel panic when run:
>>> >> ipset list
>>> >
>>> > That can't be ipset 6.16, neither in the kernel, nor the ipset bi=
nary.
>>> > The bug is fixed in ipset 6.15. You are running kernel modules an=
d
>>> > ipset binary from earlier releases.
>>> >
>>> >> Anyway, we need some rules here based on mac address (no matter =
what
>>> >> ip address the machine have, because some of them are in DHCP).
>>> >> I know that a mac address can be easy cloned, but, still, we nee=
d that
>>> >> for some rules...
>>> >>
>>> >> Can we have a set type "mac address" ? Only mac, with no ip?
>>> >>
>>> >> O tried "ipset -N SET_MACS_ADM bitmap:ip,mac range 10.0.0.0/8" t=
oo but got:
>>> >> ipset v6.16: The range you specified exceeds the size limit of t=
he set type
>>> >>
>>> >> "ipset -N SET_MACS_ADM bitmap:ip,mac range 10.0.0.0/16" woked...
>>> >>
>>> >> But again, this does not do the job because I need to set a rule=
 based
>>> >> on mac address and dinamic ip addresses.
>>> >
>>> > Holger Eitzenberger is working on a hash:mac type.
>>> >
>>> > Best regards,
>>> > Jozsef
>>> > -
>>> > E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.h=
u
>>> > PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
>>> > Address : Wigner Research Centre for Physics, Hungarian Academy o=
f Sciences
>>> >           H-1525 Budapest 114, POB. 49, Hungary
>>>
>>
>> -
>> E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
>> PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
>> Address : Wigner Research Centre for Physics, Hungarian Academy of S=
ciences
>>           H-1525 Budapest 114, POB. 49, Hungary
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
