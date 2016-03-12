From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] configure: Show support for connlabel
Date: Sat, 12 Mar 2016 12:50:27 +0100
Message-ID: <20160312115027.GA2262@salvia>
References: <20160310171028.GA8038@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49273 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752367AbcCLLuc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Mar 2016 06:50:32 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 9617E4B9E2
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Mar 2016 12:50:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 7A329DA383
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Mar 2016 12:50:30 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 54030DA392
	for <netfilter-devel@vger.kernel.org>; Sat, 12 Mar 2016 12:50:28 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160310171028.GA8038@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 10, 2016 at 10:40:29PM +0530, Shivani Bhardwaj wrote:
> Add the --disable-connlabel option and the appropriate functionality
> associated with it.
> 
> After this patch, iptables configuration shows up as:
> 
> Iptables Configuration:
>   IPv4 support:                         yes
>   IPv6 support:                         yes
>   Devel support:                        yes
>   IPQ support:                          no
>   Large file support:                   yes
>   BPF utils support:                    no
>   nfsynproxy util support:              no
>   nftables support:                     yes
>   connlabel support:                    yes
> 
> Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
> ---
> Changes in v2:
> 	Correct the option to disable-connlabel and add code to make it
> 	work
> 
>  configure.ac | 38 +++++++++++++++++++++++++-------------
>  1 file changed, 25 insertions(+), 13 deletions(-)
> 
> diff --git a/configure.ac b/configure.ac
> index 33a8f2d..afc6845 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -63,6 +63,10 @@ AC_ARG_WITH([pkgconfigdir], AS_HELP_STRING([--with-pkgconfigdir=PATH],
>  AC_ARG_ENABLE([nftables],
>  	AS_HELP_STRING([--disable-nftables], [Do not build nftables compat]),
>  	[enable_nftables="$enableval"], [enable_nftables="yes"])
> +AC_ARG_ENABLE([connlabel],
> +	AS_HELP_STRING([--disable-connlabel],
> +	[Do not build libnetfilter_conntrack]),
> +	[enable_connlabel="$enableval"], [enable_connlabel="yes"])
>  
>  libiptc_LDFLAGS2="";
>  AX_CHECK_LINKER_FLAGS([-Wl,--no-as-needed],
> @@ -93,15 +97,6 @@ if test "$ac_cv_header_linux_ip_vs_h" != "yes"; then
>  	blacklist_modules="$blacklist_modules ipvs";
>  fi;
>  
> -PKG_CHECK_MODULES([libnetfilter_conntrack], [libnetfilter_conntrack >= 1.0.4],
> -	[nfconntrack=1], [nfconntrack=0])
> -AM_CONDITIONAL([HAVE_LIBNETFILTER_CONNTRACK], [test "$nfconntrack" = 1])
> -
> -if test "$nfconntrack" -ne 1; then
> -	blacklist_modules="$blacklist_modules connlabel";
> -	echo "WARNING: libnetfilter_conntrack not found, connlabel match will not be built";
> -fi;
> -
>  AC_CHECK_SIZEOF([struct ip6_hdr], [], [#include <netinet/ip6.h>])
>  
>  AM_CONDITIONAL([ENABLE_STATIC], [test "$enable_static" = "yes"])
> @@ -114,15 +109,12 @@ AM_CONDITIONAL([ENABLE_LIBIPQ], [test "$enable_libipq" = "yes"])
>  AM_CONDITIONAL([ENABLE_BPFC], [test "$enable_bpfc" = "yes"])
>  AM_CONDITIONAL([ENABLE_SYNCONF], [test "$enable_nfsynproxy" = "yes"])
>  AM_CONDITIONAL([ENABLE_NFTABLES], [test "$enable_nftables" = "yes"])
> +AM_CONDITIONAL([ENABLE_CONNLABEL], [test "$enable_connlabel" = "yes"])
>  
>  if test "x$enable_bpfc" = "xyes" || test "x$enable_nfsynproxy" = "xyes"; then
>  	AC_CHECK_LIB(pcap, pcap_compile,, AC_MSG_ERROR(missing libpcap library required by bpf compiler or nfsynproxy tool))
>  fi
>  
> -PKG_CHECK_MODULES([libnfnetlink], [libnfnetlink >= 1.0],
> -	[nfnetlink=1], [nfnetlink=0])
> -AM_CONDITIONAL([HAVE_LIBNFNETLINK], [test "$nfnetlink" = 1])
> -
>  if test "x$enable_nftables" = "xyes"; then
>  	PKG_CHECK_MODULES([libmnl], [libmnl >= 1.0], [mnl=1], [mnl=0])
>  
> @@ -163,6 +155,25 @@ fi
>  AM_CONDITIONAL([HAVE_LIBMNL], [test "$mnl" = 1])
>  AM_CONDITIONAL([HAVE_LIBNFTNL], [test "$nftables" = 1])
>  
> +if test "x$enable_connlabel" = "xyes"; then
> +	PKG_CHECK_MODULES([libnetfilter_conntrack],
> +		[libnetfilter_conntrack >= 1.0.4],
> +		[nfconntrack=1], [nfconntrack=0])
> +
> +	if test "$nfconntrack" -ne 1; then
> +		blacklist_modules="$blacklist_modules connlabel";
> +		echo "WARNING: libnetfilter_conntrack not found, connlabel match will not be built";
> +	fi;
> +
> +	PKG_CHECK_MODULES([libnfnetlink], [libnfnetlink >= 1.0],
> +		[nfnetlink=1], [nfnetlink=0])

IIRC, libnfnetlink is actually required by other extensions, such as
nfnl_osf under utils.

So you should keep back this where it is I think.
