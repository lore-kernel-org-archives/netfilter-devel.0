From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: ip6tables-save LOG target output is different to iptables-save
Date: Mon, 15 Jul 2013 12:51:23 +0200
Message-ID: <20130715105123.GA16159@localhost>
References: <CAC+BxFrOpO8UWdd4xa146AsZN52A2hSOmaTiyvOmQK-qktzVPg@mail.gmail.com>
 <20130706044121.GA15084@linuxace.com>
 <CAC+BxFovBteFJQ=K7LHPX47CxAAbGpBuzCvdTdsU00AvxJ-pag@mail.gmail.com>
 <20130706155601.GA31065@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Scott Baillie <scott.a.baillie@gmail.com>,
	"netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59973 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754877Ab3GOKv2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 15 Jul 2013 06:51:28 -0400
Content-Disposition: inline
In-Reply-To: <20130706155601.GA31065@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jul 06, 2013 at 08:56:01AM -0700, Phil Oester wrote:
> On Sat, Jul 06, 2013 at 03:07:15PM +1000, Scott Baillie wrote:
> > It just makes it a little bit harder to parse the output , because
> > both tools should produce the same output
> > wherever possible in my opinion.
> 
> Agreed.  Patch follows which makes the two tools consistent, however
> they will now both not quote the prefix if only one word is present.
> 
> libipt_LOG is using the xtables_save_string func, which escapes unsafe
> characters as needed.  libip6t_LOG should do the same.

Applied, thanks Phil.
