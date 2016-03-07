From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] configure: Show support for connlabel
Date: Mon, 7 Mar 2016 15:09:13 +0100
Message-ID: <20160307140913.GA27599@salvia>
References: <20160307091447.GA10194@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:36588 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752212AbcCGOJY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 7 Mar 2016 09:09:24 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 76A51C124F
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2016 15:09:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 65732DA394
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2016 15:09:22 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id AFC0EDA39C
	for <netfilter-devel@vger.kernel.org>; Mon,  7 Mar 2016 15:09:14 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160307091447.GA10194@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 07, 2016 at 02:44:47PM +0530, Shivani Bhardwaj wrote:
> Add the --enable-connlabel option and show whether it is already
> supported.
> 
> After this patch, iptables configuration shows up as:
> 
> Iptables Configuration:
>   IPv4 support:				yes
>   IPv6 support:				yes
>   Devel support:			yes
>   IPQ support:				no
>   Large file support:			yes
>   BPF utils support:			no
>   nfsynproxy util support:		no
>   nftables support:			yes
>   connlabel support:			yes
> 
> Signed-off-by: Shivani Bhardwaj <shivanib134@gmail.com>
> ---
>  configure.ac | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/configure.ac b/configure.ac
> index 33a8f2d..c946d69 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -63,6 +63,9 @@ AC_ARG_WITH([pkgconfigdir], AS_HELP_STRING([--with-pkgconfigdir=PATH],
>  AC_ARG_ENABLE([nftables],
>  	AS_HELP_STRING([--disable-nftables], [Do not build nftables compat]),
>  	[enable_nftables="$enableval"], [enable_nftables="yes"])
> +AC_ARG_ENABLE([connlabel],
> +	AS_HELP_STRING([--enable-connlabel], [Build libnetfilter_conntrack]),
> +	[enable_connlabel="$enableval"], [enable_connlabel="yes"])

I think there is still some missing code here. If the user requests
connlabel but libnetfilter_conntrack (including the right version) is
not available, then I would fail and display an error since the user
is explicitly asking for this.

Otherwise, we can fall back on the existing behaviour: just lazy check
if it's there and enable it in that case. If the library is not
present, just skip this.

The --disable-connlabel should also work, in that case, we should skip
adding support for this.

Can you look into fitting this logic into this? Thanks.

>  libiptc_LDFLAGS2="";
>  AX_CHECK_LINKER_FLAGS([-Wl,--no-as-needed],
> @@ -114,6 +117,7 @@ AM_CONDITIONAL([ENABLE_LIBIPQ], [test "$enable_libipq" = "yes"])
>  AM_CONDITIONAL([ENABLE_BPFC], [test "$enable_bpfc" = "yes"])
>  AM_CONDITIONAL([ENABLE_SYNCONF], [test "$enable_nfsynproxy" = "yes"])
>  AM_CONDITIONAL([ENABLE_NFTABLES], [test "$enable_nftables" = "yes"])
> +AM_CONDITIONAL([ENABLE_CONNLABEL], [test "$enable_connlabel" = "yes"])
>  
>  if test "x$enable_bpfc" = "xyes" || test "x$enable_nfsynproxy" = "xyes"; then
>  	AC_CHECK_LIB(pcap, pcap_compile,, AC_MSG_ERROR(missing libpcap library required by bpf compiler or nfsynproxy tool))
> @@ -243,6 +247,7 @@ Iptables Configuration:
>    BPF utils support:			${enable_bpfc}
>    nfsynproxy util support:		${enable_nfsynproxy}
>    nftables support:			${enable_nftables}
> +  connlabel support:			${enable_connlabel}
>  
>  Build parameters:
>    Put plugins into executable (static):	${enable_static}
> -- 
> 1.9.1
> 
> --
> To unsubscribe from this list: send the line "unsubscribe netfilter-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
