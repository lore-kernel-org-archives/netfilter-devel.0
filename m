From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset 2.0 - Minor fix
Date: Fri, 10 Dec 2004 11:20:13 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0412101117280.14449@blackhole.kfki.hu>
References: <699F7BBB368A10479166148511F5241710DA52@gn-ex01.Go80211.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Robert Iakobashvili <roberti@Go-WLAN.com>
In-Reply-To: <699F7BBB368A10479166148511F5241710DA52@gn-ex01.Go80211.com>
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

Hi,

On Thu, 9 Dec 2004, Robert Iakobashvili wrote:

> IPset 2.0 works great with the recommended patch-o-patic and iptables version
> on linux vanilla kernel 2.6.9.
>
> The minor issue on a Debian 64-bit destribution for AMD:
> ipset compilation fails with :
[..]
>
> fixed by adding to CFLAGS -fPIC.

You are right, the flag was missing from Makefile.
It has been corrected in svn and the new snapshot is uploaded to
http://people.netfilter.org/kadlec/ipset.

Thank you for reporting and fixing the problem.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
