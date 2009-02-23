From: Giacomo <delleceste@gmail.com>
Subject: "kobject: does not have a release()function, it is broken and must be
	fixed.
Date: Mon, 23 Feb 2009 09:38:02 +0100
Message-ID: <885896af0902230038o5b893855g6b7def7d1ea00865@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:13820 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751906AbZBWIiE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Feb 2009 03:38:04 -0500
Received: by nf-out-0910.google.com with SMTP id d21so413482nfb.21
        for <netfilter-devel@vger.kernel.org>; Mon, 23 Feb 2009 00:38:03 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

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
