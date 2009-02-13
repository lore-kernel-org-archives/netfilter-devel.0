From: Giacomo <delleceste@gmail.com>
Subject: netlink callback and socket buffer.
Date: Fri, 13 Feb 2009 21:35:48 +0100
Message-ID: <885896af0902131235q68b79efbu5c25d29fd9bd1661@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:51441 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064AbZBMUfv (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Feb 2009 15:35:51 -0500
Received: by ewy14 with SMTP id 14so1144490ewy.13
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Feb 2009 12:35:48 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Good evening to everybody.

In recent kernels (>=2.6.24) netlink_kernel_create() callback function
has the following signature:


(void *) function(struct sk_buff* skb);

while before it was

(void  *) function(struct sock *skctrl, int len)

In the latter, i used to call skb_dequeue, obtain the skb and then,
once data was extracted, I used
to kfree_skb(skb); where skb is a sk_buff* obtained by skb_dequeue();

Now (with the (void *) function(struct sk_buff* skb)  callback) I get
data from skb but DO NOT HAVE
TO kfree_skb() it...

Is it true?  Is it automatically freed by the kernel once the callback returns?

Thanks in advance.

Giacomo S.


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
