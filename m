Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D98EC433F5
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Oct 2021 23:36:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C3E060EB6
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Oct 2021 23:36:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231518AbhJKXi1 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Oct 2021 19:38:27 -0400
Received: from mail.netfilter.org ([217.70.188.207]:39346 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229576AbhJKXi1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Oct 2021 19:38:27 -0400
Received: from netfilter.org (unknown [78.30.35.141])
        by mail.netfilter.org (Postfix) with ESMTPSA id 3117163F09;
        Tue, 12 Oct 2021 01:34:50 +0200 (CEST)
Date:   Tue, 12 Oct 2021 01:36:21 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Ken-ichirou MATSUZAWA <chamas@h4.dion.ne.jp>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [RFC PATCH libnetfilter_log] src: support conntrack XML output
Message-ID: <YWTKdTsedRgM6Lgh@salvia>
References: <20210917220232.36907-1-chamas@h4.dion.ne.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210917220232.36907-1-chamas@h4.dion.ne.jp>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Sat, Sep 18, 2021 at 07:02:33AM +0900, Ken-ichirou MATSUZAWA wrote:
> This patch enables to let conntrack information including XML output.
> ---
>  Hi,
> 
> I think there are two issues. First, it deals with obsolete libnfnetlink
> internal data. The other is that the family of nfgenmsg is not available, so the
> ethernet hw protocol type is used. Are these acceptable?
> About ethernet type, should I use IP version from payload?

This is also creating an interdependency between the two libraries.

I'd suggest you expose the conntrack ID through the XML output of the
packet, this would require minimal parsing of the CT netlink attribute.

Then, print the conntrack object in XML including this ID too so
userspace can relate them?

> ----
> 
>  include/libnetfilter_log/libnetfilter_log.h |  4 +++
>  src/Makefile.am                             |  5 +++
>  src/libnetfilter_log.c                      | 35 +++++++++++++++++++++
>  3 files changed, 44 insertions(+)
> 
> diff --git a/include/libnetfilter_log/libnetfilter_log.h b/include/libnetfilter_log/libnetfilter_log.h
> index 6192fa3..a98a39e 100644
> --- a/include/libnetfilter_log/libnetfilter_log.h
> +++ b/include/libnetfilter_log/libnetfilter_log.h
> @@ -82,6 +82,10 @@ enum {
>  	NFLOG_XML_PHYSDEV	= (1 << 4),
>  	NFLOG_XML_PAYLOAD	= (1 << 5),
>  	NFLOG_XML_TIME		= (1 << 6),
> +#ifdef BUILD_NFCT
> +        NFLOG_XML_CT		= (1 << 7),
> +        NFLOG_XML_CT_TIMESTAMP	= (1 << 8),
> +#endif
>  	NFLOG_XML_ALL		= ~0U,
>  };
>  
> diff --git a/src/Makefile.am b/src/Makefile.am
> index 335c393..bc8da41 100644
> --- a/src/Makefile.am
> +++ b/src/Makefile.am
> @@ -37,3 +37,8 @@ libnetfilter_log_libipulog_la_LDFLAGS = -Wc,-nostartfiles	\
>  libnetfilter_log_libipulog_la_LIBADD = libnetfilter_log.la ${LIBNFNETLINK_LIBS}
>  libnetfilter_log_libipulog_la_SOURCES = libipulog_compat.c
>  endif
> +
> +if BUILD_NFCT
> +libnetfilter_log_la_LDFLAGS += $(LIBNETFILTER_CONNTRACK_LIBS)
> +libnetfilter_log_la_CPPFLAGS = ${AM_CPPFLAGS} ${LIBNETFILTER_CONNTRACK_CFLAGS} -DBUILD_NFCT
> +endif
> diff --git a/src/libnetfilter_log.c b/src/libnetfilter_log.c
> index 567049c..aa97b51 100644
> --- a/src/libnetfilter_log.c
> +++ b/src/libnetfilter_log.c
> @@ -33,6 +33,11 @@
>  #include <libnfnetlink/libnfnetlink.h>
>  #include <libnetfilter_log/libnetfilter_log.h>
>  
> +#ifdef BUILD_NFCT
> +#include <libmnl/libmnl.h>
> +#include <libnetfilter_conntrack/libnetfilter_conntrack.h>
> +#endif
> +
>  /**
>   * \mainpage
>   *
> @@ -907,6 +912,8 @@ do {								\
>   *	- NFLOG_XML_PHYSDEV: include the physical device information
>   *	- NFLOG_XML_PAYLOAD: include the payload (in hexadecimal)
>   *	- NFLOG_XML_TIME: include the timestamp
> + *	- NFLOG_XML_CT: include conntrack entry
> + *	- NFLOG_XML_CT_TIMESTAMP: include conntrack timestamp
>   *	- NFLOG_XML_ALL: include all the logging information (all flags set)
>   *
>   * You can combine this flags with an binary OR.
> @@ -1056,6 +1063,34 @@ int nflog_snprintf_xml(char *buf, size_t rem, struct nflog_data *tb, int flags)
>  		SNPRINTF_FAILURE(size, rem, offset, len);
>  	}
>  
> +#ifdef BUILD_NFCT
> +        if (flags & NFLOG_XML_CT) {
> +                struct nlattr *ctattr = (struct nlattr *)tb->nfa[NFULA_CT - 1];
> +                struct nf_conntrack *ct = nfct_new();
> +                unsigned int ct_flags = 0;
> +                uint8_t family = 0;
> +                uint16_t hw_proto = ntohs(ph->hw_protocol);
> +
> +                if (!ctattr) goto close_tag;
> +                if (hw_proto == 0x0800)
> +                        family = AF_INET;
> +                else if (hw_proto == 0x86dd)
> +                        family = AF_INET6;
> +                else
> +                        goto close_tag;
> +
> +                if (nfct_payload_parse(mnl_attr_get_payload(ctattr),
> +                                       mnl_attr_get_payload_len(ctattr),
> +                                       family, ct) < 0)
> +                        goto close_tag;
> +                if (flags & NFLOG_XML_CT_TIMESTAMP)
> +                        ct_flags |= NFCT_OF_TIMESTAMP;
> +                size = nfct_snprintf(buf + offset, rem, ct, 0, NFCT_O_XML,
> +                                     ct_flags);
> +		SNPRINTF_FAILURE(size, rem, offset, len);
> +        }
> +close_tag:
> +#endif
>  	size = snprintf(buf + offset, rem, "</log>");
>  	SNPRINTF_FAILURE(size, rem, offset, len);
>  
> -- 
> 2.30.2
> 
