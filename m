From: Nepenthes Development Team <nepenthesdev@gmail.com>
Subject: socket match - add wildcard option [0/4]
Date: Sun, 25 Jul 2010 16:39:37 +0200
Message-ID: <AANLkTinEjM1Za9czyh8HVaHg8VDkbiTeTmjLh22Dm9Sj@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49938 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751061Ab0GYOji (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 25 Jul 2010 10:39:38 -0400
Received: by wyf19 with SMTP id 19so1512824wyf.19
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Jul 2010 07:39:37 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

I extended the socket match by the --wildcard option.
Currently sockets which are bound to wildcards are ignored for
matching, the new option allows to include sockets bound to
IN_ADDR_ANY too.

The default behaviour of not matching wildcard sockets is retained.

It is more than one patch, as the --transparent option was not merged
for iptables, even though it merged into the kernels netfilter code,
and in the meantime the empty option code for the socket match was
removed from iptables.

So we have 3 patches for iptables:

iptables-socket-match-empty-options.diff
 - revert removing the empty options from extensions/xt_socket.c

iptables-socket-match-add-transparent-option.diff
 - apply patch to add the --transparent option from
http://article.gmane.org/gmane.comp.security.firewalls.netfilter.devel/30246

iptables-socket-match-add-wildcard-option.diff
 - add wildcard option

The kernel side of netfilter had to be patched too, but there is only one patch:
linux-netfilter-socket-wildcard.diff
 - extend xt_socket by --wildcard option


As I'm new to netfilter/kernel patches, I'd appreciate any help to get
this feature merged.


Markus
