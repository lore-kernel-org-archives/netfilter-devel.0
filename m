From: Esteban Ribicic <eribicic@uolsinectis.com>
Subject: Re: [PATCH] ROUTE target : update to pom-ng + new version for
 kernel 2.6.x
Date: Sat, 24 Apr 2004 21:01:27 -0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040424210127.27cbc7fc.eribicic@uolsinectis.com>
References: <1082535373.17611.39.camel@descartes.info.ucl.ac.be>
	<408AF23C.3060300@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <408AF23C.3060300@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Content-Transfer-Encoding: 7bit

hi

im trying to match all recent ip_conntrak connections from my network
im using this algortithm:

# does not concern ESTA connections..
# udp      17 59 src=10.0.3.75 dst=62.215.85.173 sport=26097 dport=19210 src=62.215.85.173 dst=200.69.147.80 sport=19210 dport=26097 [ASSURED] use=1 mark=0

$timeout=300;
if ($_=~/\w+\s+\d+\s(\d+)\s+src=/) {
	if ($1<$timeout) {
		$counter++;
	}
}

where $timeout is the max timeout of the connection.

now, what i notice is that ESTABLISHED connections are rarely under 2000 seconds? isnt it rare?


lp:~/codigos/conntrack# cat /proc/net/ip_conntrack | grep ESTABLISHED  | awk '{print $3}' | sort -n | head -n 5
870
938
1106
1977
1990

...(the list is realy extensive)

Its obvious im thinking something woron..maybe $1 is not a timeout and less is seconds?

thanks for the help
Steve

On Sun, 25 Apr 2004 01:03:24 +0200
Patrick McHardy <kaber@trash.net> wrote:

> Cedric de Launois wrote:
> > Here is a patch to convert the ROUTE target to the new pom-ng.
> > This patch also contains a corrected version of the ROUTE target
> > for kernels 2.6.x.
> 
> Please make sure your patch doesn't contain changes to CVS directories.
> 
> Regards
> Patrick
> 
> > 
> > Cedric
> > 
> > 
> > 
> > diff -Nru ROUTE.orig/linux-2.4/net/ipv6/netfilter/CVS/Entries ROUTE/linux-2.4/net/ipv6/netfilter/CVS/Entries
> > --- ROUTE.orig/linux-2.4/net/ipv6/netfilter/CVS/Entries	1970-01-01 01:00:00.000000000 +0100
> > +++ ROUTE/linux-2.4/net/ipv6/netfilter/CVS/Entries	2004-03-08 10:06:41.000000000 +0100
> > @@ -0,0 +1,5 @@
> > +/Config.in.ladd/1.1/Sat Dec 20 16:43:09 2003//
> > +/Kconfig.ladd/1.1/Tue Dec 23 11:41:11 2003//
> > +/Makefile.ladd/1.1/Sat Dec 20 16:43:09 2003//
> > +/ip6t_ROUTE.c/1.1/Sat Dec 20 16:43:09 2003//
> > +D
> > diff -Nru ROUTE.orig/linux-2.4/net/ipv6/netfilter/CVS/Repository ROUTE/linux-2.4/net/ipv6/netfilter/CVS/Repository
> > --- ROUTE.orig/linux-2.4/net/ipv6/netfilter/CVS/Repository	1970-01-01 01:00:00.000000000 +0100
> > +++ ROUTE/linux-2.4/net/ipv6/netfilter/CVS/Repository	2004-03-08 10:06:41.000000000 +0100
> > @@ -0,0 +1 @@
> > +patch-o-matic-ng/ROUTE/linux/net/ipv6/netfilter
> > diff -Nru ROUTE.orig/linux-2.4/net/ipv6/netfilter/CVS/Root ROUTE/linux-2.4/net/ipv6/netfilter/CVS/Root
> > --- ROUTE.orig/linux-2.4/net/ipv6/netfilter/CVS/Root	1970-01-01 01:00:00.000000000 +0100
> > +++ ROUTE/linux-2.4/net/ipv6/netfilter/CVS/Root	2004-03-08 10:06:41.000000000 +0100
> > @@ -0,0 +1 @@
> > +:pserver:cvs:cvs@pserver.netfilter.org:/cvspublic
> 
> 
