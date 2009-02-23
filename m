From: Giacomo <delleceste@gmail.com>
Subject: Fwd: "kobject: does not have a release()function, it is broken and
	must be fixed. -- POSSIBLE SOLUTION?
Date: Mon, 23 Feb 2009 10:15:53 +0100
Message-ID: <885896af0902230115r481c521fja35328241eff7cf8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.172]:42243 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193AbZBWJPz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Feb 2009 04:15:55 -0500
Received: by ug-out-1314.google.com with SMTP id 39so219095ugf.37
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Feb 2009 01:15:53 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Could it be I used sock_release() on the netlink socket instead of

netlink_kernel_release() call inside the module cleanup function()?

Thanks a lot.

Giacomo


---------- Forwarded message ----------
From: Giacomo <delleceste@gmail.com>
Date: 2009/2/23
Subject: "kobject: does not have a release()function, it is broken and
must be  fixed.
To: netfilter-devel <netfilter-devel@vger.kernel.org>


Good morning to all.

Can anyone explain what I have to do in my module to avoid this warning?
Is there any example?

I am currently implementing


static int __init ini(void)
{

}

static void __exit fini(void)
{
}

to initialize and cleanup module.

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
