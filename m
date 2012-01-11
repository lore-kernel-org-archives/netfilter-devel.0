From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xt_target checkentry()/destroy() semantics
Date: Wed, 11 Jan 2012 07:45:03 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1201110741110.27346@frira.zrqbmnf.qr>
References: <4F0CE6C0.6080900@nod.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Richard Weinberger <richard@nod.at>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([188.40.89.202]:54014 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752055Ab2AKGpK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 11 Jan 2012 01:45:10 -0500
In-Reply-To: <4F0CE6C0.6080900@nod.at>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2012-01-11 02:32, Richard Weinberger wrote:

>Hi!
>
>I always thought that checkentry()/destroy() are being called upon rule insertion/deletion.
>So I assumed that this command sequence prints three times "test_tg_check" and then three times
>"test_tg_destroy". But it's not the case.

One table-replace operation implies add-delete of all rules.

>[90345.773073] test_tg_check
>[90345.775691] test_tg_check
>[90345.778330] test_tg_destroy
>[90347.782798] test_tg_check
>[90347.785417] test_tg_check
>[90347.788044] test_tg_check
>[90347.790663] test_tg_destroy
>[90347.793454] test_tg_destroy
>[90372.581020] test_tg_check
>[90372.583639] test_tg_check
>[90372.586275] test_tg_destroy
>
>Is there a way to detect the insertion/removal of a rule using my TEST target?

test_tg_destroy.
