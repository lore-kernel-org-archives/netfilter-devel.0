From: Phil Oester <kernel@linuxace.com>
Subject: Re: rfc: reject use of drop in nat table
Date: Mon, 4 Aug 2008 11:05:51 -0700
Message-ID: <20080804180551.GA20903@linuxace.com>
References: <alpine.LNX.1.10.0808041252270.27953@fbirervta.pbzchgretzou.qr> <489734F1.8040808@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from adsl-67-120-171-161.dsl.lsan03.pacbell.net ([67.120.171.161]:44667
	"HELO linuxace.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751505AbYHDSFw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Aug 2008 14:05:52 -0400
Content-Disposition: inline
In-Reply-To: <489734F1.8040808@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 04, 2008 at 06:57:21PM +0200, Patrick McHardy wrote:
> Well, first thought is the usual fear of breaking setups.

If they are doing this, their setup is _already_ broken.  This
will fix it ;-)

> But I do agree that this makes sense, we've had a number
> of "bugreports" over the years from people how tried to
> do filtering in the nat table and didn't realize it only
> sees the first packet of a connection.
>
> Not sure - anyone else with an opinion? :)

+1

Phil
