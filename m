From: Eric Leblond <eric@regit.org>
Subject: Re: [PATCH ulogd2 1/2] ulogd.conf: harmonize log file options with
 module default values
Date: Tue, 16 May 2017 00:05:21 +0200
Message-ID: <1494885921.15338.6.camel@regit.org>
References: <20170213094729.23478-1-kaarle.ritvanen@datakunkku.fi>
         <1488895202.4890.4.camel@regit.org>
         <alpine.LFD.2.20.1703272133320.10745@kanala.kunkku.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Kaarle Ritvanen <kaarle.ritvanen@datakunkku.fi>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:53594 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751201AbdEOWF3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 May 2017 18:05:29 -0400
In-Reply-To: <alpine.LFD.2.20.1703272133320.10745@kanala.kunkku.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

On Wed, 2017-04-12 at 14:40 +0300, Kaarle Ritvanen wrote:
> On Tue, 7 Mar 2017, Eric Leblond wrote:
> 
> > I really like the idea of getting an harmonized naming for the log
> > files but I think we should do it reverse for values that are not
> > commented in the configuration file. Most distributions and install
> > are
> > shipping with a copy of default configuration. 
> > 
> > Most users won't have changed the values that are uncommented. So
> > they
> > will have on disk the log file with name defined in the
> > configuration
> > file. And they will benefit from a new logrotate file. Thus we
> > should
> > use the file name defined in the conf as value of the default file
> > name
> > in code.
> > 
> > Could you resubmit a patchset ?
> 
> I preprared a new patch set according to your feedback:
> 
> http://marc.info/?l=netfilter-devel&m=149064027208491&w=2
> http://marc.info/?l=netfilter-devel&m=149064028308496&w=2
> 
> Please take a look at them.

No excuse on me to have missed that. Really sorry. I've just pushed
that to git.

Best regards,
-- 
Eric Leblond <eric@regit.org>
