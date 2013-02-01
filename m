From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ 82/89] netfilter: xt_hashlimit: fix race that results in
 duplicated entries
Date: Fri, 1 Feb 2013 18:47:29 +0100
Message-ID: <20130201174729.GA5254@localhost>
References: <20130201130207.444989281@linuxfoundation.org>
 <20130201130213.388508268@linuxfoundation.org>
 <CA+6hz4qjj3wGgo-m50=qRxAN+OGUXKfUfgRp7Pys7NixgwQ3vQ@mail.gmail.com>
 <20130201163455.GB4908@localhost>
 <CA+6hz4rbzeDtYx9-sMDdgt2QxpcpGLrEBwezaEush1gb_W-o4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Feng Gao <gfree.wind@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slan-550-85.anhosting.com ([174.127.110.175]:48449 "EHLO
	slan-550-85.anhosting.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757085Ab3BARrd (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 1 Feb 2013 12:47:33 -0500
Content-Disposition: inline
In-Reply-To: <CA+6hz4rbzeDtYx9-sMDdgt2QxpcpGLrEBwezaEush1gb_W-o4w@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Feb 02, 2013 at 12:56:17AM +0800, Feng Gao wrote:
[...]
> So I wonder How could I commit the patch to kernel directly or how to
> let owner could adopt my fix directly next time?

There is no "file owners" in the Linux kernel, we have subsystem
maintainers that take care of entire source code sub-trees.

You have to send your patches to the corresponding mailing list for
that subsystem. In the specific case of Netfilter, you have to send
your patches to the netfilter-devel mailing list. Make sure your patch
comes with a description and a valid Signed-off-by. If the patch is
not complete, you risk that it passes overlook since patchwork [1]
does not register it.

If your patch is a fix, you can send it anytime. If it is an
enhancement, you have to check if the merge window is open.

The maintainer will get back to you with some ACK/NACK feedback after
some time, if you don't get any, you are free to retry. You can CC
maintainers to attract their attention. You can check the MAINTAINERS
under the linux tree to find the appropriate person.

Regards.

[1] http://patchwork.ozlabs.org/project/netfilter-devel/list/
