From: Jesper Dangaard Brouer <jdb@comx.dk>
Subject: Xtables-addon compile failure agains iptables-git (works agains
	v1.4.2)
Date: Thu, 12 Feb 2009 16:03:59 +0100
Message-ID: <1234451039.21893.14.camel@localhost.localdomain>
Reply-To: jdb@comx.dk
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developers <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from lanfw001a.cxnet.dk ([87.72.215.196]:58221 "EHLO
	lanfw001a.cxnet.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755993AbZBLPWl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Feb 2009 10:22:41 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

I wanted to try out your Xtables-addon tree (at
git://dev.medozas.de/xtables-addons).

It fails compiling it against the latest iptables git tree, but works
against tag v1.4.2.

The problem is that:
 1. param_act() has been renamed to xtables_param_act()
 2. flags has been renamed P_* -> XTF_*
 3. string_to_number() converted to xtables_strtoui()
 4. strtonum() is renamed to xtables_strtoui()

I tracked down the problem to some of your own commits:

 a41545ca7cde: libxtables: prefix/order - param_act
 5f2922cfc0bb: libxtables: prefix/order - strtoui

How do you want to keep Xtables-addon compatible between v1.4.2 and
v1.4.3?

-- 
Med venlig hilsen / Best regards
  Jesper Brouer
  ComX Networks A/S
  Linux Network developer
  Cand. Scient Datalog / MSc.
  Author of http://adsl-optimizer.dk
  LinkedIn: http://www.linkedin.com/in/brouer
