From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [ANNOUNCE] libnftnl 1.0.8 release
Date: Fri, 13 Oct 2017 02:42:14 +0200 (CEST)
Message-ID: <nycvar.YFH.7.76.1710130238430.10708@n3.vanv.qr>
References: <20171012234148.GA23593@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        netfilter-announce@lists.netfilter.org, lwn@lwn.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a3.inai.de ([88.198.180.161]:41410 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753427AbdJMAmQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 12 Oct 2017 20:42:16 -0400
In-Reply-To: <20171012234148.GA23593@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2017-10-13 01:41, Pablo Neira Ayuso wrote:
>
>        libnftnl 1.0.8

Here's a buffer overflow reported by gcc:

expr/data_reg.c: In function 'nftnl_data_reg_json_parse':
expr/data_reg.c:69:27: warning: '%d' directive writing between 1 and 10 bytes into a region of size 2 [-Wformat-overflow=]
   sprintf(node_name, "data%d", i);
                           ^~
expr/data_reg.c:69:22: note: directive argument in the range [0, 2147483647]
   sprintf(node_name, "data%d", i);
                      ^~~~~~~~
In file included from /usr/include/stdio.h:862:0,
                 from expr/data_reg.c:12:
/usr/include/bits/stdio2.h:33:10: note: '__builtin___sprintf_chk' output between 6 and 15 bytes into a destination of size 6
   return __builtin___sprintf_chk (__s, __USE_FORTIFY_LEVEL - 1,
          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
       __bos (__s), __fmt, __va_arg_pack ());
       ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


AFAICS it's triggerable when reg->len > 396.
