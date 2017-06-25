From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [netfilter-core] Heap overflow in xt_geoip.c
Date: Sun, 25 Jun 2017 21:45:21 +0200 (CEST)
Message-ID: <nycvar.YFH.7.76.1706252143110.6159@n3.vanv.qr>
References: <CAFwXZv_CZanNT=MTcA7G_5YtgJ07+2Xf-poXy2dNfv+V=j4iLw@mail.gmail.com> <59482edb.6385df0a.e863a.a6ca.GMRIR@mx.google.com> <6358d530697ad564236584c07d2f3cb2@opensec.fr> <20170621161642.GB6117@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Loic <hackurx@opensec.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from a3.inai.de ([88.198.180.161]:41954 "EHLO a3.inai.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751341AbdFYTpX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Jun 2017 15:45:23 -0400
In-Reply-To: <20170621161642.GB6117@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2017-06-21 18:16, Pablo Neira Ayuso wrote:

>Hi Loic,
>
>On Tue, Jun 20, 2017 at 08:31:26PM +0200, Loic wrote:
>> Hi,
>> 
>> I think there is a problem in the geoip code because I detect this:
>> 
>> grep -ar "cicus.162_313 max" /usr/src/xtables-addons-2.12/extensions/
>> /usr/src/xtables-addons-2.12/extensions/xt_geoip.o:cicus.162_313 max,
>> count: 7, decl: vmalloc; num: 1; context: fndecl;
>> /usr/src/xtables-addons-2.12/extensions/xt_geoip.o:/usr/src/xtables-addons-2.12/extensions/xt_geoip.ccicus.162_313
>> max, count: 5, decl: size_overflow MARK_NO copy_user_generic 3; num:
>> 0; context: attr;
>> /usr/src/xtables-addons-2.12/extensions/xt_geoip.ko:cicus.162_313 max,
>> count: 7, decl: vmalloc; num: 1; context: fndecl;
>> /usr/src/xtables-addons-2.12/extensions/xt_geoip.ko:/usr/src/xtables-addons-2.12/extensions/xt_geoip.ccicus.162_313
>> max, count: 5, decl: size_overflow MARK_NO copy_user_generic 3; num:
>> 0; context: attr;
>> 
>> You maybe can draw inspiration for resolve this by "vmalloc_usercopy" in
>> PAX_USERCOPY from PaX/Grsecurity.
>
>This is out of tree code, Cc'ing Jan, who maintains this.

What is cicus and what are these messages supposed to tell me?
