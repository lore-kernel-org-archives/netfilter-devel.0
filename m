Return-Path: <SRS0=M6WU=7W=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CDB38C433E0
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Jun 2020 15:50:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A77C72072F
	for <netfilter-devel@archiver.kernel.org>; Tue,  9 Jun 2020 15:50:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XnMmX8eG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730603AbgFIPut (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 9 Jun 2020 11:50:49 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:45628 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728888AbgFIPut (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 9 Jun 2020 11:50:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591717847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=poPzeOsfuu7RewsCWpIeht7MsGALyjGJoLPBZqLSS/E=;
        b=XnMmX8eGeVBrFqOo5P9Jx/9Z/kkQVschN/ivmleIEjNLC7EmFzS3VuOP0yXvlY/g/q0qm3
        u1mYKiqNNjzm/dJxzVcqITEsT//lOA+6f8Xk1S0dKKEpwIsLPK3lj67yTus7YNC1+hlXI+
        hTNVzYKrYsnHfoVLgXKdChjJIYx95dM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-278-KCMXRus6NMGuWsk1IL8INA-1; Tue, 09 Jun 2020 11:50:44 -0400
X-MC-Unique: KCMXRus6NMGuWsk1IL8INA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7BAE71B18BC3;
        Tue,  9 Jun 2020 15:50:43 +0000 (UTC)
Received: from madcap2.tricolour.ca (unknown [10.10.110.54])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id B915679598;
        Tue,  9 Jun 2020 15:50:39 +0000 (UTC)
Date:   Tue, 9 Jun 2020 11:50:36 -0400
From:   Richard Guy Briggs <rgb@redhat.com>
To:     Phil Sutter <phil@nwl.cc>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [iptables PATCH] build: Fix for failing 'make uninstall'
Message-ID: <20200609155036.ei3otptnxdgt5wwc@madcap2.tricolour.ca>
References: <20200609110728.12682-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200609110728.12682-1-phil@nwl.cc>
User-Agent: NeoMutt/20180716
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2020-06-09 13:07, Phil Sutter wrote:
> Support for uninstalling is severely broken:
> 
> - extensions/GNUmakefile.in defines an 'install' target but lacks a
>   respective 'uninstall' one, causing 'make uninstall' abort with an
>   error message.
> 
> - iptables/Makefile.am defines an 'install-exec-hook' to create the
>   binary symlinks which are left in place after 'make uninstall'.
> 
> Fix these problems by defining respective targets containing code copied
> from automake-generated uninstall targets.
> 
> While being at it, add a few more uninstall-hooks removing custom
> directories created by 'make install' if they are empty afterwards.
> 
> Reported-by: Richard Guy Briggs <rgb@redhat.com>
> Signed-off-by: Phil Sutter <phil@nwl.cc>

That's much cleaner, thanks Phil.

Tested-by: Richard Guy Briggs <rgb@redhat.com>

> ---
>  extensions/GNUmakefile.in | 15 ++++++++++++++-
>  include/Makefile.am       |  5 +++++
>  iptables/Makefile.am      | 23 +++++++++++++++++++++++
>  utils/Makefile.am         |  5 +++++
>  4 files changed, 47 insertions(+), 1 deletion(-)
> 
> diff --git a/extensions/GNUmakefile.in b/extensions/GNUmakefile.in
> index 0842a55354e4b..956ccb38b2ab9 100644
> --- a/extensions/GNUmakefile.in
> +++ b/extensions/GNUmakefile.in
> @@ -79,7 +79,7 @@ targets_install :=
>  
>  .SECONDARY:
>  
> -.PHONY: all install clean distclean FORCE
> +.PHONY: all install uninstall clean distclean FORCE
>  
>  all: ${targets}
>  
> @@ -92,6 +92,19 @@ install: ${targets_install} ${symlinks_install}
>  		cp -P ${symlinks_install} "${DESTDIR}${xtlibdir}/"; \
>  	fi;
>  
> +uninstall:
> +	dir=${DESTDIR}${xtlibdir}; { \
> +		test ! -d "$$dir" && test ! -f "$$dir" && test ! -r "$$dir"; \
> +	} || { \
> +		test -z "${targets_install}" || ( \
> +			cd "$$dir" && rm -f ${targets_install} \
> +		); \
> +		test -z "${symlinks_install}" || ( \
> +			cd "$$dir" && rm -f ${symlinks_install} \
> +		); \
> +		rmdir -p --ignore-fail-on-non-empty "$$dir"; \
> +	}
> +
>  clean:
>  	rm -f *.o *.oo *.so *.a {matches,targets}.man initext.c initext4.c initext6.c initextb.c initexta.c;
>  	rm -f .*.d .*.dd;
> diff --git a/include/Makefile.am b/include/Makefile.am
> index e69512092253a..ea34c2fef0d98 100644
> --- a/include/Makefile.am
> +++ b/include/Makefile.am
> @@ -10,3 +10,8 @@ endif
>  nobase_include_HEADERS += \
>  	libiptc/ipt_kernel_headers.h libiptc/libiptc.h \
>  	libiptc/libip6tc.h libiptc/libxtc.h libiptc/xtcshared.h
> +
> +uninstall-hook:
> +	dir=${includedir}/libiptc; { \
> +		test ! -d "$$dir" && test ! -f "$$dir" && test ! -r "$$dir"; \
> +	} || rmdir -p --ignore-fail-on-non-empty "$$dir"
> diff --git a/iptables/Makefile.am b/iptables/Makefile.am
> index 2024dbf5cb88c..bab094b7c6aa9 100644
> --- a/iptables/Makefile.am
> +++ b/iptables/Makefile.am
> @@ -111,3 +111,26 @@ install-exec-hook:
>  	for i in ${v6_sbin_links}; do ${LN_S} -f xtables-legacy-multi "${DESTDIR}${sbindir}/$$i"; done;
>  	for i in ${x_sbin_links}; do ${LN_S} -f xtables-nft-multi "${DESTDIR}${sbindir}/$$i"; done;
>  	${LN_S} -f iptables-apply "${DESTDIR}${sbindir}/ip6tables-apply"
> +
> +uninstall-hook:
> +	dir=${DESTDIR}${bindir}; { \
> +		test ! -d "$$dir" && test ! -f "$$dir" && test ! -r "$$dir"; \
> +	} || { \
> +		test -z "${vx_bin_links}" || ( \
> +			cd "$$dir" && rm -f ${vx_bin_links} \
> +		) \
> +	}
> +	dir=${DESTDIR}${sbindir}; { \
> +		test ! -d "$$dir" && test ! -f "$$dir" && test ! -r "$$dir"; \
> +	} || { \
> +		test -z "${v4_sbin_links}" || ( \
> +			cd "$$dir" && rm -f ${v4_sbin_links} \
> +		); \
> +		test -z "${v6_sbin_links}" || ( \
> +			cd "$$dir" && rm -f ${v6_sbin_links} \
> +		); \
> +		test -z "${x_sbin_links}" || ( \
> +			cd "$$dir" && rm -f ${x_sbin_links} \
> +		); \
> +		( cd "$$dir" && rm -f ip6tables-apply ); \
> +	}
> diff --git a/utils/Makefile.am b/utils/Makefile.am
> index d09a69749b85f..42bd973730194 100644
> --- a/utils/Makefile.am
> +++ b/utils/Makefile.am
> @@ -14,6 +14,11 @@ sbin_PROGRAMS += nfnl_osf
>  pkgdata_DATA += pf.os
>  
>  nfnl_osf_LDADD = ${libnfnetlink_LIBS}
> +
> +uninstall-hook:
> +	dir=${DESTDIR}${pkgdatadir}; { \
> +		test ! -d "$$dir" && test ! -f "$$dir" && test ! -r "$$dir"; \
> +	} || rmdir -p --ignore-fail-on-non-empty "$$dir"
>  endif
>  
>  if ENABLE_BPFC
> -- 
> 2.27.0
> 

- RGB

--
Richard Guy Briggs <rgb@redhat.com>
Sr. S/W Engineer, Kernel Security, Base Operating Systems
Remote, Ottawa, Red Hat Canada
IRC: rgb, SunRaycer
Voice: +1.647.777.2635, Internal: (81) 32635

