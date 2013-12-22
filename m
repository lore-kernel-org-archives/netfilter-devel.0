From: Florian Westphal <fw@strlen.de>
Subject: Re: iptc_handle : where is header and structure info for iptc_handle
 ?
Date: Mon, 23 Dec 2013 00:38:11 +0100
Message-ID: <20131222233811.GD29632@breakpoint.cc>
References: <52B68042.5030807@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "hanasaki@gmail.com" <hanasaki@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([80.244.247.6]:43927 "EHLO
	Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756807Ab3LVXiM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 22 Dec 2013 18:38:12 -0500
Content-Disposition: inline
In-Reply-To: <52B68042.5030807@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

hanasaki@gmail.com <hanasaki@gmail.com> wrote:
> Running a build of 3.12 with iptables and looking for the header
> file with the full structure of the "iptc_handle" without success.
> Any tips?

There is no such header.  The structure is private to libiptc,
'struct xtc_handle' in libiptc directory in iptables source code.
