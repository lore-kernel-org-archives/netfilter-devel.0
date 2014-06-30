From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 0/5] Do not print unset values in xml and json
Date: Mon, 30 Jun 2014 12:49:26 +0200
Message-ID: <20140630104926.GC6360@localhost>
References: <1403802521-12571-1-git-send-email-anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:58496 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752581AbaF3Ktb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Jun 2014 06:49:31 -0400
Content-Disposition: inline
In-Reply-To: <1403802521-12571-1-git-send-email-anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jun 26, 2014 at 07:08:36PM +0200, Ana Rey wrote:
> This patchset does tasks about does not print unset value in xml and json file
> and about refactoring code:
> 
> * src: table: Free memory in the same function that is reserved
> * src: table: Use nft_table_attr_set_* in the xml functions
> * src: table: Add set, unset and parse implementation for use value
> 
>  Moreover, I add some implementations for use value.
> 
> Ana Rey (5):
>   src: table: Free memory in the same function that is reserved
>   src: table: Use nft_table_attr_set_* in the xml functions
>   src: table: Add set, unset and parse implementation for use value
>   src: table: Do not print unset values in xml file
>   src: table: Do not print unset values in json file

Series applied, thanks Ana.
