From: Giacomo <delleceste@gmail.com>
Subject: de-masqueraded packets hook/priority
Date: Mon, 27 Jul 2009 11:33:13 +0200
Message-ID: <885896af0907270233o42ea04aaof34a0d7890b783f9@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:34303 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755883AbZG0JdO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 27 Jul 2009 05:33:14 -0400
Received: by ewy26 with SMTP id 26so3008478ewy.37
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Jul 2009 02:33:13 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi to all.
A simple question.

I imagine that de - masquerading packets pertaining to a masquerade
connection, for instance for ppp0 interface
are registered in

NF_INET_PRE_ROUTING hook with priority NF_IP_PRI_NAT_DST    (*)

Is that right?

Placing a network traffic analyzer (wireshark) listening to ppp0 i see
de masq packets coming back with ppp0's
network address.

Writing a simple module that hooks as above and changes DST address
makes the traffic analyzer show
reply packets (de masqueraded) with their new address already set...

For this I am asking whether the assumptions in (*) are correct.

Thanks



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
