From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC][PATCH] Per-conntrack timeout target v3
Date: Fri, 04 Jan 2008 15:21:18 +0100
Message-ID: <477E40DE.8020506@trash.net>
References: <20071127190745.GA2080@linuxace.com> <474D2F88.5050707@trash.net> <20071217212010.GA23837@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:48023 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367AbYADOYW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jan 2008 09:24:22 -0500
In-Reply-To: <20071217212010.GA23837@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Phil Oester wrote:
> On Wed, Nov 28, 2007 at 10:06:16AM +0100, Patrick McHardy wrote:
>> I think the patch is useful, but I wonder how long it will take until
>> people want to override timeouts for other connection states. I'm
>> also looking for a way to pass parameters for new connections to
>> helpers (most of the things that are currently module parameters),
>> so maybe we could generalize this to a conntrack parameter target?
> 
> In thinking about this, it seems like a HELPER target would be
> useful, for instance if some random FTP server ran on a non-standard
> port and we wanted the FTP helper to be used.  Something like:
> 
>     -s X -p 210 -j HELPER --helper ftp
> 
> Or did you have something else in mind, such as being able to 
> change the _global_ ports in use by the FTP helper?  (or both?)
> 
> I suppose we could allow adjustment of other timeouts by
> having multiple arguments to -j TIMEOUT, such as --syn_sent,
> --syn_recv, etc. though the check() becomes more complicated
> between the various protos.

Long delay due to Christmas, sorry ..

Yes, manually attaching helpers would also be useful, but I
was mainly thinking of helper-specific parameters, like in
the case of FTP, "loose", for SIP the timeouts, etc.

Ideally such a target should support both.
