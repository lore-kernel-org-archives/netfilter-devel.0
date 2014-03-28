From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v2] nftables: Fix list of sets by family
Date: Fri, 28 Mar 2014 12:31:35 +0000
Message-ID: <20140328123134.GA7895@macbook.localnet>
References: <008e38aa5e97439e7ac8a9e178689c2d666fa554.1396006133.git.anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55254 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751311AbaC1Mbj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Mar 2014 08:31:39 -0400
Content-Disposition: inline
In-Reply-To: <008e38aa5e97439e7ac8a9e178689c2d666fa554.1396006133.git.anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 28, 2014 at 12:40:31PM +0100, Ana Rey wrote:
> Fix the result of command line 'nft list sets FAMILY'. It shows the
> following error message:
> 
> "Error: syntax error, unexpected end of file, expecting string"
> 
> Now, it is possible shows right this information:
> 
> $ sudo nft -nna list sets ip
> 	set set_test {
> 		type ipv4_address
> 		elements = { 192.168.3.45, 192.168.3.43, 192.168.3.42, 192.168.3.4}
> 	}
> 	set set_test2 {
> 		type ipv4_address
> 		elements = { 192.168.3.43, 192.168.3.42, 192.168.3.4}
> 	}
> 	set set0 {
> 		type ipv4_address
> 		flags constant
> 		elements = { 127.0.0.12, 12.11.11.11}
> 	}
> 
> Signed-off-by: Ana Rey <anarey@gmail.com>

Applied, thanks Ana.
