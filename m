From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH 2/4] rule: when listing all sets, don't print empty
 tables
Date: Tue, 5 Jan 2016 12:19:35 +0100
Message-ID: <20160105111935.GB8791@salvia>
References: <145190990642.22285.2420592085262978551.stgit@r2d2.cica.es>
 <145190991185.22285.13328538132434564559.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:38714 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752173AbcAELTl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jan 2016 06:19:41 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id E337F1324D4
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Jan 2016 12:19:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D4621DA85F
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Jan 2016 12:19:39 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 234C3DA860
	for <netfilter-devel@vger.kernel.org>; Tue,  5 Jan 2016 12:19:36 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <145190991185.22285.13328538132434564559.stgit@r2d2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 04, 2016 at 01:18:31PM +0100, Arturo Borrero Gonzalez wrote:
> The table may contain sets, but they are anonymous.

Also applied, thanks.
