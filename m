From: Eric Leblond <eric@regit.org>
Subject: Re: [PATCH 1/8] ipfix: use nfct_bitmask
Date: Sun, 23 Mar 2014 19:55:41 +0100
Message-ID: <1395600941.23474.22.camel@ice-age2.regit.org>
References: <20140308010344.GA4415@gmail.com>
	 <20140308010709.GB4415@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Cc: The netfilter developer mailinglist
	<netfilter-devel@vger.kernel.org>
To: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:39886 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909AbaCWSzx (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 23 Mar 2014 14:55:53 -0400
In-Reply-To: <20140308010709.GB4415@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Sat, 2014-03-08 at 10:07 +0900, Ken-ichirou MATSUZAWA wrote:
> from libnetfilter_conntrack instead of original
> ---
>  output/Makefile.am          |   6 ++-
>  output/ulogd_output_IPFIX.c | 107 ++++++--------------------------------------
>  2 files changed, 18 insertions(+), 95 deletions(-)
> 
> diff --git a/output/Makefile.am b/output/Makefile.am
> index ff851ad..92f1233 100644
> --- a/output/Makefile.am
> +++ b/output/Makefile.am
> @@ -7,7 +7,7 @@ SUBDIRS= pcap mysql pgsql sqlite3 dbi
>  pkglib_LTLIBRARIES = ulogd_output_LOGEMU.la ulogd_output_SYSLOG.la \
>  			 ulogd_output_OPRINT.la ulogd_output_GPRINT.la \
>  			 ulogd_output_NACCT.la ulogd_output_XML.la \
> -			 ulogd_output_GRAPHITE.la
> +			 ulogd_output_GRAPHITE.la ulogd_output_IPFIX.la
>  
>  if HAVE_JANSSON
>  pkglib_LTLIBRARIES += ulogd_output_JSON.la
> @@ -42,3 +42,7 @@ ulogd_output_JSON_la_SOURCES = ulogd_output_JSON.c
>  ulogd_output_JSON_la_LIBADD  = ${libjansson_LIBS}
>  ulogd_output_JSON_la_LDFLAGS = -avoid-version -module
>  endif
> +
> +ulogd_output_IPFIX_la_SOURCES = ulogd_output_IPFIX.c
> +ulogd_output_IPFIX_la_LDFLAGS = -avoid-version -module
> +ulogd_output_IPFIX_la_LIBADD = ${LIBNETFILTER_CONNTRACK_LIBS}
> diff --git a/output/ulogd_output_IPFIX.c b/output/ulogd_output_IPFIX.c
> index 761d272..01ac9a0 100644
> --- a/output/ulogd_output_IPFIX.c
> +++ b/output/ulogd_output_IPFIX.c
> @@ -36,6 +36,8 @@
>  #include <sys/socket.h>
>  #include <netdb.h>
>  
> +#include <libnetfilter_conntrack/libnetfilter_conntrack.h>

This means that your code is dependant of libnetfilter_conntrack being
available on the system. As it is possible to build ulogd with
--disable-nfct configure flags, you need to make the build of IPFIX
conditional to the use of NFCT.

By the way providing a message at the end of configure run to indicate
if IPFIX module is built would be really nice (see echo call at end of
configure.ac).

BR,
-- 
Eric Leblond <eric@regit.org>

