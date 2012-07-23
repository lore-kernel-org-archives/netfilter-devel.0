From: Arif Hossain <aftnix@gmail.com>
Subject: Hash table implementation
Date: Mon, 23 Jul 2012 16:07:13 +0600
Message-ID: <1343038033.3431.47.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
To: kernelnewbies <kernelnewbies@kernelnewbies.org>,
	netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35036 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751916Ab2GWKRn (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Jul 2012 06:17:43 -0400
Received: by pbbrp8 with SMTP id rp8so10654277pbb.19
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Jul 2012 03:17:43 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

This commit shows that jenkins hash
function(http://en.wikipedia.org/wiki/Jenkins_hash_function) is
implemented in kernel :

commit 60d509c823cca21e77d537bd356785f7cfe8f0d1
Author: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Date:   Fri Dec 3 02:39:01 2010 +0000

    The new jhash implementation
 <snip>

I could not find any good documentation describing how to use it. Only
thing i could do is to read codes which uses it, like 

/net/netfilter/xt_NFQUEUE.c. I have got some idea about how it works.
But a good documentation would have been better. Like this one
describing linux's implementation of doubly linked list :

http://isis.poly.edu/kulesh/stuff/src/klist/ 

It describes how i can use this even in user land code. If i could do
this for jhash then the understanding would have been better.

Cheers.

