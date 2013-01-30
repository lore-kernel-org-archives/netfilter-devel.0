From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 0/3] Introduce aliases for matches and targets
Date: Wed, 30 Jan 2013 21:56:11 +0100
Message-ID: <20130130205611.GA3287@localhost>
References: <1359405175-4394-1-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slan-550-85.anhosting.com ([174.127.110.175]:48282 "EHLO
	slan-550-85.anhosting.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755991Ab3A3WGd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jan 2013 17:06:33 -0500
Content-Disposition: inline
In-Reply-To: <1359405175-4394-1-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jozsef,

On Mon, Jan 28, 2013 at 09:32:52PM +0100, Jozsef Kadlecsik wrote:
> The next patches introduce the alias support for matches and targets in
> iptables. The goal is to keep the old syntax of matches/targets merged
> into "super" matches/targets. This way firewall scripts can run unmodified,
> using the old extensions.
> 
> The NOTRACK alias requires a new revision of the CT target (flags are checked
> in the current revision). Next follows the kernel part of the patches. Until
> the new revision is missing, instead of the warning, a notice is printed
> to the users.

I'm proposing a new version for the CT target. I wanted to merge
common code of revision 0 and 1 since time ago, then it follows the
patch to add the new flag.

> Please comment/ACK the patches.

I like this.
