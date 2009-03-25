From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: Re: [patch 3/6] netfilter: limit the length of the helper name
Date: Wed, 25 Mar 2009 18:41:21 +0100
Message-ID: <20090325174121.GB25526@mail.eitzenberger.org>
References: <20090316220659.756862181@jonathan.eitzenberger.org> <20090316221138.326410717@jonathan.eitzenberger.org> <49CA6AAA.1050305@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: David Miller <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netdev-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <49CA6AAA.1050305@trash.net>
Sender: netdev-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, Mar 25, 2009 at 06:32:26PM +0100, Patrick McHardy wrote:

> This appears to be an off-by-one. A strlen of exactly
> NF_CT_HELPER_NAME_LEN - 1 would be fine, right?
> 
> No need to resend, just let me know whether I should change it.

Yes please, feel free to change it :).

 /holger


