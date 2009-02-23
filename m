From: Giacomo <delleceste@gmail.com>
Subject: linked lists, locking in softirq context
Date: Mon, 23 Feb 2009 11:49:14 +0100
Message-ID: <885896af0902230249r21c1c1f5h17c1cd63f38679ef@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.25]:37143 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752906AbZBWKtR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Feb 2009 05:49:17 -0500
Received: by ey-out-2122.google.com with SMTP id 25so440210eya.37
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Feb 2009 02:49:15 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Good morning

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
