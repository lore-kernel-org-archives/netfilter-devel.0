From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft] regarding sets names length
Date: Thu, 8 Oct 2015 13:23:34 +0200
Message-ID: <CAOkSjBiv1M9QE2bjTBTh9Yr1n_5w2c69Rg1ZpoxUroga7oncgA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f172.google.com ([209.85.212.172]:36859 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756492AbbJHLXy convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Oct 2015 07:23:54 -0400
Received: by wicgb1 with SMTP id gb1so20843720wic.1
        for <netfilter-devel@vger.kernel.org>; Thu, 08 Oct 2015 04:23:53 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I'm trying to migrate a iptables/ip6tables ruleset to nftables.

I've found that the current IFNAMSIZ limitation for set names is
annoying because there are lots of ipset sets which needs to move to
nftables which cannot do it straight forward.
Also, the error reporting for this is very poor (reported by the
kernel in a generic way).

This example illustrates both issues:

 % nft add set inet filter external_services { type ipv4_addr\; }
<cmdline>:1:1-57: Error: Could not process rule: Numerical result out o=
f range
add set inet filter external_services { type ipv4_addr; }
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Also, I don't find any documentation apart of the source code itself :-=
)

I would suggest:
 * check names length also in userspace to show a better error message
 * enlarge set names sizes

best regards


PD: Just updated
http://wiki.nftables.org/wiki-nftables/index.php/Sets#Named_sets with
info about the name length.
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
