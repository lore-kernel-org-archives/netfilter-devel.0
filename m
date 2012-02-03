From: joe@clnt.de
Subject: alignment problem with ebt_among on ppc
Date: Fri, 3 Feb 2012 08:21:24 +0100 (CET)
Message-ID: <Pine.LNX.4.64.1202030819151.17732@brian.int.clnt.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fep34.mx.upcmail.net ([62.179.121.52]:63035 "EHLO
	fep34.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753270Ab2BCHYp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Feb 2012 02:24:45 -0500
Received: from edge03.upcmail.net ([192.168.13.238])
          by viefep17-int.chello.at
          (InterMail vM.8.01.05.04 201-2260-151-105-20111014) with ESMTP
          id <20120203072121.SCXE25410.viefep17-int.chello.at@edge03.upcmail.net>
          for <netfilter-devel@vger.kernel.org>;
          Fri, 3 Feb 2012 08:21:21 +0100
Received: from localhost ([127.0.0.1])
	by brian.fritz.box with esmtp (Exim 4.72)
	(envelope-from <joe@clnt.de>)
	id 1RtDSW-0004dw-Kl
	for netfilter-devel@vger.kernel.org; Fri, 03 Feb 2012 08:21:24 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

hi,

i'm currently faced with an alignment problem of ebt_among with ppc
architecture.
Trying to add a rule using the among extension leads to the following
syslog entry:

ebtables: among: wrong size: 2104 against expected 2100, rounded to 2100

I tried to analyze the problem and I observed that there have been several
problems regarding EBT_ALIGN in the past with x86_64 and sparc
architecure. But I didn't find anything about ppc.

What I've seen is that ebt_among extension of ebtables uses
__alignof__(_xt_align) while the corresponding kernel module uses
__alignof__(ebt_replace) to determin the alignment in EBT_ALIGN().

These are the results of these values on different platforms:

                                 x86     x86_64  ppc
__alignof__(_xt_align)          4       8       8
__alignof__(ebt_replace)        4       8       4

So I assume here we can see why ebtales fails to add rules which use the
among extension.

I'm using kernel 2.6.33 and ebtables 2.0.10-4

Is this a known issue or are there any suggestions how to circumvent this
problem?
Thankyou very much.

Best regards
Joerg
