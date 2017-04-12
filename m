From: Kaarle Ritvanen <kaarle.ritvanen@datakunkku.fi>
Subject: Re: [PATCH ulogd2 1/2] ulogd.conf: harmonize log file options with
 module default values
Date: Wed, 12 Apr 2017 14:40:31 +0300 (EEST)
Message-ID: <alpine.LFD.2.20.1703272133320.10745@kanala.kunkku.net>
References: <20170213094729.23478-1-kaarle.ritvanen@datakunkku.fi> <1488895202.4890.4.camel@regit.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from welho-filter3.welho.com ([83.102.41.25]:44623 "EHLO
        welho-filter3.welho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752179AbdDLLkh (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Apr 2017 07:40:37 -0400
In-Reply-To: <1488895202.4890.4.camel@regit.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 7 Mar 2017, Eric Leblond wrote:

> I really like the idea of getting an harmonized naming for the log
> files but I think we should do it reverse for values that are not
> commented in the configuration file. Most distributions and install are
> shipping with a copy of default configuration. 
> 
> Most users won't have changed the values that are uncommented. So they
> will have on disk the log file with name defined in the configuration
> file. And they will benefit from a new logrotate file. Thus we should
> use the file name defined in the conf as value of the default file name
> in code.
> 
> Could you resubmit a patchset ?

I preprared a new patch set according to your feedback:

http://marc.info/?l=netfilter-devel&m=149064027208491&w=2
http://marc.info/?l=netfilter-devel&m=149064028308496&w=2

Please take a look at them.

BR,
Kaarle
