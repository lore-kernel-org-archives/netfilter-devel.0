From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] src: consolidate XML/JSON exportation for rule
Date: Sun, 12 Feb 2017 14:50:54 +0100
Message-ID: <20170212135054.GA14847@salvia>
References: <20170208154252.GA32430@Novo>
 <20170212134843.GA14359@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46198 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751233AbdBLNu7 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 12 Feb 2017 08:50:59 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id DE13196EC1
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Feb 2017 14:50:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CE88FDA7F7
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Feb 2017 14:50:57 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C0D8ADA7F7
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Feb 2017 14:50:55 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170212134843.GA14359@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Feb 12, 2017 at 02:48:43PM +0100, Pablo Neira Ayuso wrote:
> On Wed, Feb 08, 2017 at 09:12:53PM +0530, Shivani Bhardwaj wrote:
> > This completes the XML/JSON exportation using the new buffer class for
> > rule.
> 
> Applied, thanks Shivani.

Hm, there's some problem here, look:

drule.c: In function 'nftnl_rule_export':
rule.c:677:27: warning: passing argument 3 of 'vsnprintf' makes pointer from integer without a cast
   vsnprintf(b.buf, b.len, flags, expr);
                           ^
In file included from ../include/utils.h:4:0,
                 from ../include/internal.h:7,
                 from rule.c:11:
/usr/include/stdio.h:390:12: note: expected 'const char *
__restrict__' but argument is of type 'uint32_t'  extern int vsnprintf (char *__restrict __s, size_t __maxlen,
            ^
rule.c:677:34: warning: passing argument 4 of 'vsnprintf' from incompatible pointer type   vsnprintf(b.buf, b.len, flags, expr);
   vsnprintf(b.buf, b.len, flags, expr);
                                  ^
In file included from ../include/utils.h:4:0,
                 from ../include/internal.h:7,
                 from rule.c:11:
/usr/include/stdio.h:390:12: note: expected 'struct __va_list_tag *' but argument is of type 'struct nftnl_expr *'
 extern int vsnprintf (char *__restrict __s, size_t __maxlen,
            ^

