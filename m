From: Patrick McHardy <kaber@trash.net>
Subject: Re: iptables leaks a file descriptor before fork/exec
Date: Tue, 06 Nov 2007 01:31:31 +0100
Message-ID: <472FB5E3.9090703@trash.net>
References: <20071102111412.6e9f67c4@atbws1.stanford.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Tim Fenn <fenn@stanford.edu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48306 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754355AbXKFAbs (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Nov 2007 19:31:48 -0500
In-Reply-To: <20071102111412.6e9f67c4@atbws1.stanford.edu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Tim Fenn wrote:
> As per a discussion I had on the fedora-selinux list
> (https://www.redhat.com/archives/fedora-selinux-list/2007-October/msg00033.html),
> Dan Walsh suggested filing a bug report in regards to a FD leak noticed
> when tracking iptables with selinux - it appears a few
> 
> fcntl(fd, F_SETFD, FD_CLOEXEC)
> 
> calls are missing before fork/exec.  See here for the details:
> 
> https://bugzilla.redhat.com/show_bug.cgi?id=364331


I can't test this myself since I don't run selinux, could you
send a patch for this?

