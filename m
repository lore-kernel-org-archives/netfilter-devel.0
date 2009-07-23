From: Giacomo <delleceste@gmail.com>
Subject: A general question about IP fragmented packets and netfilter
Date: Thu, 23 Jul 2009 08:40:07 +0200
Message-ID: <885896af0907222340m77ef2d6p9767421a608cfdee@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f226.google.com ([209.85.219.226]:54666 "EHLO
	mail-ew0-f226.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626AbZGWGkM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jul 2009 02:40:12 -0400
Received: by ewy26 with SMTP id 26so753675ewy.37
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Jul 2009 23:40:10 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Good morning to all.

I would like to ask you some points concerning IP fragmented packets
arriving on an interface and the
way they are handled by the netfilter modules, in particular what is
the situation in the netfilter hooks.

Starting from NF_IP_PRE_ROUTING, where destination NAT and
de-masquerading takes place, do
the packets arrive fragmented - and netfilter takes care of the
fragments - or do they arrive already
reassembled from the IP stack?

In the first case, what is, generally speaking, the technique adopted
to track fragmented IP packets
and assign each of them to the correct flow?

In the second case, if I register with netfilter NF_IP_PRE_ROUTING
hook, which is the correct "priority"
to assign during registration to receive packets already reassembled?

Thanks in advance.

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
