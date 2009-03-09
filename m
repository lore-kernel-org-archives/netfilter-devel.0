From: Patrick McHardy <kaber@trash.net>
Subject: Re: NFQUEUE stucked packets
Date: Mon, 09 Mar 2009 17:30:26 +0100
Message-ID: <49B54422.9030201@trash.net>
References: <18390532.20090309174658@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Kuzin Andrey <kuzinandrey@yandex.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48514 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999AbZCIQaa (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 9 Mar 2009 12:30:30 -0400
In-Reply-To: <18390532.20090309174658@yandex.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Kuzin Andrey wrote:
> How to resolve this problem ?
> This is hardware bug, SMP bug, users corrupted packets bug, NFQUEUE
> bug or anything else ? How i can view this stucked packets in queue to
> try understand what is going wrong ?
> (userspace don't have any errors, because this code work normally
> from 2004 ip_queue ages, and we have this after rewrite application
> for NFQUEUE)

The first thing I'd do is make sure that userspace actually delivers
the verdicts its supposed to.

Just keep track of the last packet ID somewhere in the kernel, the
verdict always has to be for the next higher number. If not, the bug
is in userspace.
