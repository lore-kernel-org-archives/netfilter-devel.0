From: Kaarle Ritvanen <kaarle.ritvanen@datakunkku.fi>
Subject: Re: [PATCH ulogd2] adjust ulogd.logrotate to match ulogd.conf
Date: Mon, 6 Mar 2017 19:06:51 +0200 (EET)
Message-ID: <alpine.LFD.2.20.1703061844310.6990@kanala.kunkku.net>
References: <a8e669c7-6f9a-405f-bac3-c7d0c33064eb@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from welho-filter1.welho.com ([83.102.41.23]:56118 "EHLO
        welho-filter1.welho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754312AbdCFRG5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Mar 2017 12:06:57 -0500
In-Reply-To: <a8e669c7-6f9a-405f-bac3-c7d0c33064eb@email.android.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 12 Feb 2017, Eric Leblond wrote:

> This is not correct. All the listed files are default value for various 
> existing output modules so we should keep them.

Sorry, I was looking at the default configuration file. Currently, the 
default configuration file is inconsistent with the module defaults. I 
think it would be good to harmonize all these, so I posted a couple of 
patches:

Harmonize default log files:
http://marc.info/?l=netfilter-devel&m=148697928328626&w=2

Add missing default log files to logrotate configuration:
http://marc.info/?l=netfilter-devel&m=148697928528629&w=2

I wish somebody would comment these.

BR,
Kaarle
