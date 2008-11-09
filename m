From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 2/2] New netfilter target to trigger LED devices
Date: Sun, 9 Nov 2008 20:10:39 +0300
Message-ID: <20081109171039.GA3287@x200.localdomain>
References: <4916E4F0.8010507@shikadi.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Richard Purdie <rpurdie@openedhand.com>
To: Adam Nielsen <a.nielsen@shikadi.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.186]:43773 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755415AbYKIRHQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Nov 2008 12:07:16 -0500
Received: by nf-out-0910.google.com with SMTP id d3so943735nfc.21
        for <netfilter-devel@vger.kernel.org>; Sun, 09 Nov 2008 09:07:14 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <4916E4F0.8010507@shikadi.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Nov 09, 2008 at 11:26:08PM +1000, Adam Nielsen wrote:
> +	/*noconst*/struct xt_led_info_internal *ledinternal = ledinfo->internal_data;
	  ^^^^^^^
What is this?
