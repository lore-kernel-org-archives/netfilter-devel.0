From: Giacomo <delleceste@gmail.com>
Subject: functions returning structs: is it perfectly legal and how efficient?
Date: Fri, 20 Feb 2009 10:15:57 +0100
Message-ID: <885896af0902200115t49d86f26t65d981f6fab603cf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.169]:15482 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753251AbZBTJQB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 20 Feb 2009 04:16:01 -0500
Received: by ug-out-1314.google.com with SMTP id 39so53658ugf.37
        for <netfilter-devel@vger.kernel.org>; Fri, 20 Feb 2009 01:15:57 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Good morning.

Suppose we have a very little data structure - in kernel space - :

typedef struct
{
  __u32 saddr, daddr;
  __u16 sport, dport;
  short int valid;
} net_quadruplet;


net_quadruplet get_quad_from_skb(const struct sk_buff* skb)
{
	net_quadruplet netquad;
	memset(&netquad, 0, sizeof(net_quadruplet));
        netquad.valid = 1;
        ...
        return netquad;
}

Is it perfectly legal?

Would it be more efficient

int get_quad_from_skb(const struct sk_buff* skb, net_quadruplet* nquad)
{
   int return_value = 0;
   /* modify nquad
      .....
   */
   return return_value;
}

?

Thank you very much for your attention.

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
