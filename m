From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] xtables-standalone: call nft_fini in the error path
Date: Wed, 4 Dec 2013 12:18:54 +0100
Message-ID: <20131204111854.GA12266@localhost>
References: <1385981005-2843-1-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39977 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932073Ab3LDLS6 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Dec 2013 06:18:58 -0500
Content-Disposition: inline
In-Reply-To: <1385981005-2843-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Dec 02, 2013 at 11:43:25AM +0100, Ana Rey wrote:
> This error is shown with valgrind tools:
> 
> valgrind --leak-check=full xtables -A INPUT -i eth0 -p tcp --dport 80 -m state --state NEW,ESTABLISHED -j ACCEPT
> 
> ==7377== 16 bytes in 1 blocks are still reachable in loss record 1 of 14
> ==7377==    at 0x4C2B514: calloc (vg_replace_malloc.c:593)
> ==7377==    by 0x574CC76: mnl_socket_open (socket.c:117)
> ==7377==    by 0x417495: nft_init (nft.c:598)
> ==7377==    by 0x4134C2: xtables_main (xtables-standalone.c:64)
> ==7377==    by 0x5B87994: (below main) (libc-start.c:260)
> 
> This patch calls nft_fini to release the objects that have been allocated in
> nft_init. This function was not used so far.

Applied, thanks Ana.
