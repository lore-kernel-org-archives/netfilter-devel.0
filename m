From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: H.239 support in the H.323 helper?
Date: Tue, 22 Sep 2009 11:44:45 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0909221132150.16779@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Jing Min Zhao <zhaojingmin@users.sourceforge.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:49270 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755869AbZIVJon (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Sep 2009 05:44:43 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

With the H.323 conntrack helper enabled on a machine running Gnugk, it 
cannot establish multiple channels for conferencing and presentation with 
a Polycom MGC MCU. The device wants to use H.239 and the helper cannot 
decode/interpret the protocol:

Sep 21 13:41:48 caladan kernel: nf_ct_h323: incomplete TPKT (fragmented?)

Could you consider to add H.239 support to the H.323 helper?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
