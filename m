From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: nfacct utility now available at git.netfilter.org
Date: Fri, 30 Dec 2011 21:11:47 +0100
Message-ID: <20111230201147.GA14014@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33409 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260Ab1L3ULv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 Dec 2011 15:11:51 -0500
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi!

The nfacct utility is now available at git.netfilter.org

http://git.netfilter.org/cgi-bin/gitweb.cgi?p=nfacct.git;a=summary

This utility allows you to manipulate the extended accounting
infrastructure.

# nfacct help
nfacct v1.0.0-beta: utility for the Netfilter extended accounting
infrastructure
Usage: nfacct command [parameters]...

Commands:
  list [reset]          List the accounting object table (and reset)
  add object-name       Add new accounting object to table
  delete object-name    Delete existing accounting object
  get object-name       Get existing accounting object
  flush                 Flush accounting object table
  version               Display version and disclaimer
  help                  Display this help message

This utility requires libmnl and libnetfilter_acct.

Have fun with it!
