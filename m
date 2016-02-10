From: Ken-ichirou MATSUZAWA <chamaken@gmail.com>
Subject: Re: [RFC] a software based on ulogd
Date: Wed, 10 Feb 2016 10:53:58 +0900
Message-ID: <20160210015358.GA17470@gmail.com>
References: <20160206104249.GA19349@gmail.com>
 <a53f427c-6b04-4d3b-898e-ba63fc949f5a@email.android.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Devel <netfilter-devel@vger.kernel.org>
To: Eric Leblond <eric@regit.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pa0-f44.google.com ([209.85.220.44]:33573 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755956AbcBJByE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Feb 2016 20:54:04 -0500
Received: by mail-pa0-f44.google.com with SMTP id cy9so3451511pac.0
        for <netfilter-devel@vger.kernel.org>; Tue, 09 Feb 2016 17:54:03 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <a53f427c-6b04-4d3b-898e-ba63fc949f5a@email.android.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Feb 07, 2016 at 11:51:47AM +0100, Eric Leblond wrote:
> Do you think you could resubmit a patchset adding netflow support to ulogd ?

I can send patches, but I have not used this and I don't know if I
will use it or not.

I think NFCT plugin also needs to update to propagate delta counter
in practical use. Following patch series can be used with NFCT
destory event as I wrote in comment, and tested it a little bit with
nfdump.

Thanks,
