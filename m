From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/2] iptables (userspace): add secmark match
Date: Wed, 20 Mar 2013 00:32:33 +0100
Message-ID: <20130319233233.GA4172@localhost>
References: <5135E9AF.6010800@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Eric Paris <eparis@redhat.com>,
	Netfilter Core Team <netfilter-devel@vger.kernel.org>,
	Fedora SELinux Users <selinux@lists.fedoraproject.org>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39000 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756759Ab3CSXcj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Mar 2013 19:32:39 -0400
Content-Disposition: inline
In-Reply-To: <5135E9AF.6010800@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 05, 2013 at 12:48:47PM +0000, Mr Dash Four wrote:
> This patch is part of the userspace changes needed for the "secmark" match
> in iptables.

SELinux already provides the framework to define your network policy
based on the secmark. I don't see why we need this in iptables.
