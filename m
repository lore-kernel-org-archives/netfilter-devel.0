From: Giacomo <delleceste@gmail.com>
Subject: why does tcpmss_reverse_mtu() in xt_TCPMSS.c call dst_release()
Date: Mon, 2 Mar 2009 14:08:11 +0100
Message-ID: <885896af0903020508x25bbe37evb5d6ffd6f4f2c582@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:25689 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234AbZCBNIO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 2 Mar 2009 08:08:14 -0500
Received: by nf-out-0910.google.com with SMTP id d21so492434nfb.21
        for <netfilter-devel@vger.kernel.org>; Mon, 02 Mar 2009 05:08:12 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Good morning. A simple question this time:

why does tcpmss_reverse_mtu() in xt_TCPMSS.c call dst_release() after dst_mtu()?

I saw that dst_release decrements reference count of the passed struct
dst_entry*.

Is it called because of dst_mtu() or because of ip_route_output_key() ?

thank you.

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
