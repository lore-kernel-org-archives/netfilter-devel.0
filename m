From: Giacomo <delleceste@gmail.com>
Subject: linked lists, locking in softirq context -- no ideas ??
Date: Fri, 27 Feb 2009 09:07:31 +0100
Message-ID: <885896af0902270007i7d3c5750n2c2c80f9a559665d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f177.google.com ([209.85.219.177]:46816 "EHLO
	mail-ew0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665AbZB0IHe convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Feb 2009 03:07:34 -0500
Received: by ewy25 with SMTP id 25so1102528ewy.37
        for <netfilter-devel@vger.kernel.org>; Fri, 27 Feb 2009 00:07:31 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi to all...
do not know if the mailing list received this message - nobody can answ=
er?

Thanks so much

giacomo


---------- Forwarded message ----------
=46rom: Giacomo <delleceste@gmail.com>
Date: 2009/2/23
Subject: linked lists, locking in softirq context
To: netfilter-devel <netfilter-devel@vger.kernel.org>



Harald Welte's "The journey of a packet through the Linux 2.6.10
network stack" article says that packet travelling inside
linux kernel 2.6 (the receive / input part) runs in softirq context.

Hooking with netfilter's hooks in a kernel module, i need to read for
each packet received a list of rules.

Since in input and prerouting hooks the context is softirq (perhaps
also in forward?), I need some read lock
feature.

I currently use RCU lists and, while reading lists I use

READ

read_lock_bh()

together with list_for_each_rcu()

When changing, or flushing, rules, I use

WRITE

spin_lock() + list_add_tail_rcu() (adding)

or spin_lock() + list_for_each_entry() (for listing and then freeing
with list_del_rcu() and call_rcu() )

The question is:

- is the read part above correct? - do I really need _bh()? or should
I use simply read_lock() ?

Thanks in advance

Giacomo



--
Giacomo S.
http://www.giacomos.it

- - - - - - - - - - - - - - - - - - - - - -

* Aprile 2008: iqfire-wall, un progetto
=A0open source che implementa un
=A0filtro di pacchetti di rete per Linux,
=A0e` disponibile per il download qui:
=A0http://sourceforge.net/projects/ipfire-wall

* Informazioni e pagina web ufficiale:
=A0http://www.giacomos.it/iqfire/index.html

- - - - - - - - - - - - - - - - - - - - - -

=A0. '' =A0`.
: =A0 :' =A0 =A0:
=A0`. =A0` '
=A0 =A0`- Debian GNU/Linux -- The power of freedom
=A0 =A0 =A0 =A0http://www.debian.org



--=20
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
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
