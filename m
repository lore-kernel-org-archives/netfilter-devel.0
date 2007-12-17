From: Phil Oester <kernel@linuxace.com>
Subject: Re: [RFC][PATCH] Per-conntrack timeout target v3
Date: Mon, 17 Dec 2007 13:20:10 -0800
Message-ID: <20071217212010.GA23837@linuxace.com>
References: <20071127190745.GA2080@linuxace.com> <474D2F88.5050707@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from adsl-67-120-171-161.dsl.lsan03.pacbell.net ([67.120.171.161]:34519
	"HELO linuxace.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754392AbXLQVUL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Dec 2007 16:20:11 -0500
Content-Disposition: inline
In-Reply-To: <474D2F88.5050707@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Nov 28, 2007 at 10:06:16AM +0100, Patrick McHardy wrote:
> I think the patch is useful, but I wonder how long it will take until
> people want to override timeouts for other connection states. I'm
> also looking for a way to pass parameters for new connections to
> helpers (most of the things that are currently module parameters),
> so maybe we could generalize this to a conntrack parameter target?

In thinking about this, it seems like a HELPER target would be
useful, for instance if some random FTP server ran on a non-standard
port and we wanted the FTP helper to be used.  Something like:

    -s X -p 210 -j HELPER --helper ftp

Or did you have something else in mind, such as being able to 
change the _global_ ports in use by the FTP helper?  (or both?)

I suppose we could allow adjustment of other timeouts by
having multiple arguments to -j TIMEOUT, such as --syn_sent,
--syn_recv, etc. though the check() becomes more complicated
between the various protos.

Phil
