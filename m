From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Writing a mangle TARGET for iptables, questions about fragments,
 checksums
Date: Thu, 14 Apr 2011 09:00:56 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1104140900330.28694@obet.zrqbmnf.qr>
References: <4D97FBD8.9050907@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Brian G <unixman83@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:45117 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753842Ab1DNHA6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Apr 2011 03:00:58 -0400
In-Reply-To: <4D97FBD8.9050907@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sunday 2011-04-03 06:47, Brian G wrote:

> Hi,
>
> I want to modify a packet in the TCP mangle PREROUTING table.
>
> First question: Fragments, does the kernel reassemble them BEFORE this point?

Potentially. It may, but it does not have to.

> Second question: Checksums, do I need to update the checksum?

Yes.
