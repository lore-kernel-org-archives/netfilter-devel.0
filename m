From: Patrick McHardy <kaber@trash.net>
Subject: Re: Data rate of a connection using conntrack
Date: Wed, 28 Oct 2009 17:25:14 +0100
Message-ID: <4AE8706A.30205@trash.net>
References: <4d5b51f60910060816i35c9ffd8y9bf2695f9d28bca3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Anand Raj Manickam <anandrm@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:60963 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394AbZJ1QZQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 28 Oct 2009 12:25:16 -0400
In-Reply-To: <4d5b51f60910060816i35c9ffd8y9bf2695f9d28bca3@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Anand Raj Manickam wrote:
> I understand from RATEEST that data rate of an interface is estimated
> using the gen_new_estimator , which is also used by the TC , qdisc n
> folks ...
> Has anybody tried to estimate the data rate of a connection using conntrack ?
> Anyone's previous attempts or experiences  are welcome.

There has been a patch a (long) while ago which was somehow
based on conntrack. You should be able to find it in the
old patch-o-matic (not -ng) repository.
