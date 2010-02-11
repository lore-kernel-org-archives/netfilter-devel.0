From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: netfilter 02/08: nf_conntrack: show helper and class in
 /proc/net/nf_conntrack_expect
Date: Thu, 11 Feb 2010 13:59:03 +0100 (CET)
Message-ID: <alpine.LSU.2.01.1002111358520.30927@obet.zrqbmnf.qr>
References: <20100211073932.7894.23544.sendpatchset@x2.localnet> <20100211073935.7894.11114.sendpatchset@x2.localnet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:45951 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753293Ab0BKM7I (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Feb 2010 07:59:08 -0500
In-Reply-To: <20100211073935.7894.11114.sendpatchset@x2.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 2010-02-11 08:39, Patrick McHardy wrote:

>commit 4e4aa88c264e9f8d013e3742e48a6bea37ca1c4c
>Author: Patrick McHardy <kaber@trash.net>
>Date:   Thu Feb 11 07:40:30 2010 +0100
>
>    netfilter: nf_conntrack: show helper and class in /proc/net/nf_conntrack_expect

Were not there any plans on obsoleting these procfs files?
