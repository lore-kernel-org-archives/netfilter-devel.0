From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH next] extensions: add libxt_bpf extension
Date: Tue, 2 Apr 2013 00:16:33 +0200
Message-ID: <20130401221633.GA26928@localhost>
References: <1357776727-28547-1-git-send-email-willemb@google.com>
 <1358992858-20172-1-git-send-email-willemb@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Willem de Bruijn <willemb@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60728 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758294Ab3DAWQq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Apr 2013 18:16:46 -0400
Content-Disposition: inline
In-Reply-To: <1358992858-20172-1-git-send-email-willemb@google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 23, 2013 at 09:00:58PM -0500, Willem de Bruijn wrote:
> Changes:
> - v3
>   - more informative error messages and man page
> - v2
>   - update to match latest kernel module (fixed size match struct)
>   - add manual page
>   - fix save/restore
>   - fix matching whole program on delete
> 
> Support filtering using Linux Socket Filters

Applied with changes:

* include a copy of include/linux/netfilter/xt_bpf.h in the tree.

* Removed the --bytecode-file option. The original
  proposal was to accept BPF code in a file in human readable format.
  Now, with the nfbpf_compile utility, it's very easy to generate the
  filter using tcpdump-like syntax. We can recover the file parameter
  later on if you find it useful.

* Removed the trailing comma in the backtick format, the parser works
  just fine for me here.

* Fix error message if --bytecode is missing.

Thanks.
