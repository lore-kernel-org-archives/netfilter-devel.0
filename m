From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: libnetfilter_acct now available at git.netfilter.org
Date: Thu, 29 Dec 2011 19:47:41 +0100
Message-ID: <20111229184741.GA6405@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34455 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751221Ab1L2Srq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 29 Dec 2011 13:47:46 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi!

JFYI: I just uploaded libnetfilter_acct to git.netfilter.org.

http://git.netfilter.org/cgi-bin/gitweb.cgi?p=libnetfilter_acct.git;a=summary

This library provides the programming interface (API) to the Netfilter
extended accounting infrastructure. It includes the documentation in
doxygen format and a couple of examples.

The first client of this library will be the `nfacct' tool.

I'm thinking about including this tool into the iptables tree, instead
of distributing it separately, but I may change my mind. Let me know
if you have any preference.

The initial 1.0.0 release is scheduled by when Linux kernel 3.3 will
be released (I insist, this is not wrong, Linux kernel 3.3, not 3.2).

I'll find some spare time to set up the libnetfilter_acct space in
www.netfilter.org soon.

Have fun with it!
