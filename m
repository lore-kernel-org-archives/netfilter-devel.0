From: "=?utf-8?B?SsO2cmcgVGhhbGhlaW0=?=" <joerg@higgsboson.tk>
Subject: Re: [PATCH] add systemd service file
Date: Thu, 18 Dec 2014 07:50:09 +0000
Message-ID: <47dded8fbb17bf3335b91d4e464b71e9@mail.higgsboson.tk>
References: <0aacef05524146946330ec41e2235318@mail.higgsboson.tk>
 <CAOkSjBi_X40RrdHDpNNsdbSp-=3okki21s=wkK3J+BsD97Jpqg@mail.gmail.com>
 <20141217205407.06558f65@turingmachine>
 <CAOkSjBg_O4GRuFkm7hNoZDv_JqCjOVRcP7VNV=K1NYqHdSuJmA@mail.gmail.com>  
 <b3a6e72b6713574b986ab81624dddeda@mail.higgsboson.tk>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Cc: "Netfilter Development Mailing list"
	<netfilter-devel@vger.kernel.org>
To: "Arturo Borrero Gonzalez" <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.higgsboson.tk ([148.251.132.243]:53372 "EHLO
	mail.higgsboson.tk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751509AbaLRHuN convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Dec 2014 02:50:13 -0500
In-Reply-To: <0aacef05524146946330ec41e2235318@mail.higgsboson.tk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> Is the "include" statement a new feature? Never saw this feature in the wild.
> Does it works for directories too? Something like `include "/etc/nftables.d/*"` 
> or `includedir "/etc/nftables/"` would be awesome.

I should have read the manpage before asking. Anyway glob(3) would be cool addition.
