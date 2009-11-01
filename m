From: Pierre Chifflier <pchifflier@edenwall.com>
Subject: Re: [PATCH 1/2] Add new input plugin UNIXSOCK
Date: Sun, 1 Nov 2009 14:07:39 +0100
Message-ID: <20091101130739.GC11601@piche.inl.fr>
References: <1257072828-11028-1-git-send-email-chifflier@inl.fr>
 <1257072828-11028-2-git-send-email-chifflier@inl.fr>
 <alpine.LSU.2.00.0911011336330.22807@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, eleblond@inl.fr
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:46820 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752112AbZKANHq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 1 Nov 2009 08:07:46 -0500
Content-Disposition: inline
In-Reply-To: <alpine.LSU.2.00.0911011336330.22807@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Nov 01, 2009 at 01:45:45PM +0100, Jan Engelhardt wrote:
> >+#define UNIX_PATH_MAX	108
> 
> This is nowhere used and can be removed. (Also since 108 may be
> wrong for a given arch.)

Yep, removed

> 
> >+#define unixpath_ce(x)		(x->ces[0])
> >+#define bufsize_ce(x)		(x->ces[1])
> >+#define perms_ce(x)		(x->ces[2])
> >+#define owner_ce(x)		(x->ces[3])
> >+#define group_ce(x)		(x->ces[4])
> 
> x should be guarded with ((x)->ces[0])

True (in general case). A quick grep shows that all plugins are using
the same defines and should be updated (45 matches) .. it would need a
required patch.

> >+
> >+	ip = (struct iphdr *) data;
> 
> If data is not aligned, later dereferencing can fail :(

I remember some arches (sparc, arm ?) will send a signal (SIGBUS I
think) in this case.
How can I prevent data from being unaligned ?
Adding some __attribute__((aligned(4)) will be enough ?

> >+
> >+		while ( (data - packet_buf) < total_len) {
> >+
> >+			option_number = ntohs(*(u_int16_t*)(data));
> 
> This can fail even if packet_buf _is_ aligned, all it takes
> is that payload_len is an odd number.
> Unfortunately, I see no way to easily address this without
> lame bitshifting :(

Yes, since this is a Key-Length-Value protocol it's hard to ensure there
is no weird value. I tried to add checks (marker on start, etc.), but I
see no easy way to address this;

> 
> >+static int _unix_socket_set_permissions(struct ulogd_pluginstance *upi)
> >+{
> >+	const char *socket_path;
> >+	char *owner = owner_ce(upi->config_kset).u.string;
> >+	char *group = group_ce(upi->config_kset).u.string;
> 
> const char *, I guess
> 
> >+	int uid = -1;
> >+	int gid = -1;
> 
> uit_t, gid_t.
> 
> >+	if (uid >= 0 || gid >= 0) {
> 
> Subsequently, uid != -1 || gid != -1. However, you could also ignore
> this check entirely since chown checks for -1 already.

The check was here only to avoid a call if both are -1, but I agree it's
useless.

Thanks,
Pierre

