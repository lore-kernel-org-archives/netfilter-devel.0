From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: NETFILTER_XT_TARGET_NOTRACK
Date: Thu, 10 Apr 2014 15:01:20 +0200
Message-ID: <20140410130120.GA4015@localhost>
References: <1397131511.25950.97.camel@chaos.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, Patrick McHardy <kaber@trash.net>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Michal Kubecek <mkubecek@suse.cz>
To: Jean Delvare <jdelvare@suse.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59362 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030566AbaDJNB1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Apr 2014 09:01:27 -0400
Content-Disposition: inline
In-Reply-To: <1397131511.25950.97.camel@chaos.site>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 10, 2014 at 02:05:11PM +0200, Jean Delvare wrote:
> Hi all,
> 
> I have a concern / question / suggestion regarding
> NETFILTER_XT_TARGET_NOTRACK.
> 
> Currently, NETFILTER_XT_TARGET_NOTRACK merely selects
> NETFILTER_XT_TARGET_CT, and does nothing else. This means that selecting
> or not selecting NETFILTER_XT_TARGET_NOTRACK makes no difference, as
> long as NETFILTER_XT_TARGET_CT itself is set.
> 
> I seem to understand that NETFILTER_XT_TARGET_NOTRACK was reintroduced
> in kernel 3.8 to help migration to NETFILTER_XT_TARGET_CT. I understand
> the logic, but this was 7 kernel versions / over 2 years ago. Wouldn't
> it be the right time to finally remove NETFILTER_XT_TARGET_NOTRACK?
>
> Alternatively, I find it curious that the compatibility code is
> unconditionally built into xt_CT even when NETFILTER_XT_TARGET_NOTRACK
> is not selected. Is it an overlook, or is it by design? I think it would
> make sense to only build that compatibility code when
> NETFILTER_XT_TARGET_NOTRACK is selected. In that case it would make
> sense to keep NETFILTER_XT_TARGET_NOTRACK.

Recent iptables versions use the alias infrastructure so NOTRACK is
mapped to CT internally. We can probably wait a bit more before we get
rid of that old compat code. Frankly, the NOTRACK part is quite little
code actually and very simple, so we don't get much from removing it
but problems (as we may break compatibility for old iptables userspace
binary versions with no aliasing infrastructure).
