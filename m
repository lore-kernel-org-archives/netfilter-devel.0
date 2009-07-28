From: Giacomo <delleceste@gmail.com>
Subject: include netinet/tcp.h or linux/tcp.h in userspace applications?
Date: Tue, 28 Jul 2009 13:43:06 +0200
Message-ID: <885896af0907280443t5cf1553at5be4c0d07133185e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:48613 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639AbZG1LnI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Jul 2009 07:43:08 -0400
Received: by ey-out-2122.google.com with SMTP id 9so994937eyd.37
        for <netfilter-devel@vger.kernel.org>; Tue, 28 Jul 2009 04:43:07 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi to all.

A simple question. Does anybody know what are linux/tcp.h (and friends
- udp.h... ) netinet/tcp.h ... specifically aimed at?
In particular, a userspace application which shares tcp/udp/icmp data
structures with the kernel space, which include should
include?

I used to include linux/  headers, but since kernel 2.6.30 and
kernel-headers 2.6.30 g++ fails complaining

/usr/include/linux/tcp.h:72: error: '__u32 __fswab32(__u32)' cannot
appear in a constant-expression
/usr/include/linux/tcp.h:72: error: a function call cannot appear in a
constant-expression
/usr/include/linux/tcp.h:73: error: '__u32 __fswab32(__u32)' cannot
appear in a constant-expression
/usr/include/linux/tcp.h:73: error: a function call cannot appear in a
constant-expression
....

Thanks for any advice.

Giacomo

-- 
Giacomo S.
http://www.giacomos.it

- - - - - - - - - - - - - - - - - - - - - -

* Aprile 2008: iqfire-wall, un progetto
  open source che implementa un
  filtro di pacchetti di rete per Linux,
  e` disponibile per il download qui:
  http://sourceforge.net/projects/ipfire-wall

* Informazioni e pagina web ufficiale:
  http://www.giacomos.it/iqfire/index.html

- - - - - - - - - - - - - - - - - - - - - -

 . ''  `.
:   :'    :
 `.  ` '
    `- Debian GNU/Linux -- The power of freedom
        http://www.debian.org
