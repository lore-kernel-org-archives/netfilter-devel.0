From: Giuseppe Longo <giuseppelng@gmail.com>
Subject: Re: [PATCH 1/5] src: get it sync with current include/linux/netfilter/nf_tables.h
Date: Fri, 28 Jun 2013 10:03:56 +0200
Message-ID: <CAFpD06SB7b3f45y=5P4S+GahBG1uiP6Gi8oV2zZRVpRP=g_=GA@mail.gmail.com>
References: <1371825739-3669-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net,
	Eric Leblond <eric@regit.org>,
	Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ve0-f170.google.com ([209.85.128.170]:62140 "EHLO
	mail-ve0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372Ab3F1ID5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 28 Jun 2013 04:03:57 -0400
Received: by mail-ve0-f170.google.com with SMTP id 14so1570291vea.29
        for <netfilter-devel@vger.kernel.org>; Fri, 28 Jun 2013 01:03:56 -0700 (PDT)
In-Reply-To: <1371825739-3669-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,
i've tried to apply this patch, but it failed:

Hunk #1 succeeded at 1 with fuzz 2.
Hunk #2 FAILED at 48.
Hunk #3 succeeded at 78 with fuzz 1.
Hunk #4 FAILED at 94.
Hunk #5 FAILED at 108.
Hunk #6 FAILED at 128.
Hunk #7 succeeded at 321 with fuzz 2.
Hunk #9 FAILED at 488.
Hunk #10 FAILED at 606.
6 out of 10 hunks FAILED -- saving rejects to file
include/linux/netfilter/nf_tables.h.rej
patching file src/ct.c
Hunk #1 FAILED at 111.
1 out of 1 hunk FAILED -- saving rejects to file src/ct.c.rej
patching file src/parser.y
Hunk #1 FAILED at 295.
Hunk #2 FAILED at 1309.
2 out of 2 hunks FAILED -- saving rejects to file src/parser.y.rej
patching file src/scanner.l
Hunk #1 FAILED at 382.
1 out of 1 hunk FAILED -- saving rejects to file src/scanner.l.rej

I have to apply other patches before this?

Thanks,
Regards.
