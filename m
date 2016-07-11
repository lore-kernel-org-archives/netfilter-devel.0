From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] fix off-by-one in DecodeQ931
Date: Mon, 11 Jul 2016 12:33:33 +0200
Message-ID: <20160711103333.GA20955@salvia>
References: <57814fde.87a2370a.19369.49af@mx.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Toby DiPasquale <toby@cbcg.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51883 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030311AbcGKKdl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 11 Jul 2016 06:33:41 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 96D0717DB65
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Jul 2016 12:33:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 803A9FAB51
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Jul 2016 12:33:40 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 57C81FC61A
	for <netfilter-devel@vger.kernel.org>; Mon, 11 Jul 2016 12:33:38 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <57814fde.87a2370a.19369.49af@mx.google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jul 13, 2016 at 02:59:00PM -0400, Toby DiPasquale wrote:
> fix off-by-one in DecodeQ931
> 
> This patch corrects an off-by-one error in the DecodeQ931 function in
> the nf_conntrack_h323 module. This error could result in reading off
> the end of a Q.931 frame.

Applied to nf-next, thanks.

I have fixed the timestamp since your clock doesn't look right as this
was placed way ahead in the future.
