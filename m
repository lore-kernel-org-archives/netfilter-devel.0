Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17F1EC433B4
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Apr 2021 23:59:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D395461448
	for <netfilter-devel@archiver.kernel.org>; Wed, 28 Apr 2021 23:59:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbhD2AAU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 28 Apr 2021 20:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229718AbhD2AAT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 28 Apr 2021 20:00:19 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A517C06138B
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Apr 2021 16:59:34 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id b21so5272889plz.0
        for <netfilter-devel@vger.kernel.org>; Wed, 28 Apr 2021 16:59:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:mail-followup-to
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=QQChGS24ElWH5fX74BmVpeqrazmwvLdKwMYOPj/et3g=;
        b=dX3QWX9+m3OcCUXvghe3gGmni8XgRLgweuqj+Guj0hZwiAIgSVVOGpr9gM1mOvUiFZ
         4GLZ9hJ62vJrrxP582epAQCPjx3vPbFZ1Dywbe9VF1nRmo5YN7jaN6ZWsbiuwgOYqVoG
         2ZBGuUgndhBlFev0wogRlfUQdB6QYoJPpU9NVaWpt4SPIVKp2236SPKHw+oXzyadnIZx
         NPeHmbJTBS9pCagADNSFfJzFgCBJrsN9FRgUhQdzq59V8rfl3opbhb81AP1iBhZOfXMS
         3dObaNG84H5dJfa78A54U4zO7Zs4sXfCZ4OKT6fIUM9VSUzRIN5l5G/2wwziNTWosEJQ
         z3bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to:user-agent;
        bh=QQChGS24ElWH5fX74BmVpeqrazmwvLdKwMYOPj/et3g=;
        b=pIbSc6LAfC9KmYX1TZSQD78YZEd3xzOSYEkKN4XndXbqPWUG6R7gFhg9vYHbC13zSm
         Y5qPRcgNEowTt5S7HGhT8BV74eji4OBqmtCxlUgmiapLOLnqEksL9AunaMgazwhhPdox
         75OCwel6ILxoZrVnbGkB1Kk0V6D1L2uOY6XzYO3ZnK6wCeU/W9Aq/9Y+XgWGAxhJV16C
         PZJ6iO6CK57+2lVqaAbfVWolNMv3JqjN8vnu9dbW6Q3e/6+UACBFhBW0MVkSpHK3RkhB
         TmCbH8KpllwWrlE5tWxNvahCdQ1Eljyc4xISER1xZva5qR95BN8uYDFqxGguVg5aMCAi
         QFcw==
X-Gm-Message-State: AOAM530h+iqEsCGPFz8wBhdk0oa2214uIp/0tR3+8pmRK18nY/MMrxuO
        6kUBeA2neNHp8JGQL2+oXYageYp9whuTPg==
X-Google-Smtp-Source: ABdhPJywZczYQGTXEQeLGTETE7J1Y2pEQ23Kafu+Pf1k1hBiYqhMkuMdJSYJWtIKM/FJHiubmeAQJA==
X-Received: by 2002:a17:902:7005:b029:ec:aead:23fa with SMTP id y5-20020a1709027005b02900ecaead23famr32548436plk.30.1619654373704;
        Wed, 28 Apr 2021 16:59:33 -0700 (PDT)
Received: from smallstar.local.net (n49-192-36-100.sun3.vic.optusnet.com.au. [49.192.36.100])
        by smtp.gmail.com with ESMTPSA id x77sm709716pfc.19.2021.04.28.16.59.31
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Apr 2021 16:59:32 -0700 (PDT)
Sender: Duncan Roe <duncan.roe2@gmail.com>
From:   Duncan Roe <duncan_roe@optusnet.com.au>
X-Google-Original-From: Duncan Roe <dunc@smallstar.local.net>
Date:   Thu, 29 Apr 2021 09:59:27 +1000
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Netfilter Development <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnetfilter_queue v2] build: doc: `make distcheck`
 passes with doxygen enabled
Message-ID: <20210428235927.GA1962@smallstar.local.net>
Mail-Followup-To: Jan Engelhardt <jengelh@inai.de>,
        Netfilter Development <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
References: <s6o3s8n-8486-r468-728s-4384736oqq@vanv.qr>
 <20210422093544.5460-1-duncan_roe@optusnet.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210422093544.5460-1-duncan_roe@optusnet.com.au>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Jan,

Are you satisfied with the v2 patch?

