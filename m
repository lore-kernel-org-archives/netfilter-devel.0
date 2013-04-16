From: Harald Welte <laforge@netfilter.org>
Subject: Re: [PATCH 24/28] proc: Supply an accessor to get the name in a
 proc_dir_entry struct [RFC]
Date: Wed, 17 Apr 2013 00:20:37 +0200
Message-ID: <20130416222037.GR5785@prithivi.gnumonks.org>
References: <20130416182550.27773.89310.stgit@warthog.procyon.org.uk>
 <20130416182725.27773.42175.stgit@warthog.procyon.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	netfilter-devel@vger.kernel.org, viro@zeniv.linux.org.uk,
	Jan Engelhardt <jengelh@medozas.de>
To: David Howells <dhowells@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ganesha.gnumonks.org ([213.95.27.120]:39417 "EHLO
	ganesha.gnumonks.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965426Ab3DPWhJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 16 Apr 2013 18:37:09 -0400
Content-Disposition: inline
In-Reply-To: <20130416182725.27773.42175.stgit@warthog.procyon.org.uk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi David,

On Tue, Apr 16, 2013 at 07:27:25PM +0100, David Howells wrote:
> This is only needed by the xt_hashlimit netfilter module as that appears to
> use the name in the pde to save a label in the xt_hashlimit_htable struct -
> which will be a problem if CONFIG_PROC_FS=n.

I don't know the larger context of this patch (and am not follwing
filesystem related work in general), but at least from the xt_hashlimit
point of view this of course looks fine.  We can always wrap direct
accesses to structure members behind an API call.

For consistency reasons 'proc_get_name()' might be a better name than
get_proc_name(), but that's probably a matter of taste.

Pleaes note that I'm only the original author but not the active
maintainer of the xt_hashlimit (formerly ipt_hashlimit) code.

Regards,
	Harald
-- 
- Harald Welte <laforge@netfilter.org>                 http://netfilter.org/
============================================================================
  "Fragmentation is like classful addressing -- an interesting early
   architectural error that shows how much experimentation was going
   on while IP was being designed."                    -- Paul Vixie
