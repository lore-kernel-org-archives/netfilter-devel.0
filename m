From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft PATCH] tests/shell: unload modules between tests
Date: Tue, 22 Mar 2016 20:17:15 +0100
Message-ID: <20160322191715.GA7519@salvia>
References: <145820368731.17259.3174729391842967272.stgit@r2d2.cica.es>
 <56EAF119.3070009@gmail.com>
 <CAOkSjBi7-XMcjZkc9N=RD9SsSZ4Xhc7TuNyA7vw5q0mbWRvfXw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Piyush Pangtey <gokuvsvegita@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43257 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837AbcCVTRT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 22 Mar 2016 15:17:19 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 1CF80EAA84
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Mar 2016 20:17:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0DCA1DA8FA
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Mar 2016 20:17:18 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3BA5DDA38B
	for <netfilter-devel@vger.kernel.org>; Tue, 22 Mar 2016 20:17:16 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAOkSjBi7-XMcjZkc9N=RD9SsSZ4Xhc7TuNyA7vw5q0mbWRvfXw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 18, 2016 at 09:41:31AM +0100, Arturo Borrero Gonzalez wrote:
> From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> 
> The modprobe call can return != 0 if, for example, a module was builtin and
> we are triying to remove it, so force return code of 0 at the end of the
> script.
> 
> This patch also adds the '-a' switch to modprobe so it doesn't stop unloading
> modules if one of them fails (for example, it was builtin).
> 
> While at it, fix several module names, for example: 'nft_bridge_reject' vs
> 'nft_reject_bridge', delete bogus module names.

Applied, thanks.