If so, could you maybe post an "Acked-by", "Reviewed-by" or LGTM please?

Pablo has not responded and there is a bit of urgency in that I have 3 more
patchsets before the next LNFQ release and was hoping the release would get out
in time for Slackware 15.0.

Cheers ... Duncan.

On Thu, Apr 22, 2021 at 07:35:44PM +1000, Duncan Roe wrote:
> The main fix is to move fixmanpages.sh to inside doxygen/Makefile.am.
>
> This means that in future, developers need to update doxygen/Makefile.am
> when they add new functions and source files, since fixmanpages.sh is deleted.
>
> Signed-off-by: Duncan Roe <duncan_roe@optusnet.com.au>
> ---
> v2: Implement suggestions from Jan Engelhardt <jengelh@inai.de>
>
>  Makefile.am         |  1 -
>  configure.ac        | 11 +++++--
>  doxygen/Makefile.am | 76 +++++++++++++++++++++++++++++++++++++++++++--
>  fixmanpages.sh      | 66 ---------------------------------------
>  4 files changed, 82 insertions(+), 72 deletions(-)
>  delete mode 100755 fixmanpages.sh
>
> diff --git a/Makefile.am b/Makefile.am
> index 796f0d0..a5b347b 100644
> --- a/Makefile.am
> +++ b/Makefile.am
> @@ -10,4 +10,3 @@ pkgconfigdir = $(libdir)/pkgconfig
>  pkgconfig_DATA = libnetfilter_queue.pc
>
>  EXTRA_DIST += Make_global.am
> -EXTRA_DIST += fixmanpages.sh
> diff --git a/configure.ac b/configure.ac
> index 32e4990..bdbee98 100644
> --- a/configure.ac
> +++ b/configure.ac
> @@ -37,9 +37,10 @@ AC_CONFIG_FILES([Makefile src/Makefile utils/Makefile examples/Makefile
>  	include/linux/Makefile include/linux/netfilter/Makefile])
>
>  AC_ARG_WITH([doxygen], [AS_HELP_STRING([--with-doxygen],
> -	    [create doxygen documentation [default=no]])],
> -	    [], [with_doxygen=no])
> -AS_IF([test "x$with_doxygen" = xyes], [
> +	    [create doxygen documentation])],
> +	    [with_doxygen="$withval"], [with_doxygen=yes])
> +
> +AS_IF([test "x$with_doxygen" != xno], [
>  	AC_CHECK_PROGS([DOXYGEN], [doxygen])
>  	AC_CHECK_PROGS([DOT], [dot], [""])
>  	AS_IF([test "x$DOT" != "x"],
> @@ -48,6 +49,10 @@ AS_IF([test "x$with_doxygen" = xyes], [
>  ])
>
>  AM_CONDITIONAL([HAVE_DOXYGEN], [test -n "$DOXYGEN"])
> +AS_IF([test "x$DOXYGEN" = x], [
> +	dnl Only run doxygen Makefile if doxygen installed
> +	AC_MSG_WARN([Doxygen not found - continuing without Doxygen support])
> +])
>  AC_OUTPUT
>
>  echo "
> diff --git a/doxygen/Makefile.am b/doxygen/Makefile.am
> index 0f99feb..b4268a5 100644
> --- a/doxygen/Makefile.am
> +++ b/doxygen/Makefile.am
> @@ -1,4 +1,6 @@
>  if HAVE_DOXYGEN
> +
> +# Be sure to add new source files to this table
>  doc_srcs = $(top_srcdir)/src/libnetfilter_queue.c  \
>             $(top_srcdir)/src/nlmsg.c               \
>             $(top_srcdir)/src/extra/checksum.c      \
> @@ -9,8 +11,74 @@ doc_srcs = $(top_srcdir)/src/libnetfilter_queue.c  \
>             $(top_srcdir)/src/extra/icmp.c          \
>             $(top_srcdir)/src/extra/pktbuff.c
>
> -doxyfile.stamp: $(doc_srcs) $(top_srcdir)/fixmanpages.sh
> -	rm -rf html man && cd .. && doxygen doxygen.cfg >/dev/null && ./fixmanpages.sh
> +doxyfile.stamp: $(doc_srcs) Makefile.am
> +	rm -rf html man
> +
> +# Test for running under make distcheck.
> +# If so, sibling src directory will be empty:
> +# move it out of the way and symlink the real one while we run doxygen.
> +	[ -f ../src/Makefile.in ] || \
> +{ set -x; cd ..; mv src src.distcheck; ln -s $(top_srcdir)/src; }
> +
> +	cd ..; doxygen doxygen.cfg >/dev/null
> +
> +	[ ! -d ../src.distcheck ] || \
> +{ set -x; cd ..; rm src; mv src.distcheck src; }
> +
> +# Keep this command up to date after adding new functions and source files.
> +# The command has to be a single line so the functions work
> +# (hence ";\" at the end of every line but the last).
> +	main() { set -e; cd man/man3; rm -f _*;\
> +setgroup LibrarySetup nfq_open;\
> +  add2group nfq_close nfq_bind_pf nfq_unbind_pf;\
> +setgroup Parsing nfq_get_msg_packet_hdr;\
> +  add2group nfq_get_nfmark nfq_get_timestamp nfq_get_indev nfq_get_physindev;\
> +  add2group nfq_get_outdev nfq_get_physoutdev nfq_get_indev_name;\
> +  add2group nfq_get_physindev_name nfq_get_outdev_name;\
> +  add2group nfq_get_physoutdev_name nfq_get_packet_hw;\
> +  add2group nfq_get_skbinfo;\
> +  add2group nfq_get_uid nfq_get_gid;\
> +  add2group nfq_get_secctx nfq_get_payload;\
> +setgroup Queue nfq_fd;\
> +  add2group nfq_create_queue nfq_destroy_queue nfq_handle_packet nfq_set_mode;\
> +  add2group nfq_set_queue_flags nfq_set_queue_maxlen nfq_set_verdict;\
> +  add2group nfq_set_verdict2 nfq_set_verdict_batch;\
> +  add2group nfq_set_verdict_batch2 nfq_set_verdict_mark;\
> +setgroup ipv4 nfq_ip_get_hdr;\
> +  add2group nfq_ip_set_transport_header nfq_ip_mangle nfq_ip_snprintf;\
> +  setgroup ip_internals nfq_ip_set_checksum;\
> +setgroup ipv6 nfq_ip6_get_hdr;\
> +  add2group nfq_ip6_set_transport_header nfq_ip6_mangle nfq_ip6_snprintf;\
> +setgroup nfq_cfg nfq_nlmsg_cfg_put_cmd;\
> +  add2group nfq_nlmsg_cfg_put_params nfq_nlmsg_cfg_put_qmaxlen;\
> +setgroup nfq_verd nfq_nlmsg_verdict_put;\
> +  add2group nfq_nlmsg_verdict_put_mark nfq_nlmsg_verdict_put_pkt;\
> +setgroup nlmsg nfq_nlmsg_parse;\
> +  add2group nfq_nlmsg_put;\
> +setgroup pktbuff pktb_alloc;\
> +  add2group pktb_data pktb_len pktb_mangle pktb_mangled;\
> +  add2group pktb_free;\
> +  setgroup otherfns pktb_tailroom;\
> +    add2group pktb_mac_header pktb_network_header pktb_transport_header;\
> +    setgroup uselessfns pktb_push;\
> +      add2group pktb_pull pktb_put pktb_trim;\
> +setgroup tcp nfq_tcp_get_hdr;\
> +  add2group nfq_tcp_get_payload nfq_tcp_get_payload_len;\
> +  add2group nfq_tcp_snprintf nfq_tcp_mangle_ipv4 nfq_tcp_mangle_ipv6;\
> +  setgroup tcp_internals nfq_tcp_compute_checksum_ipv4;\
> +    add2group nfq_tcp_compute_checksum_ipv6;\
> +setgroup udp nfq_udp_get_hdr;\
> +  add2group nfq_udp_get_payload nfq_udp_get_payload_len;\
> +  add2group nfq_udp_mangle_ipv4 nfq_udp_mangle_ipv6 nfq_udp_snprintf;\
> +  setgroup udp_internals nfq_udp_compute_checksum_ipv4;\
> +    add2group nfq_udp_compute_checksum_ipv6;\
> +setgroup Printing nfq_snprintf_xml;\
> +setgroup icmp nfq_icmp_get_hdr;\
> +};\
> +setgroup() { mv $$1.3 $$2.3; BASE=$$2; };\
> +add2group() { for i in $$@; do ln -sf $$BASE.3 $$i.3; done; };\
> +main
> +
>  	touch doxyfile.stamp
>
>  CLEANFILES = doxyfile.stamp
> @@ -21,4 +89,8 @@ clean-local:
>  install-data-local:
>  	mkdir -p $(DESTDIR)$(mandir)/man3
>  	cp --no-dereference --preserve=links,mode,timestamps man/man3/*.3 $(DESTDIR)$(mandir)/man3/
> +
> +# make distcheck needs uninstall-local
> +uninstall-local:
> +	rm -r $(DESTDIR)$(mandir) man html doxyfile.stamp
>  endif
> diff --git a/fixmanpages.sh b/fixmanpages.sh
> deleted file mode 100755
> index 02064ab..0000000
> --- a/fixmanpages.sh
> +++ /dev/null
> @@ -1,66 +0,0 @@
> -#!/bin/bash -p
> -#set -x
> -function main
> -{
> -  set -e
> -  cd doxygen/man/man3
> -  rm -f _*
> -  setgroup LibrarySetup nfq_open
> -    add2group nfq_close nfq_bind_pf nfq_unbind_pf
> -  setgroup Parsing nfq_get_msg_packet_hdr
> -    add2group nfq_get_nfmark nfq_get_timestamp nfq_get_indev nfq_get_physindev
> -    add2group nfq_get_outdev nfq_get_physoutdev nfq_get_indev_name
> -    add2group nfq_get_physindev_name nfq_get_outdev_name
> -    add2group nfq_get_physoutdev_name nfq_get_packet_hw
> -    add2group nfq_get_skbinfo
> -    add2group nfq_get_uid nfq_get_gid
> -    add2group nfq_get_secctx nfq_get_payload
> -  setgroup Queue nfq_fd
> -    add2group nfq_create_queue nfq_destroy_queue nfq_handle_packet nfq_set_mode
> -    add2group nfq_set_queue_flags nfq_set_queue_maxlen nfq_set_verdict
> -    add2group nfq_set_verdict2 nfq_set_verdict_batch
> -    add2group nfq_set_verdict_batch2 nfq_set_verdict_mark
> -  setgroup ipv4 nfq_ip_get_hdr
> -    add2group nfq_ip_set_transport_header nfq_ip_mangle nfq_ip_snprintf
> -    setgroup ip_internals nfq_ip_set_checksum
> -  setgroup ipv6 nfq_ip6_get_hdr
> -    add2group nfq_ip6_set_transport_header nfq_ip6_mangle nfq_ip6_snprintf
> -  setgroup nfq_cfg nfq_nlmsg_cfg_put_cmd
> -    add2group nfq_nlmsg_cfg_put_params nfq_nlmsg_cfg_put_qmaxlen
> -  setgroup nfq_verd nfq_nlmsg_verdict_put
> -    add2group nfq_nlmsg_verdict_put_mark nfq_nlmsg_verdict_put_pkt
> -  setgroup nlmsg nfq_nlmsg_parse
> -    add2group nfq_nlmsg_put
> -  setgroup pktbuff pktb_alloc
> -    add2group pktb_data pktb_len pktb_mangle pktb_mangled
> -    add2group pktb_free
> -    setgroup otherfns pktb_tailroom
> -      add2group pktb_mac_header pktb_network_header pktb_transport_header
> -      setgroup uselessfns pktb_push
> -        add2group pktb_pull pktb_put pktb_trim
> -  setgroup tcp nfq_tcp_get_hdr
> -    add2group nfq_tcp_get_payload nfq_tcp_get_payload_len
> -    add2group nfq_tcp_snprintf nfq_tcp_mangle_ipv4 nfq_tcp_mangle_ipv6
> -    setgroup tcp_internals nfq_tcp_compute_checksum_ipv4
> -      add2group nfq_tcp_compute_checksum_ipv6
> -  setgroup udp nfq_udp_get_hdr
> -    add2group nfq_udp_get_payload nfq_udp_get_payload_len
> -    add2group nfq_udp_mangle_ipv4 nfq_udp_mangle_ipv6 nfq_udp_snprintf
> -    setgroup udp_internals nfq_udp_compute_checksum_ipv4
> -      add2group nfq_udp_compute_checksum_ipv6
> -  setgroup Printing nfq_snprintf_xml
> -  setgroup icmp nfq_icmp_get_hdr
> -}
> -function setgroup
> -{
> -  mv $1.3 $2.3
> -  BASE=$2
> -}
> -function add2group
> -{
> -  for i in $@
> -  do
> -    ln -sf $BASE.3 $i.3
> -  done
> -}
> -main
> --
> 2.17.5
>
