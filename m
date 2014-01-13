From: Phil Oester <kernel@linuxace.com>
Subject: Re: Fwd: Bug 883 - Uninitialized values in libnetfilter_log.c
Date: Mon, 13 Jan 2014 08:02:09 -0800
Message-ID: <20140113160208.GA17922@home>
References: <CA+J3vcL=6i2DfpGcGpPw6WSrw7tdWn=5Y8e8q6KObDe8t_kAOA@mail.gmail.com>
 <CA+J3vcL9Shwc1cFDPPMPmcn81niNfELxqf-XtEAqTO8Bij--mQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ivan Homoliak <xhomol11@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f46.google.com ([209.85.220.46]:49654 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558AbaAMQCL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Jan 2014 11:02:11 -0500
Received: by mail-pa0-f46.google.com with SMTP id rd3so2049615pab.33
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Jan 2014 08:02:10 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <CA+J3vcL9Shwc1cFDPPMPmcn81niNfELxqf-XtEAqTO8Bij--mQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jan 12, 2014 at 10:14:38AM +0100, Ivan Homoliak wrote:
> I think I found few bugs in libnetfilter_log by valgrind and ulogd.
> See the patch in attachment.

Hi Ivan,

thanks for the patch, but please send the diff in unified format,
and include your signed-off-by.  See Documentation/SubmittingPatches
for further information.  

Phil
