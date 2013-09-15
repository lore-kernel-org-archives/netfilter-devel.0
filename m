From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH 1/1] netfilter: Ignore bogus SACK option values in TCP
 conntrack
Date: Sun, 15 Sep 2013 09:22:52 -0700
Message-ID: <20130915162252.GA7020@linuxace.com>
References: <1378148280-1153-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1378148280-1153-2-git-send-email-kadlec@blackhole.kfki.hu>
 <20130902215736.GA11580@linuxace.com>
 <alpine.DEB.2.00.1309030858120.2504@blackhole.kfki.hu>
 <20130904165403.GA13703@linuxace.com>
 <alpine.DEB.2.00.1309042059510.8849@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Pablo Neira Ayuso <pablo@netfilter.org>,
	Corey Hickey <bugfood-ml@fatooh.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:35821 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752367Ab3IOQWp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 15 Sep 2013 12:22:45 -0400
Received: by mail-pb0-f46.google.com with SMTP id rq2so3148020pbb.33
        for <netfilter-devel@vger.kernel.org>; Sun, 15 Sep 2013 09:22:45 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1309042059510.8849@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 13, 2013 at 10:16:14PM +0200, Jozsef Kadlecsik wrote:
> I have been thinking on this from time to time and couldn't come up with a 
> solution which is satisfying: even if an nf_conntrack_tcp_sack_be_liberal
> flag is added to the patch, if it's default off, then that's almost the 
> same situations as we have at the present.

With the additional sysctl, at least the 0.1% of admins which are bit by
these braindead anonymizer boxes would have the option of working around
them without completely disabling TCP window tracking.  

Phil
