From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: ip6tables: Warn about use of DROP in nat table
Date: Fri, 10 Jun 2016 12:32:12 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1606101231480.8575@nerf40.vanv.qr>
References: <37eef83b-8e81-b3ae-3dea-e51a913b3e2e@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Thomas Woerner <twoerner@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:44298 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752006AbcFJKcO (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jun 2016 06:32:14 -0400
In-Reply-To: <37eef83b-8e81-b3ae-3dea-e51a913b3e2e@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Friday 2016-06-10 12:16, Thomas Woerner wrote:

> in iptables.c there is a check of DROP usage in the nat table.In ip6tables,
> this check is not there.Is this intentional?

It must be an oversight, since IPv6 did not have nat back then.
