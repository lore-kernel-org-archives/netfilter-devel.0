From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH next] utils: bpf_compile
Date: Tue, 2 Apr 2013 00:20:53 +0200
Message-ID: <20130401222053.GB26928@localhost>
References: <51262486.40905@redhat.com>
 <1363103052-5529-1-git-send-email-willemb@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, dborkman@redhat.com,
	zenczykowski@gmail.com
To: Willem de Bruijn <willemb@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32848 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755281Ab3DAWU5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Apr 2013 18:20:57 -0400
Content-Disposition: inline
In-Reply-To: <1363103052-5529-1-git-send-email-willemb@google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Mar 12, 2013 at 11:44:12AM -0400, Willem de Bruijn wrote:
> V2
> - update build process to
>   - succeed without bpf_compiler when --enable-bpf-compiler is not set
>   - succeed with bpf_compiler when this flag is set and libpcap is found
>   - fail when this flag is set but libpcap is absent
> - release memory allocated by pcap on exit

Applied with changes:

* renamed utility to add the `nf' prefix.

* the output of the utility is now exactly what iptables -m bpf --bytecode
  needs, just to make it easier to everyone.

Still missing a hard fail if --enable-bpf-compiler is set and libpcap
is not available in the system, I'd appreciate if you send me a follow
up patch to address this. You may want to have a look at how ulogd2
does this in its configure fail as reference.

Thanks.
