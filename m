From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: documentation bug: missing nat targets in man
Date: Tue, 09 Apr 2013 11:47:42 +0200
Message-ID: <5163E3BE.3040609@chello.at>
Reply-To: mart.frauenlob@chello.at
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fep34.mx.upcmail.net ([62.179.121.52]:34097 "EHLO
	fep34.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933110Ab3DIJs2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:48:28 -0400
Received: from edge04.upcmail.net ([192.168.13.239])
          by viefep34-int.chello.at
          (InterMail vM.8.01.05.05 201-2260-151-110-20120111) with ESMTP
          id <20130409094826.FZZU6461.viefep34-int.chello.at@edge04.upcmail.net>
          for <netfilter-devel@vger.kernel.org>;
          Tue, 9 Apr 2013 11:48:26 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

I noticed there's quite new DNAT, SNAT, NETMAP support for ip6tables, 
but that information is missing in the man page.
Anything else needed than just copying the according ipv4 *.man files?
If so, want me do prepare a patch?

Best regards

Mart
