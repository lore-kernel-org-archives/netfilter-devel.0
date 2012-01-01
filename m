From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Ulogd - mysql addresses are in network-byte order
Date: Sun, 1 Jan 2012 16:55:11 +0100
Message-ID: <20120101155511.GA21378@1984>
References: <4EFF3A14.10705@gmail.com>
 <20111231172745.GA17716@1984>
 <4EFF545A.3030006@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: marty <martinbarrowcliff@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50790 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752945Ab2AAPzQ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Jan 2012 10:55:16 -0500
Content-Disposition: inline
In-Reply-To: <4EFF545A.3030006@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Dec 31, 2011 at 01:28:42PM -0500, marty wrote:
> On 12/31/2011 12:27 PM, Pablo Neira Ayuso wrote:
> >On Sat, Dec 31, 2011 at 11:36:36AM -0500, marty wrote:
> >>This is NOT a bug,  but I believe it needs consideration for change.
> >>So lets call it a feature request to stay friendly.
> >>
> >>ulogd.c:733 assigning `ip.saddr(?)' as source for MYSQL(ip.saddr)
> >>ulogd.c:733 assigning `ip.daddr(?)' as source for MYSQL(ip.daddr)
> >>
> >>On a little-endian architecture these values are incompatable with
> >>the native math functions and totally unsuitable for making
> >>comparisons in mysql.
> >>
> >>eg:
> >>if (( ip.saddr>  nnnnnnnnn ) AND ( ip.saddr<  mmmmmmmm)) ...
> >>This simply will not work on a little endian machine.
> >>
> >>It is impractical to do a byte order conversion using a bunch
> >>of the high level routines within mysql, and it may not be
> >>timely to do it later using a scripting language.
> >>
> >>IMHO I believe it is appropriate for these values to be in
> >>host-byte order before they are ever assigned to mysql.
> >>This would then match the byte order of any machine.
> >>If there are compelling reasons to use network byte order,
> >>I suggest this be a configurable option, not the default.
> >>
> >>Thanks for a great piece of software,
> >
> >Thanks for the report.
> >
> >Would you be brave enough to send me a patch to address this?
> >
> 
> Sure, but would you be brave enough to accept my patch?
> Seriously, before I start, please get consensus on the issue of
> configuration options for network byte order addresses.
> That means I might need to work on more lib code, to be complete.
> I wouldn't want to break anything people needed and if that
> option is not necessary I can have a tested patch in a couple days.
> Let me know what is best.

Never mind. Post the patches. We'll review them.
