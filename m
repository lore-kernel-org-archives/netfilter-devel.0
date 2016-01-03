From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: add xtables-config-parser.h to BUILT_SOURCES
Date: Sun, 3 Jan 2016 23:14:32 +0100
Message-ID: <20160103221432.GA25072@salvia>
References: <1451497890-23629-1-git-send-email-gustavo@zacarias.com.ar>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Gustavo Zacarias <gustavo@zacarias.com.ar>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:48160 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752543AbcACWOj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Jan 2016 17:14:39 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id B200B1022AE
	for <netfilter-devel@vger.kernel.org>; Sun,  3 Jan 2016 23:14:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A354BDA808
	for <netfilter-devel@vger.kernel.org>; Sun,  3 Jan 2016 23:14:35 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id CF0EADA7FF
	for <netfilter-devel@vger.kernel.org>; Sun,  3 Jan 2016 23:14:33 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1451497890-23629-1-git-send-email-gustavo@zacarias.com.ar>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 30, 2015 at 02:51:30PM -0300, Gustavo Zacarias wrote:
> Otherwise other sources that use it might be built before it's ready leading
> to build failure, for example by iptables/nft.c

Applied, thanks Gustavo.
