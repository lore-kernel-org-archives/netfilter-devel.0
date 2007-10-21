From: Krzysztof =?UTF-8?Q?Mo=C5=9Bcicki?= <stivi@kity.pl>
Subject: Set compile problem with kernel 2.6.23.1
Date: Sun, 21 Oct 2007 17:16:29 +0200
Message-ID: <1192979789.4860.0.camel@steven.kity.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from psyche.piasta.pl ([83.175.144.5]:53186 "EHLO psyche.piasta.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028AbXJUPXM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 21 Oct 2007 11:23:12 -0400
Received: from unknown ([127.0.0.2])
 by localhost (psyche.piasta.pl [127.0.0.2]) (amavisd-new, port 10628)
 id 09346-08 for <netfilter-devel@vger.kernel.org>;
 Sun, 21 Oct 2007 17:16:29 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi

While trying to compile vanilla kernel 2.6.23.1 with
patch-o-matic-ng-20070828 or patch-o-matic-ng-20071020 (using extension
set) I'm getting following error:

  CC [M]  net/ipv4/netfilter/ipt_SET.o
  CC [M]  net/ipv4/netfilter/ip_set.o
net/ipv4/netfilter/ip_set.c:1931: error: unknown field `use' specified
in initializer
make[3]: *** [net/ipv4/netfilter/ip_set.o] Error 1
make[2]: *** [net/ipv4/netfilter] Error 2
make[1]: *** [net/ipv4] Error 2
make: *** [net] Error 2


Please help.

--=20
Krzysztof Mo=C5=9Bcicki

-
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
