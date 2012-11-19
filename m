From: Ricardo Klein <klein.rfk@gmail.com>
Subject: Re: [ANNOUNCE] ipset 6.15 released
Date: Mon, 19 Nov 2012 15:39:46 -0200
Message-ID: <CADuigkXXwhGkjYVCo68BmOGSbe95DzSYcM6u-YQmrjKSD5VWaQ@mail.gmail.com>
References: <alpine.DEB.2.00.1211191356240.21756@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.1211191356240.21756@blackhole.kfki.hu>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

It fails on ./configure on CentOS 6.3 x84_64 with the message:
./configure: line 14702: syntax error near unexpected token `libmnl,'
./configure: line 14702: `PKG_CHECK_MODULES(libmnl, libmnl >= 1)'

But I have libmnl:
[root@host]# rpm -qa | grep libmnl
libmnl-1.0.2-3.el6.x86_64
libmnl-devel-1.0.2-3.el6.x86_64
--
Att...

Ricardo Felipe Klein
klein.rfk@gmail.com


On Mon, Nov 19, 2012 at 11:03 AM, Jozsef Kadlecsik
<kadlec@blackhole.kfki.hu> wrote:
> Hi,
>
> I'm happy to announce ipset 6.15, which brings a few bugfixes and
> corrections. The most important is that there was a range input bug in
> hash:ip,port,net type: if a single element was to be added/deleted, due to
> a missing initialization, a range of elements were added/deleted.
>
> From now on the "ipset" tool uses gethostbyname2 instead of getaddrinfo:
> in newer glibc, getaddrinfo issues an extra system call to kernel, which
> slows down ipset.
>
> Userspace changes:
>  - Fix interactive mode (Fredrik Eriksson)
>  - Use gethostbyname2 instead of getaddrinfo
>  - Make tests/check_cidrs.sh script executable
>  - Add tests to check completely ranges with hash types
>  - Make easier to apply the netlink.patch
>  - Support protocol numbers as well, not only protocol names
>  - Add (back) the debug flag to configure
>  - Add simple test to check cidr book-keeping
>
> Kernel part changes:
>  - Increase the number of maximal sets automatically as needed
>  - Restore the support of kernel versions between 2.6.32 and 2.6.35
>  - Fix range bug in hash:ip,port,net
>  - Revert, then reapply cidr book keeping patch to handle /0
>
> You can download the source code of ipset from:
>         http://ipset.netfilter.org
>         ftp://ftp.netfilter.org/pub/ipset/
>         git://git.netfilter.org/ipset.git
>
> Best regards,
> Jozsef
> -
> E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
> PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
> Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
>           H-1525 Budapest 114, POB. 49, Hungary
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
