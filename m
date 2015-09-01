From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [conntrackd] allowing DisableExternalCache in alarm mode
Date: Tue, 1 Sep 2015 18:44:21 +0200
Message-ID: <20150901164421.GA3320@salvia>
References: <CAOkSjBh2KtYcSEQ7=h_h+R9CE53pwGtBAiQ_OZF0aTX0fhY0fw@mail.gmail.com>
 <20150828164912.GD3436@salvia>
 <CAOkSjBhxLk2beq70jZCTKtO8K09UcSj5jNh2H-9wvCzSL0XxeA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54603 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753126AbbIAQhw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Sep 2015 12:37:52 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBhxLk2beq70jZCTKtO8K09UcSj5jNh2H-9wvCzSL0XxeA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Aug 31, 2015 at 09:55:23AM +0200, Arturo Borrero Gonzalez wrote:
> On 28 August 2015 at 18:49, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > Are these FTP data flows? I'm asking this because the master
> > connection (control flow) may be missing in the conntrack table, thus
> > the ENOENT error.
> 
> Makes sense.
> 
> Would you consider accepting the patch?

I think you can fix the problem that you're noticing by extending
timer_add().

Note that the general idea behind the alarm approach is to insert a
timer with a random time wait in unit from 0..M seconds.

A quick workaround to address this is that master conntracks are
placed in the time range from 0..N/2, then you place non-master
conntrack entries in the range from N/2+1 to M. Then, unless there is
packet loss, most likely the expected conntrack will find the master
one.

It should be just a few more extra lines away from this oneliner.
