From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 4/9] libiptc: combine common types
Date: Mon, 12 Sep 2011 20:38:17 +0200
Message-ID: <20110912183817.GD3641@1984>
References: <1315755359-7012-1-git-send-email-jengelh@medozas.de>
 <1315755359-7012-5-git-send-email-jengelh@medozas.de>
 <20110912093603.GD2194@1984>
 <alpine.LNX.2.01.1109121241590.32300@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33062 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753386Ab1ILSiY (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Sep 2011 14:38:24 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1109121241590.32300@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 12, 2011 at 12:43:28PM +0200, Jan Engelhardt wrote:
> On Monday 2011-09-12 11:36, Pablo Neira Ayuso wrote:
> 
> >On Sun, Sep 11, 2011 at 05:35:53PM +0200, Jan Engelhardt wrote:
> >> Make an xt_chainlabel type out of ipt_chainlabel and ip6t_chainlabel,
> >> and add backward-API #defines. The ABI naturally does not change
> >> either, so no soversion bump.
> >> 
> >> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> >> ---
> >>  include/Makefile.am         |    2 +-
> >>  include/libiptc/libip6tc.h  |    3 ++-
> >>  include/libiptc/libiptc.h   |    3 ++-
> >>  include/libiptc/xtcshared.h |    6 ++++++
> >>  4 files changed, 11 insertions(+), 3 deletions(-)
> >>  create mode 100644 include/libiptc/xtcshared.h
> >> 
> >> diff --git a/include/Makefile.am b/include/Makefile.am
> >> index 0a1abea..6f7da59 100644
> >> --- a/include/Makefile.am
> >> +++ b/include/Makefile.am
> >> @@ -9,4 +9,4 @@ endif
> >>  
> >>  nobase_include_HEADERS += \
> >>  	libiptc/ipt_kernel_headers.h libiptc/libiptc.h \
> >> -	libiptc/libip6tc.h libiptc/libxtc.h
> >> +	libiptc/libip6tc.h libiptc/libxtc.h libiptc/xtcshared.h
> >> diff --git a/include/libiptc/libip6tc.h b/include/libiptc/libip6tc.h
> >> index 4f2d1f8..55e0bfc 100644
> >> --- a/include/libiptc/libip6tc.h
> >> +++ b/include/libiptc/libip6tc.h
> >> @@ -10,10 +10,11 @@
> >>  #	include <limits.h> /* INT_MAX in ip6_tables.h */
> >>  #endif
> >>  #include <linux/netfilter_ipv6/ip6_tables.h>
> >> +#include <libiptc/xtcshared.h>
> >>  
> >>  struct ip6tc_handle;
> >>  
> >> -typedef char ip6t_chainlabel[32];
> >> +#define ip6t_chainlabel xt_chainlabel
> >>  
> >>  #define IP6TC_LABEL_ACCEPT "ACCEPT"
> >>  #define IP6TC_LABEL_DROP "DROP"
> >> diff --git a/include/libiptc/libiptc.h b/include/libiptc/libiptc.h
> >> index 3497d6a..ccbf6bf 100644
> >> --- a/include/libiptc/libiptc.h
> >> +++ b/include/libiptc/libiptc.h
> >> @@ -10,6 +10,7 @@
> >>  #	include <limits.h> /* INT_MAX in ip_tables.h */
> >>  #endif
> >>  #include <linux/netfilter_ipv4/ip_tables.h>
> >> +#include <libiptc/xtcshared.h>
> >>  
> >>  #ifdef __cplusplus
> >>  extern "C" {
> >> @@ -17,7 +18,7 @@ extern "C" {
> >>  
> >>  struct iptc_handle;
> >>  
> >> -typedef char ipt_chainlabel[32];
> >> +#define ipt_chainlabel xt_chainlabel
> >>  
> >>  #define IPTC_LABEL_ACCEPT  "ACCEPT"
> >>  #define IPTC_LABEL_DROP    "DROP"
> >> diff --git a/include/libiptc/xtcshared.h b/include/libiptc/xtcshared.h
> >> new file mode 100644
> >> index 0000000..aaf87a4
> >> --- /dev/null
> >> +++ b/include/libiptc/xtcshared.h
> >> @@ -0,0 +1,6 @@
> >> +#ifndef _LIBXTC_SHARED_H
> >> +#define _LIBXTC_SHARED_H 1
> >> +
> >> +typedef char xt_chainlabel[32];
> >> +
> >> +#endif /* _LIBXTC_SHARED_H */
> >
> >I think this definition naturally belong to libxtc.h.
> 
> libiptc.h and libip6tc.h do not happen to include libxtc.h.
> As I am checking this again, libxtc.h should probably not even be 
> exported (only iptables's .c uses it).

My suggestion was becasue of the naming. libxtc.h sound like the
generic version of libiptc.h and libip6tc.h, but this doesn't seem to
be the case.

It's fine then.
