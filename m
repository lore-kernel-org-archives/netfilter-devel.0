From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] iptables: Replace gethostbyname() with getaddrinfo()
Date: Sun, 3 Jul 2016 11:08:46 +0200
Message-ID: <20160703090846.GA9480@salvia>
References: <1458219439-561-1-git-send-email-rpnkpr@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arpan Kapoor <rpnkpr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53733 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbcGCJIz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Jul 2016 05:08:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id F01B5E5A5E
	for <netfilter-devel@vger.kernel.org>; Sun,  3 Jul 2016 11:08:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id E0DDC9EBA5
	for <netfilter-devel@vger.kernel.org>; Sun,  3 Jul 2016 11:08:53 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 032A864493
	for <netfilter-devel@vger.kernel.org>; Sun,  3 Jul 2016 11:08:52 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1458219439-561-1-git-send-email-rpnkpr@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 17, 2016 at 06:27:19PM +0530, Arpan Kapoor wrote:
> Make the function host_to_ipaddr() similar to host_to_ip6addr(),
> using getaddrinfo() instead of the obsoleted gethostbyname().

Applied, thanks.
