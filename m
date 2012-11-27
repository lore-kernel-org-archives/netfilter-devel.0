From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset 6.16 kernel panic on bitmap:hash,ip
Date: Tue, 27 Nov 2012 14:52:27 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1211271448410.14623@blackhole.kfki.hu>
References: <CADuigkVyCJVe5yKVvcKweZ=FmnTTWE1JQ55a35LrCLi2oWBHoQ@mail.gmail.com> <alpine.DEB.2.00.1211271352350.14623@blackhole.kfki.hu> <CADuigkX8Q0AJ_-PHyzn+1orKuXfqgrdPPC3yZ1aORBJrdcxBLg@mail.gmail.com> <alpine.DEB.2.00.1211271403550.14623@blackhole.kfki.hu>
 <CADuigkUwmj1d2PWW7wWvu12e7J9K6V9gvs+8BiM_J8QjYT5RGw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org
To: Ricardo Klein <klein.rfk@gmail.com>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <CADuigkUwmj1d2PWW7wWvu12e7J9K6V9gvs+8BiM_J8QjYT5RGw@mail.gmail.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Tue, 27 Nov 2012, Ricardo Klein wrote:

> crap... I didnt saw the compilation error on make modules:

Please wait a little bit: the RCU patch broke the support of 
older kernel releases, which will be fixed in 6.16.1 released in any 
moment.

