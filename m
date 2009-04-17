From: Giacomo <delleceste@gmail.com>
Subject: question about names as addresses in iptables
Date: Fri, 17 Apr 2009 15:02:16 +0200
Message-ID: <885896af0904170602vdf7a448xd53d5e8642d14d90@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ew0-f176.google.com ([209.85.219.176]:40069 "EHLO
	mail-ew0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100AbZDQNCS (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 17 Apr 2009 09:02:18 -0400
Received: by ewy24 with SMTP id 24so210785ewy.37
        for <netfilter-devel@vger.kernel.org>; Fri, 17 Apr 2009 06:02:17 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Good morning

man iptables says

-s, --source [!] address[/mask]
	      Source  specification.   Address can be either a network name, a
	      hostname (please note that specifying any name  to  be  resolved
	      with a remote query such as DNS is a really bad idea), a network
	      IP address (with /mask), or a plain IP address.  The mask can be
	      either  a  network mask or a plain number, specifying the number
	      of 1's at the left side of the network mask.  Thus, a mask of 24
	      is  equivalent  to  255.255.255.0.   A  "!"  argument before the
	      address specification inverts the sense of the address. The flag
	      --src is an alias for this option.

the same goes for destination...

the question is:

how is name resolution implemented?

Is userspace iptables resolving names into ips and loading them into
the kernel when i impart the command line
and then are they left as they are into the kernel?

If an ip address changes its value, mantaining the same name, is it
necessary to reload the rule?

If a name has more than one ip address (the name has aliases), are all
the ip addresses loaded into the rule?
(as an example www.google.com has three ips). If yes, how can I see
the numeric values into the iptable rule?

Thanks for the answer, assumed that "a remote query such as DNS is a
really bad idea", I am interested in
the concept implementation.

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
