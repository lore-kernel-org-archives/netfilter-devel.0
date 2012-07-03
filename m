From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: What happened to xt_match_param
Date: Tue, 3 Jul 2012 17:57:47 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1207031558180.19068@frira.zrqbmnf.qr>
References: <mx3hez3o.fsf@s1.test.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: AFT <aftnix@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:46455 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755336Ab2GCP5v (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Jul 2012 11:57:51 -0400
In-Reply-To: <mx3hez3o.fsf@s1.test.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 2012-07-03 15:46, AFT wrote:

>In "writing netfilter module", by JAN, there is a inconsistancy in
>section 2.5 named "Point of decision".
>
>After subsequent reading i understood, it should be struct
>xt_action_param in the match function's prototype. so the correct
>prototype should be,
>
>static bool ipaddr_mt(const struct sk_buff *skb,
>                      struct xt_action_param *par);
>
>So it should be updated so that noobs like me does not get confused.

Corrected now.

