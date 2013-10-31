From: Dirk <biecie547@gmail.com>
Subject: Re: [RFC PATCH nf_conntrack_extend] new extensions without changes
 kernel source
Date: Thu, 31 Oct 2013 10:22:00 +0100
Message-ID: <CALqGmB05qyeF0gr5z9aOC4NW9EVJoStvPAGB6PVptDErC77B3A@mail.gmail.com>
References: <525EEAB7.4090901@guap.ru>
	<20131029122212.GA8019@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oa0-f47.google.com ([209.85.219.47]:51176 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750882Ab3JaJWB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Oct 2013 05:22:01 -0400
Received: by mail-oa0-f47.google.com with SMTP id i1so2797999oag.34
        for <netfilter-devel@vger.kernel.org>; Thu, 31 Oct 2013 02:22:00 -0700 (PDT)
In-Reply-To: <20131029122212.GA8019@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> I'm reticent to get this extremely generic infrastructure into
> mainstream, we need to know more on the ndpi needs and discuss some
> generic infrastructure that most layer 7 implementation can benefit
> from.

I was always under the impression a more generic conntrack extend
mechanism that could also be used by kernel modules would never be
allowed into mainstream?

My use case is a QoS module that does per flow packet queueing. A more
generic mechanism that doesn't require a kernel patch/recompile would
be very welcome :-)


Kind regards,
Dirk
