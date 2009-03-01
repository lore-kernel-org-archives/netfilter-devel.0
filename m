From: Giacomo <delleceste@gmail.com>
Subject: retrieve pmtu from skb
Date: Sun, 1 Mar 2009 13:18:18 +0100
Message-ID: <885896af0903010418p2dced6c0w5460e9235c1016ca@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f177.google.com ([209.85.219.177]:59393 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752034AbZCAMSV (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Mar 2009 07:18:21 -0500
Received: by ewy25 with SMTP id 25so1795458ewy.37
        for <netfilter-devel@vger.kernel.org>; Sun, 01 Mar 2009 04:18:18 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Good morning to all.
Is there a way to retrieve the pmtu, given a skbuff of an outgoing new
connection?
If yes, is there any attention to pay about locking?

Thanks in advance.

Giacomo.

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
