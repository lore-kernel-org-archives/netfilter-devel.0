From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] tests: regression: nft-test.py: Delete an unnecessary
 whitespace in an output messages.
Date: Thu, 9 Oct 2014 18:56:13 +0200
Message-ID: <20141009165613.GB14090@salvia>
References: <1412772730-29161-1-git-send-email-anarey@gmail.com>
 <1412772730-29161-2-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44754 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757327AbaJIQyv (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Oct 2014 12:54:51 -0400
Content-Disposition: inline
In-Reply-To: <1412772730-29161-2-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Oct 08, 2014 at 02:52:10PM +0200, Ana Rey wrote:
> If the script is run with -e options,output messages show an unnecessary
> white-space. This path fixes this mistake.
> 
> sudo ./nft-test.py -e
> [...] "line 34: nft add rule -nnn arp test-arp  input arp plen != {33-55} " [...]

Applied, thanks.

