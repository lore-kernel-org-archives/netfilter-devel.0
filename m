From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Re: [PATCH libnftables] Add support for ct set
Date: Tue, 7 Jan 2014 18:28:21 +0100
Message-ID: <CAKfDRXhjO8vAh=vpxWek_5+-0ifgGXVeXcj+wrzax+bxOdmi1g@mail.gmail.com>
References: <1389107738-24320-1-git-send-email-kristian.evensen@gmail.com>
	<CAOkSjBi=hT2wVcNTXJ3G4r0hXJBv=-68MJNHX+n2+KiM0cOG-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f50.google.com ([209.85.220.50]:42109 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbaAGR2W (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jan 2014 12:28:22 -0500
Received: by mail-pa0-f50.google.com with SMTP id kp14so665106pab.9
        for <netfilter-devel@vger.kernel.org>; Tue, 07 Jan 2014 09:28:21 -0800 (PST)
In-Reply-To: <CAOkSjBi=hT2wVcNTXJ3G4r0hXJBv=-68MJNHX+n2+KiM0cOG-A@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Arturo,

Thank you very much for your comments.

On Tue, Jan 7, 2014 at 6:13 PM, Arturo Borrero Gonzalez
<arturo.borrero.glez@gmail.com> wrote:
> Looking at this, I think we should fail if neither dreg nor sreg are
> present. I guess we need at least one of two and if not, the
> expression is invalid. Also in JSON parsing.

Both meta and my patch fails if this is the case when XML is parsed.
If the dreg-parse call fails, then sreg is checked. If the sreg-parse
call also fails, then -1 is returned. The JSON parsing has this issue
though, so I will fix it in the next version of the patch.

-Kristian
