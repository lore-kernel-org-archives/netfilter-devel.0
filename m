From: Loic <hackurx@opensec.fr>
Subject: Re: [netfilter-core] Heap overflow in xt_geoip.c
Date: Mon, 26 Jun 2017 20:41:13 +0200
Message-ID: <f2aa016334df64f2e88dc7b0cb802762@opensec.fr>
References: <CAFwXZv_CZanNT=MTcA7G_5YtgJ07+2Xf-poXy2dNfv+V=j4iLw@mail.gmail.com>
 <59482edb.6385df0a.e863a.a6ca.GMRIR@mx.google.com>
 <6358d530697ad564236584c07d2f3cb2@opensec.fr> <20170621161642.GB6117@salvia>
 <nycvar.YFH.7.76.1706252143110.6159@n3.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.opensec.fr ([82.236.169.210]:56552 "EHLO mail.opensec.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751403AbdFZStk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Jun 2017 14:49:40 -0400
In-Reply-To: <nycvar.YFH.7.76.1706252143110.6159@n3.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Le 2017-06-25 21:45, Jan Engelhardt a écrit :
> On Wednesday 2017-06-21 18:16, Pablo Neira Ayuso wrote:
> 
>> Hi Loic,
>> 
>> On Tue, Jun 20, 2017 at 08:31:26PM +0200, Loic wrote:
>>> Hi,
>>> 
>>> I think there is a problem in the geoip code because I detect this:
>>> 
>>> grep -ar "cicus.162_313 max" /usr/src/xtables-addons-2.12/extensions/
>>> /usr/src/xtables-addons-2.12/extensions/xt_geoip.o:cicus.162_313 max,
>>> count: 7, decl: vmalloc; num: 1; context: fndecl;
>>> /usr/src/xtables-addons-2.12/extensions/xt_geoip.o:/usr/src/xtables-addons-2.12/extensions/xt_geoip.ccicus.162_313
>>> max, count: 5, decl: size_overflow MARK_NO copy_user_generic 3; num:
>>> 0; context: attr;
>>> /usr/src/xtables-addons-2.12/extensions/xt_geoip.ko:cicus.162_313 
>>> max,
>>> count: 7, decl: vmalloc; num: 1; context: fndecl;
>>> /usr/src/xtables-addons-2.12/extensions/xt_geoip.ko:/usr/src/xtables-addons-2.12/extensions/xt_geoip.ccicus.162_313
>>> max, count: 5, decl: size_overflow MARK_NO copy_user_generic 3; num:
>>> 0; context: attr;
>>> 
>>> You maybe can draw inspiration for resolve this by "vmalloc_usercopy" 
>>> in
>>> PAX_USERCOPY from PaX/Grsecurity.
>> 
>> This is out of tree code, Cc'ing Jan, who maintains this.
> 
> What is cicus and what are these messages supposed to tell me?

This comes from the size_overflow plugin :
https://github.com/ephox-gcc-plugins/size_overflow

After I'm not an expert I just detected this:
grep -ai size_overflow "xt_geoip.ko"
/usr/src/xtables-addons-2.12/extensions/xt_geoip.ccicus.162_313 max, 
count: 5, decl: # size_overflow MARK_NO copy_user_generic 3; num: 0; 
context: attr;

-- 
Best regards,

Loic