Best regards,
Jozsef
> [root@fw01 ipset-6.16]# make modules
> make -C /lib/modules/`uname -r`/build M=$PWD/kernel/net/netfilter V= \
> IP_SET_MAX=256 KDIR=$PWD/kernel modules
> make[1]: Entering directory `/usr/src/kernels/2.6.32-279.14.1.el6.x86_64'
>   CC [M]  /root/div/ipset-6.16/kernel/net/netfilter/xt_set.o
>   CC [M]  /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.o
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:34:
> error: expected ?=?, ?,?, ?;?, ?asm? or ?__attribute__? before ?*?
> token
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c: In
> function ?ip_set_rcu_get?:
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:369:
> error: ?ip_set_list? undeclared (first use in this function)
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:369:
> error: (Each undeclared identifier is reported only once
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:369:
> error: for each function it appears in.)
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:369:
> warning: type defaults to ?int? in declaration of ?_________p1?
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:369:
> warning: type defaults to ?int? in declaration of ?type name?
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:369:
> error: subscripted value is neither array nor pointer
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c: In
> function ?ip_set_get_byname?:
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:473:
> error: ?ip_set_list? undeclared (first use in this function)
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:473:
> warning: type defaults to ?int? in declaration of ?_________p1?
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:473:
> warning: type defaults to ?int? in declaration of ?type name?
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:473:
> error: subscripted value is neither array nor pointer
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c: In
> function ?ip_set_put_byindex?:
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:499:
> error: ?ip_set_list? undeclared (first use in this function)
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:499:
> warning: type defaults to ?int? in declaration of ?_________p1?
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:499:
> warning: type defaults to ?int? in declaration of ?type name?
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:499:
> error: subscripted value is neither array nor pointer
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c: In
> function ?ip_set_nfnl_get?:
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:545:
> error: implicit declaration of function ?rcu_dereference_protected?
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:545:
> error: ?ip_set_list? undeclared (first use in this function)
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c: In
> function ?ip_set_nfnl_get_byindex?:
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:573:
> error: ?ip_set_list? undeclared (first use in this function)
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c: In
> function ?ip_set_nfnl_put?:
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:596:
> error: ?ip_set_list? undeclared (first use in this function)
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c: In
> function ?find_set_and_id?:
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:663:
> error: ?ip_set_list? undeclared (first use in this function)
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c: In
> function ?find_free_id?:
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:688:
> error: ?ip_set_list? undeclared (first use in this function)
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c: In
> function ?ip_set_create?:
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:809:
> error: ?ip_set_list? undeclared (first use in this function)
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c: In
> function ?ip_set_destroy_set?:
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:851:
> error: ?ip_set_list? undeclared (first use in this function)
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c: In
> function ?ip_set_destroy?:
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:887:
> error: ?ip_set_list? undeclared (first use in this function)
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c: In
> function ?ip_set_flush?:
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:943:
> error: ?ip_set_list? undeclared (first use in this function)
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c: In
> function ?ip_set_rename?:
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:996:
> error: ?ip_set_list? undeclared (first use in this function)
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c: In
> function ?ip_set_swap?:
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:1053:
> error: ?ip_set_list? undeclared (first use in this function)
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c: In
> function ?ip_set_dump_done?:
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:1074:
> error: ?ip_set_list? undeclared (first use in this function)
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c: In
> function ?ip_set_dump_start?:
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:1172:
> error: ?ip_set_list? undeclared (first use in this function)
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c: In
> function ?ip_set_sockfn_get?:
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:1806:
> error: ?ip_set_list? undeclared (first use in this function)
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c: In
> function ?ip_set_init?:
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:1850:
> error: ?ip_set_list? undeclared (first use in this function)
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c: In
> function ?ip_set_fini?:
> /root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.c:1872:
> error: ?ip_set_list? undeclared (first use in this function)
> make[3]: *** [/root/div/ipset-6.16/kernel/net/netfilter/ipset/ip_set_core.o]
> Error 1
> make[2]: *** [/root/div/ipset-6.16/kernel/net/netfilter/ipset] Error 2
> make[1]: *** [_module_/root/div/ipset-6.16/kernel/net/netfilter] Error 2
> make[1]: Leaving directory `/usr/src/kernels/2.6.32-279.14.1.el6.x86_64'
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
> > On Tue, 27 Nov 2012, Ricardo Klein wrote:
> >
> >> I know, I have 6.15 tested, but the problem came back in 6.16
> >
> > Can't be, I have verified before replying to you.
> >
> > Kernel, running 6.16 modules:
> >
> > # ipset -N SET_MACS bitmap:ip,mac range 0.0.0.0/0
> > ipset v6.16: The range you specified exceeds the size limit of the set
> > type
> > # ipset-6.14 -N SET_MACS bitmap:ip,mac range 0.0.0.0/0
> > ipset v6.14: The range you specified exceeds the size limit of the set
> > type
> >
> > Best regards,
> > Jozsef
> >
> >> On Tue, Nov 27, 2012 at 10:58 AM, Jozsef Kadlecsik
> >> <kadlec@blackhole.kfki.hu> wrote:
> >> > On Tue, 27 Nov 2012, Ricardo Klein wrote:
> >> >
> >> >> When I creta an ipset like this:
> >> >> ipset -N SET_MACS bitmap:ip,mac range 0.0.0.0/0
> >> >>
> >> >> I got kernel panic when run:
> >> >> ipset list
> >> >
> >> > That can't be ipset 6.16, neither in the kernel, nor the ipset binary.
> >> > The bug is fixed in ipset 6.15. You are running kernel modules and
> >> > ipset binary from earlier releases.
> >> >
> >> >> Anyway, we need some rules here based on mac address (no matter what
> >> >> ip address the machine have, because some of them are in DHCP).
> >> >> I know that a mac address can be easy cloned, but, still, we need that
> >> >> for some rules...
> >> >>
> >> >> Can we have a set type "mac address" ? Only mac, with no ip?
> >> >>
> >> >> O tried "ipset -N SET_MACS_ADM bitmap:ip,mac range 10.0.0.0/8" too but got:
> >> >> ipset v6.16: The range you specified exceeds the size limit of the set type
> >> >>
> >> >> "ipset -N SET_MACS_ADM bitmap:ip,mac range 10.0.0.0/16" woked...
> >> >>
> >> >> But again, this does not do the job because I need to set a rule based
> >> >> on mac address and dinamic ip addresses.
> >> >
> >> > Holger Eitzenberger is working on a hash:mac type.
> >> >
> >> > Best regards,
> >> > Jozsef
> >> > -
> >> > E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
> >> > PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
> >> > Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
> >> >           H-1525 Budapest 114, POB. 49, Hungary
> >>
> >
> > -
> > E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
> > PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
> > Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
> >           H-1525 Budapest 114, POB. 49, Hungary
> 

-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
