From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: linux 3.12 regression - snat problem with ftp helper
Date: Sun, 17 Nov 2013 01:23:11 +0100
Message-ID: <20131117002311.GA3610@localhost>
References: <52862618.4030202@netart.pl>
 <20131115200928.GA11322@home>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Dawid Stawiarski - nazwa.pl" <dawid.stawiarski@netart.pl>,
	netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43892 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751951Ab3KQAXW (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 Nov 2013 19:23:22 -0500
Content-Disposition: inline
In-Reply-To: <20131115200928.GA11322@home>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 15, 2013 at 12:09:29PM -0800, Phil Oester wrote:
> On Fri, Nov 15, 2013 at 02:48:08PM +0100, Dawid Stawiarski - nazwa.pl wrote:
> > hello,
> > 
> > after upgrade to mainline kernel v. 3.12 our machines are not able
> > to connect to ftp service (from inside of the lxc containters).
> > Mainline kernel 3.11.8 works fine.
> > 
> > in packet 8 host sends rewriten PORT command (with changed private
> > to public IP) - however the packet has incorrect sequence number
> > (should have 41).
> > the ftp server responds with SACK but the host resets the connection.
> 
> Does the attached patch solve the problem for you?

This fix works here in my testbed. Will revisit this tomorrow again.

Thanks Phil.
