From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf-next/nf_tables8] Unable to compile kernel
Date: Mon, 18 Feb 2013 17:59:52 +0100
Message-ID: <20130218165952.GA19904@localhost>
References: <CAOkSjBh78knOWQLmFnz+XyW4umVVnVVkWs9VeYPJdzhxg3T_fg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slan-550-85.anhosting.com ([174.127.110.175]:57006 "EHLO
	slan-550-85.anhosting.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755158Ab3BRQ75 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Feb 2013 11:59:57 -0500
Content-Disposition: inline
In-Reply-To: <CAOkSjBh78knOWQLmFnz+XyW4umVVnVVkWs9VeYPJdzhxg3T_fg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 18, 2013 at 05:39:49PM +0100, Arturo Borrero Gonzalez wrote:
> Hi there,
> 
> I'm unable to compile the nf-next (branch nf_tables8) kernel:
> 
> [...]
>   CC      init/version.o
>   LD      init/built-in.o
> net/built-in.o: In function `nft_exthdr_eval':
> /home/aborrero/git/nf-next/net/netfilter/nft_exthdr.c:37: undefined
> reference to `ipv6_find_hdr'
> net/built-in.o: In function `nft_set_pktinfo_ipv6':
> /home/aborrero/git/nf-next/include/net/netfilter/nf_tables_ipv6.h:18:
> undefined reference to `ipv6_find_hdr'
> /home/aborrero/git/nf-next/include/net/netfilter/nf_tables_ipv6.h:18:
> undefined reference to `ipv6_find_hdr'
> /home/aborrero/git/nf-next/include/net/netfilter/nf_tables_ipv6.h:18:
> undefined reference to `ipv6_find_hdr'
> make[2]: *** [vmlinux] Error 1
> [...]
> 
> This is the code: http://1984.lsi.us.es/git/nf-next/tree/?h=nf_tables8
> 
> Could anyone give me some hints of what should I do to fix it?

Did you enable IP6_NF_IPTABLES in .config? That function is defined
there. That dependency will be removed since that function now belongs
to the ipv6 core since recently.

BTW, please use this tree:

http://1984.lsi.us.es/git/nftables/

I will remove the nf_tables8 branch on nf-next asap.

Regards.
