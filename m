From: Tapas Mishra <mightydreams@gmail.com>
Subject: multiple streaming servers in a cloud
Date: Mon, 9 Aug 2010 13:09:19 +0530
Message-ID: <AANLkTin+tr25y=hLqfh4QqNLts=7mt14JAMotetRw1g9@mail.gmail.com>
References: <d4d404a4-7310-49e5-b43a-8b40696e9b73@x18g2000pro.googlegroups.com>
	<AANLkTinQmkWCj2uJtoKEztdeQz_D4rF7UY0un4t6UQi5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org,
	Open Source Flash Mailing List <osflash@osflash.org>,
	red5@osflash.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-px0-f174.google.com ([209.85.212.174]:65533 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751484Ab0HIHjU convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Aug 2010 03:39:20 -0400
Received: by pxi14 with SMTP id 14so3543660pxi.19
        for <netfilter-devel@vger.kernel.org>; Mon, 09 Aug 2010 00:39:19 -0700 (PDT)
In-Reply-To: <AANLkTinQmkWCj2uJtoKEztdeQz_D4rF7UY0un4t6UQi5@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

=A0I need some help.
If this is not the right forum to ask this question please give some
idea or let me know where should I ask this question.

I have multiple video streaming servers running on some machines
internally on LAN. (Red5 on Ubuntu 10.04)

=46or different subdomains.
i.e.
site1.mydomain.com
site2.mydomain.com
site3.mydomain.com
site4.mydomain.com



The front end to the world is apache2 on a Bastion Host.
I do not have a DNS running over there.


To be able to reach the streaming server I
embed a javascript in HTML pages
as follows
Code:

<embed .....
var=3D"rtmp://site1.my_domain.com"

>


the problem is the website are many

site1.mydomain.com
site2.mydomain.com
site3.mydomain.com
site4.mydomain.com

each on a separate physical server.

Each of these four have their own streaming servers the front end to
each of these four is a common Bastion Host.


If I run rtmp on each of the subdomains at a different port

how will I make sure
a request such as

rtmp://site1.mydomain.com
rtmp://site2.mydomain.com

goes to their respective servers.
from the front end server.

What do I need to handle in this case ?

IPTABLES came to mind instantly but from the client browser on
internet when some one requests
rtmp://site1.mydomain.com

how will I make sure this rtmp request is mapped to a port different
than
1935 as there are three other streaming servers which are also to
respond to their respective requests
?

=46or handling HTTP requests in this case I use Apache Reverse Proxy
but for rtmp requests I am not clear as which direction to proceed.


--
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
