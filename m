From: Giacomo <delleceste@gmail.com>
Subject: netlink question
Date: Tue, 10 Feb 2009 21:33:38 +0100
Message-ID: <885896af0902101233t6f1a7054y90c86f9d93ebf112@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f21.google.com ([209.85.219.21]:38900 "EHLO
	mail-ew0-f21.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755382AbZBJUdk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 10 Feb 2009 15:33:40 -0500
Received: by ewy14 with SMTP id 14so24255ewy.13
        for <netfilter-devel@vger.kernel.org>; Tue, 10 Feb 2009 12:33:38 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Dear netfilter list.

I would like to ask you about a strange issue.

I wrote a software that communicates with kernel space via the netlink socket.

A data structure of 212 byte (+16 byte of netlink header) used to
travel from user to kernel space and viceversa
without any problem.
Inside kernel space, socket buffer is allocated with alloc_skb
together with GFP_ATOMIC flag.

Since a couple of fields in the structure have changed

from __u32 source_ip  to __u32 source_ip[50];

and equivalently __u32 dest_ip became  __u32 dest_ip[50];

__u16 sport;   ->  __u16 sport[50];

__u16 dport;   ->  __u16 dport[50];

kernel began to crash, reporting, among other messages "scheduling
while atomic".

The data structure is now grown up to 788bytes (+16 netlink header).

I introduced in the functions responsible of netlink communication
some printks reporting the value of
in_atomic();

while with little data structures I always read in_atomic() == 0,  in
the same actions, but with the bigger
data structure, sometimes i read in_atomic() == 1


Is there a possible reason for this behaviour?

If yes, how should the behaviour be corrected?

Thanks in advance.

Giacomo, Italy.





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
