From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH libnftables] Add support for ct set
Date: Fri, 10 Jan 2014 13:27:04 +0000
Message-ID: <20140110132703.GA8224@macbook.localnet>
References: <1389359425-6837-1-git-send-email-kristian.evensen@gmail.com>
 <20140110131406.GA8088@macbook.localnet>
 <CAKfDRXgDZSnQ-cvpDTbea45ZTeFOMu_PThEp1kL-qNeQzVKrQw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Kristian Evensen <kristian.evensen@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59187 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752361AbaAJN1H (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jan 2014 08:27:07 -0500
Content-Disposition: inline
In-Reply-To: <CAKfDRXgDZSnQ-cvpDTbea45ZTeFOMu_PThEp1kL-qNeQzVKrQw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 10, 2014 at 02:19:42PM +0100, Kristian Evensen wrote:
> Hi,
> 
> On Fri, Jan 10, 2014 at 2:14 PM, Patrick McHardy <kaber@trash.net> wrote:
> > nftables uses statements for things that don't return a value. I think
> > it would make sense to keep this consistent. An "set" expression (aka
> > statement) can never be used in a match, so its something fundamentally
> > different than an expression.
> 
> Are you discussing the removal of the union?

No, I'm refering to the (ab)use of the expression. Anything not returning
data is not an expression but a statement.
