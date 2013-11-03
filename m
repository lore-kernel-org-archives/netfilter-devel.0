From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH iptables 3/3] android: build: Blacklist TCPOPTSTRIP on
 systems that lack TCPOPT_*
Date: Sun, 3 Nov 2013 22:48:34 +0100
Message-ID: <20131103214834.GA10858@localhost>
References: <1382813433-20890-1-git-send-email-cernekee@gmail.com>
 <1382813433-20890-4-git-send-email-cernekee@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Kevin Cernekee <cernekee@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42952 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752635Ab3KCVsj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Nov 2013 16:48:39 -0500
Content-Disposition: inline
In-Reply-To: <1382813433-20890-4-git-send-email-cernekee@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Oct 26, 2013 at 11:50:33AM -0700, Kevin Cernekee wrote:
> Bionic's <netinet/tcp.h> is missing constants needed to build this module,
> so have autoconf check for this condition before trying to build it.

The blacklist infrastructure is there to skip extensions whose
dependencies are missing, ie. a library. I don't want to use it for
this hack. Please, fix bionic.
