From: Tim Fenn <fenn@stanford.edu>
Subject: iptables leaks a file descriptor before fork/exec
Date: Fri, 2 Nov 2007 11:14:12 -0700
Message-ID: <20071102111412.6e9f67c4@atbws1.stanford.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-roam.Stanford.EDU ([171.64.10.152]:51205 "EHLO
	smtp-roam.Stanford.EDU" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754068AbXKBSat (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Nov 2007 14:30:49 -0400
Received: from atbws1.stanford.edu (atbws1.Stanford.EDU [171.65.71.32])
	(authenticated bits=0)
	by smtp-roam.Stanford.EDU (8.12.11/8.12.11) with ESMTP id lA2IEC8l023911
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <netfilter-devel@vger.kernel.org>; Fri, 2 Nov 2007 11:14:13 -0700
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

As per a discussion I had on the fedora-selinux list
(https://www.redhat.com/archives/fedora-selinux-list/2007-October/msg00033.html),
Dan Walsh suggested filing a bug report in regards to a FD leak noticed
when tracking iptables with selinux - it appears a few

fcntl(fd, F_SETFD, FD_CLOEXEC)

calls are missing before fork/exec.  See here for the details:

https://bugzilla.redhat.com/show_bug.cgi?id=364331

-Tim
