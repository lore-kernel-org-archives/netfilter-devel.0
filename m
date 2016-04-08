From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 5/5] conntrack: man: Add description of tables dying and
 unconfirmed.
Date: Fri, 8 Apr 2016 12:27:03 +0200
Message-ID: <20160408102703.GA2909@salvia>
References: <1460053902-2200-1-git-send-email-mart.frauenlob@chello.at>
 <1460053902-2200-6-git-send-email-mart.frauenlob@chello.at>
 <20160408101921.GD2142@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Mart Frauenlob <mart.frauenlob@chello.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38622 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753110AbcDHK1N (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Apr 2016 06:27:13 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id D925C13C0DC
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2016 12:27:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id CB193DA390
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2016 12:27:11 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id A75B6DA3A1
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Apr 2016 12:27:09 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160408101921.GD2142@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 08, 2016 at 12:19:21PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Apr 07, 2016 at 08:31:42PM +0200, Mart Frauenlob wrote:
> > +.PP
> > +The tables "dying" and "unconfirmed" are basically only useful for debugging purposes.
> > +Under normal operation, it is hard to see entries in any of them.
> > +There are corner cases, where it is valid to see entries in the
> > +unconfirmed table:
> > +1) when packets that are enqueued via nfqueue, or
> > +2) when conntrackd runs in event reliable mode.

BTW, I have reworded this:

"The tables "dying" and "unconfirmed" are basically only useful for
debugging purposes.  Under normal operation, it is hard to see entries
in any of them.  There are corner cases, where it is valid to see
entries in the unconfirmed table, eg. when packets that are enqueued
via nfqueue, and the dying table, eg. when conntrackd runs in event
reliable mode."

Actually, you can see entries in the dying table when conntrackd
reliable event mode is on, instead of the unconfirmed table.

Sorry about that.
