From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [RFC nft] flush/delete ruleset
Date: Wed, 30 Oct 2013 17:30:26 +0100
Message-ID: <CAOkSjBjB_zJuiFA1xy2ueGoZUbg3iZnbAujM_CMTpB4EvvgYkQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:41966 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752984Ab3J3Qas convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Oct 2013 12:30:48 -0400
Received: by mail-la0-f51.google.com with SMTP id ea20so1283095lab.24
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Oct 2013 09:30:47 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi there!

I have in mind two new operations for nftables CLI tool.

The first is `nft flush ruleset'. This op wipes all rules in all
tables in the ruleset, all AFs.

I found interesting to have this option in order to have a fast way to
clean all rules.
Also, this operation is handy for the second operation, see below.
In iptables we had `iptables -F', but it requires to specify the
table. In nft, we currently have `nft flush table x' and `nft flush
chain x', that do same kind of operations.

The second one is `nft delete ruleset'. This op delete all
chain/tables in the ruleset, all AFs.
This operation fails if chains still have rules, so a previous `flush
ruleset' is needed.
In iptables, we have `iptables -X' to delete chains and no way to
delete tables. Likewise, in nft we currently have `nft delete chain x'
and `nft delete table x'.

Some pros:
 * quite good shortcuts for big firewalls.
 * nft gain in flexibility.
 * allows to easily go to a 'filtering' state zero. Some users still
reboot the system for this... Custom firewalls in top of nftables may
also benefit.
 * we can end with 'list/flush/delete/add' ruleset operations. For me,
it makes sense to have almost all operations (list,flush,delete,add..)
in all possible objects (ruleset,table,chain,set,rule).
 * handy for netfilter hackers (debugging purposes, saves lot of
retyping, other hacks, etc ...)
 * easy to implement in current nft code.
 * relatively small patches, small new code to maintain.

Some cons:
 * a good point for users to have nuclear mistakes.
 * those commands show no mercy. Perhaps an optional '-I' switch that
ask for confirmation would give some additional protection.
 * in small rulesets, there are no need for shortcuts.
 * Despite small patches, additional code to maintain.

The code for these two operations are almost ready, at testing stage.

Please comment.

Best regards.
--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
