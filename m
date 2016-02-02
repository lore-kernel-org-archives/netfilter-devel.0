From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: mirrors of nftable repo
Date: Tue, 2 Feb 2016 19:24:21 +0100
Message-ID: <20160202182421.GA6246@salvia>
References: <CAKrM2XkN1skiSfPMpLGMqUKy3r8=qqQKmEwEKLCc+W3ruYHEUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Piyush Pangtey <gokuvsvegita@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57286 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755462AbcBBSYb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Feb 2016 13:24:31 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id D978A6C1E
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Feb 2016 19:24:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id CBF17DA807
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Feb 2016 19:24:27 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id EC968DA807
	for <netfilter-devel@vger.kernel.org>; Tue,  2 Feb 2016 19:24:25 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAKrM2XkN1skiSfPMpLGMqUKy3r8=qqQKmEwEKLCc+W3ruYHEUw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 02, 2016 at 05:30:37PM +0000, Piyush Pangtey wrote:
> cannot clone any repo from netfilter.org. are there any mirrors
> available(upto date) ?

$ git clone git://git.netfilter.org/nftables
Cloning into 'nftables'...
remote: Counting objects: 4560, done.
remote: Compressing objects: 100% (3576/3576), done.
remote: Total 4560 (delta 3485), reused 1315 (delta 969)
Receiving objects: 100% (4560/4560), 879.21 KiB | 690.00 KiB/s, done.
Resolving deltas: 100% (3485/3485), done.
Checking connectivity... done.

This is working here.
