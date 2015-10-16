From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [RFC conntrackd PATCH] conntrackd: add basic systemd notification support
Date: Fri, 16 Oct 2015 21:23:30 +0200
Message-ID: <CAOkSjBh7hyB_QAidiXsoBtCOj9xG8y0cUcu-ERZTCZQsnHXRJA@mail.gmail.com>
References: <20151016120800.15632.42888.stgit@r2d2.cica.es> <alpine.LSU.2.20.1510161607550.18200@nerf40.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wi0-f173.google.com ([209.85.212.173]:36251 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510AbbJPTXv convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Oct 2015 15:23:51 -0400
Received: by wicgb1 with SMTP id gb1so21720708wic.1
        for <netfilter-devel@vger.kernel.org>; Fri, 16 Oct 2015 12:23:50 -0700 (PDT)
In-Reply-To: <alpine.LSU.2.20.1510161607550.18200@nerf40.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 16 October 2015 at 16:10, Jan Engelhardt <jengelh@inai.de> wrote:
>
> On Friday 2015-10-16 14:10, Arturo Borrero Gonzalez wrote:
>
>>+AC_ARG_ENABLE([systemd],
>>+      AS_HELP_STRING([--disable-systemd], [Do not build systemd supp=
ort]),
>>+      [enable_systemd=3D"no"], [enable_systemd=3D"yes"])
>
> This is incorrect. It needs to be
>
>         [enable_systemd=3D"$enableval"], [enable_systemd=3D"yes"])
>

I don't understand why. Could you please elaborate? The code above
(cthelper, cttimeout) is also bad?

I'm following this:
https://www.gnu.org/savannah-checkouts/gnu/autoconf/manual/autoconf-2.6=
9/html_node/Package-Options.html

>
>>+++ b/src/systemd.c
>>@@ -0,0 +1,25 @@
>>+/*
>>+ * (C) 2015 by Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.co=
m>
>>+ *
>>+ * This program is free software; you can redistribute it and/or mod=
ify
>>+ * it under the terms of the GNU General Public License as published=
 by
>>+ * the Free Software Foundation; either version 2 of the License, or
>>+ * (at your option) any later version.
>>+ *
>>+ * This program is distributed in the hope that it will be useful,
>>+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
>>+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
>>+ * GNU General Public License for more details.
>>+ *
>>+ * You should have received a copy of the GNU General Public License
>>+ * along with this program; if not, write to the Free Software
>>+ * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
>>+ */
>>+
>>+#include "systemd.h"
>>+#include <systemd/sd-daemon.h>
>>+
>>+void sd_ct_init(void)
>>+{
>>+      sd_notify(0, "READY=3D1");
>>+}
>
> It seems a bit excessive to create a new file just for this.
> (In particular since it means you had to use AM_CONDITIONAL
> to select the source file.)

Well, the idea (as stated in the patch description) is to add more
systemd-related features.
I'm thinking of:
 * tell systemd the state of the daemon in several circumstances
(start, stop, and so on)
 * tell systemd when the Unix socket is activated/deactivated
 * in the future, perhaps give support for systemd watchdog
 * other things... (PID, errno, etc...)

I guess a separate source file is OK for all the systemd-related stuff.

Sending READY=3D1 is just a basic starting feature. I don't want to
implement more things until it's clear we want systemd integration in
conntrackd.
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
