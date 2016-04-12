From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] Not printing "nft" in iptables-restore-translate command
Date: Tue, 12 Apr 2016 23:57:20 +0200
Message-ID: <20160412215720.GA21056@salvia>
References: <1460360433-14709-1-git-send-email-guru2018@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Guruswamy Basavaiah <guru2018@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59799 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965132AbcDLV5a (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Apr 2016 17:57:30 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C33D3E839B
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Apr 2016 23:57:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A25E9FAB46
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Apr 2016 23:57:28 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1D67E1B30BE
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Apr 2016 23:57:26 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1460360433-14709-1-git-send-email-guru2018@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Apr 11, 2016 at 01:10:33PM +0530, Guruswamy Basavaiah wrote:
> No need to print "nft" in function do_command_xlate,
> if the function is called from iptables-restore-translate command.

Applied, thanks.
