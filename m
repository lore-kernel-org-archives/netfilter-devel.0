From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nftables] Add support for setting ct keys
Date: Thu, 30 Jan 2014 11:29:01 +0100
Message-ID: <20140130102901.GA4137@localhost>
References: <1389107758-24360-1-git-send-email-kristian.evensen@gmail.com>
 <CAKfDRXjiW_hiW2CF24QepMPwx+E1oPqNp30i0NkA7TF3iN2kmg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Kristian Evensen <kristian.evensen@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52422 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027AbaA3K3M (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Jan 2014 05:29:12 -0500
Content-Disposition: inline
In-Reply-To: <CAKfDRXjiW_hiW2CF24QepMPwx+E1oPqNp30i0NkA7TF3iN2kmg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Thu, Jan 30, 2014 at 08:42:56AM +0100, Kristian Evensen wrote:
> Hi,
> 
> Now that support for setting ct keys have been added to the kernel and
> library, I wondered if there is an update on this patch?

libnftnl is there. The nft patch doesn't apply though.

Could you rebase on top of nftables next-3.14 branch, please?

Thanks.
