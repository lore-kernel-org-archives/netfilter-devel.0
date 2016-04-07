From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] conntrack: Replace remaining occurances of --src, --dst
 options with --orig-src, --orig-dst
Date: Thu, 7 Apr 2016 11:40:25 +0200
Message-ID: <20160407094025.GA1919@salvia>
References: <1459838692-17303-1-git-send-email-mart.frauenlob@chello.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Mart Frauenlob <mart.frauenlob@chello.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47939 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755686AbcDGJkb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Apr 2016 05:40:31 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 7407513C0F1
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 11:40:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 59F15DA391
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 11:40:29 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 88EEEDA3A2
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 11:40:26 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1459838692-17303-1-git-send-email-mart.frauenlob@chello.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 05, 2016 at 08:44:52AM +0200, Mart Frauenlob wrote:
> The old options --src and --dst were still defined at two places.
> Replaced with according --orig-src and --orig-dst entry.

--src is valid shortcut.

This breaks backward compatibility.
