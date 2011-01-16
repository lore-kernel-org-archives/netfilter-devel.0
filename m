From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] netfilter: create audit records for x_tables replaces
Date: Sun, 16 Jan 2011 18:14:35 +0100
Message-ID: <4D33277B.5060105@trash.net>
References: <20110114224525.GC22508@canuck.infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org, linux-audit@redhat.com,
	Eric Paris <eparis@parisplace.org>,
	Al Viro <viro@ZenIV.linux.org.uk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48049 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751081Ab1APROh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Jan 2011 12:14:37 -0500
In-Reply-To: <20110114224525.GC22508@canuck.infradead.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 14.01.2011 23:45, schrieb Thomas Graf:
> The setsockopt() syscall to replace tables is already recorded
> in the audit logs. This patch stores additional information
> such as table name and netfilter protocol.
> 

Applied, thanks Thomas.
