From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: conntrack-tools: fscanf() call usage
Date: Thu, 25 Aug 2011 14:22:58 +0200
Message-ID: <201108251422.59027.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from re04.intra2net.com ([82.165.46.26]:41352 "EHLO
	re04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753321Ab1HYMXD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Aug 2011 08:23:03 -0400
Received: from intranator.m.i2n (unknown [172.16.1.99])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by re04.intra2net.com (Postfix) with ESMTP id 2EB43300D3
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Aug 2011 14:23:01 +0200 (CEST)
Received: from localhost (intranator.m.i2n [127.0.0.1])
	by localhost (Postfix) with ESMTP id EED612AC54
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Aug 2011 14:23:00 +0200 (CEST)
Received: from storm.localnet (storm.m.i2n [172.16.1.2])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	(Authenticated sender: smtp-auth-user)
	by intranator.m.i2n (Postfix) with ESMTPSA id 69EC82AC52
	for <netfilter-devel@vger.kernel.org>; Thu, 25 Aug 2011 14:22:59 +0200 (CEST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi there,

the conntrack-tools have an fscanf() call without a
field width limit. There's a small issue with this:

[conntrack-tools/src/conntrack.c:1875]: (warning) scanf
without field width limits can crash with huge input data

Simple PoC can be found here:
http://marc.info/?l=gimp-developer&m=129567990905823&w=2

The code currently looks like this:
    "if (fscanf(fd, "%d", &count) != 1) {"


A limit to uint32 number of digits should be sane, also on 64bit machines.
That should still give us enough conntrack entries - even for Jesper.

I goofed around with scanf() some more and discovered that basically any 
field limit should do (even 2000+). Otherwise scanf() seems to use a fixed 
default buffer if the size is not known in advance.


Proposed change looks like this:
    "if (fscanf(fd, "%10d", &count) != 1) {"

Is that a sane thing to do or unnecessary?

Cheers,
Thomas
