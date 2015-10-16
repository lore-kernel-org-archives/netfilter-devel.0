From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: [RFC conntrackd PATCH] conntrackd: add basic systemd notification
 support
Date: Fri, 16 Oct 2015 16:10:42 +0200 (CEST)
Message-ID: <alpine.LSU.2.20.1510161607550.18200@nerf40.vanv.qr>
References: <20151016120800.15632.42888.stgit@r2d2.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares41.inai.de ([46.4.122.207]:34080 "EHLO ares41.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932568AbbJPOKo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Oct 2015 10:10:44 -0400
In-Reply-To: <20151016120800.15632.42888.stgit@r2d2.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2015-10-16 14:10, Arturo Borrero Gonzalez wrote:

>+AC_ARG_ENABLE([systemd],
>+	AS_HELP_STRING([--disable-systemd], [Do not build systemd support]),
>+	[enable_systemd="no"], [enable_systemd="yes"])

This is incorrect. It needs to be

	[enable_systemd="$enableval"], [enable_systemd="yes"])


>+++ b/src/systemd.c
>@@ -0,0 +1,25 @@
>+/*
>+ * (C) 2015 by Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
>+ *
>+ * This program is free software; you can redistribute it and/or modify
>+ * it under the terms of the GNU General Public License as published by
>+ * the Free Software Foundation; either version 2 of the License, or
>+ * (at your option) any later version.
>+ *
>+ * This program is distributed in the hope that it will be useful,
>+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
>+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>+ * GNU General Public License for more details.
>+ *
>+ * You should have received a copy of the GNU General Public License
>+ * along with this program; if not, write to the Free Software
>+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>+ */
>+
>+#include "systemd.h"
>+#include <systemd/sd-daemon.h>
>+
>+void sd_ct_init(void)
>+{
>+	sd_notify(0, "READY=1");
>+}

It seems a bit excessive to create a new file just for this.
(In particular since it means you had to use AM_CONDITIONAL
to select the source file.)
