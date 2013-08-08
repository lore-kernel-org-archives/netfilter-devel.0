From: "Laurence J. Lane" <ljlane@debian.org>
Subject: Re: state match incompatibilty across versions
Date: Thu, 8 Aug 2013 09:53:54 -0400
Message-ID: <CA+0KVf3yZGme50zraKy=EJj5V83Vr+SQumjaCSbdWx60y2JGtw@mail.gmail.com>
References: <CA+0KVf2e_Ce33SFJyK21LzLBhUhWzWdgaMje4ShZF7i7evGuMw@mail.gmail.com>
 <CA+0KVf0RDy0ub_R0t9Fn5-dBN2dRhZqu2+eRy36Xur7nF8EHoA@mail.gmail.com> <20130808043230.GA22843@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
To: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from dunimos.ljlane.net ([216.218.223.72]:46209 "EHLO
	dunimos.ljlane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965474Ab3HHNyQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 8 Aug 2013 09:54:16 -0400
Received: from mail-ve0-f173.google.com (mail-ve0-f173.google.com [209.85.128.173])
	(using TLSv1 with cipher ECDHE-RSA-RC4-SHA (128/128 bits))
	(No client certificate requested)
	(Authenticated sender: google-debian@dunimos.ljlane.net)
	by dunimos.ljlane.net (Postfix) with ESMTPSA id 82DCF293E6
	for <netfilter-devel@vger.kernel.org>; Thu,  8 Aug 2013 09:54:15 -0400 (EDT)
Received: by mail-ve0-f173.google.com with SMTP id cy12so3058023veb.4
        for <netfilter-devel@vger.kernel.org>; Thu, 08 Aug 2013 06:54:14 -0700 (PDT)
In-Reply-To: <20130808043230.GA22843@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Aug 8, 2013 at 12:32 AM, Phil Oester <kernel@linuxace.com> wrote:

> Issue understood.  I posted a patch in the past few hours.  Can you verify
> this fixes the issue for you?

It does. Thank you!
