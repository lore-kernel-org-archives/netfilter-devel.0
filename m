From: "Andrew Hall" <temp02@bluereef.com.au>
Subject: Re: patch-o-matic-ng release candidate in cvs
Date: Tue, 11 May 2004 18:32:22 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <020101c43732$7acb8ff0$2601010a@bluereef.local>
References: <Pine.LNX.4.33.0405110935320.13357-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Jozsef Kadlecsik" <kadlec@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Jozsef,

Your tcp_window_tracking patch fails to install with the new 2.6.6 kernel

patching file include/linux/netfilter_ipv4/ip_conntrack.h
Hunk #1 succeeded at 249 (offset 1 line).
patching file include/linux/netfilter_ipv4/ip_conntrack_tcp.h
patching file include/linux/sysctl.h
Hunk #1 succeeded at 406 (offset 15 lines).
patching file net/ipv4/netfilter/ip_conntrack_core.c
Hunk #1 succeeded at 844 (offset 2 lines).
patching file net/ipv4/netfilter/ip_conntrack_proto_tcp.c
Hunk #4 FAILED at 712.
Hunk #5 succeeded at 857 (offset 2 lines).
1 out of 6 hunks FAILED -- saving rejects to file
net/ipv4/netfilter/ip_conntrack_proto_tcp.c.rej
patching file net/ipv4/netfilter/ip_conntrack_standalone.c
Hunk #1 succeeded at 322 (offset 36 lines).
patching file net/ipv4/netfilter/ip_nat_helper.c

This worked okay with 2.6.5.

regards,

Andrew.
----- Original Message -----
From: "Jozsef Kadlecsik" <kadlec@blackhole.kfki.hu>
To: "Jim Gifford" <maillist@jg555.com>
Cc: <netfilter-devel@lists.netfilter.org>; "Toth Szabolcs"
<totya@mail.ajkanet.hu>
Sent: Tuesday, May 11, 2004 5:42 PM
Subject: Re: patch-o-matic-ng release candidate in cvs


> On Mon, 10 May 2004, Jim Gifford wrote:
>
> > I assume this new version doesn't support 1.2.9
> >
> > Error Message
> > Your iptables version 1.2.9 is too old and not supported at ./runme line
214
>
> Yes, because the corresponding patch between 1.2.9 and 1.2.10 had not
> yet been generated. Use the iptables source code from cvs.
>
> Best regards,
> Jozsef
> -
> E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
> PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
> Address : KFKI Research Institute for Particle and Nuclear Physics
>           H-1525 Budapest 114, POB. 49, Hungary
>
>
>
