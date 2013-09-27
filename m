From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [iptables PATCH] docs: use generic syslog reference in
 libxt_LOG.man
Date: Fri, 27 Sep 2013 16:32:46 +0200
Message-ID: <20130927143246.GA14740@localhost>
References: <1378503960-16261-1-git-send-email-ljlane@debian.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Laurence J. Lane" <ljlane@debian.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47444 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753649Ab3I0Ocv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Sep 2013 10:32:51 -0400
Content-Disposition: inline
In-Reply-To: <1378503960-16261-1-git-send-email-ljlane@debian.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 06, 2013 at 05:46:00PM -0400, Laurence J. Lane wrote:
> Fedora, ArchLinux, Ubuntu, and Debian, at the least, use
> alternative syslog daemons by default these days. Let's make
> the syslog reference generic.
> 
> Reference: http://bugs.debian.org/567564

OK, let's put this in the tree, thanks.
