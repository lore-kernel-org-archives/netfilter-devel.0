From: "=?utf-8?B?SsO2cmcgVGhhbGhlaW0=?=" <joerg@higgsboson.tk>
Subject: Re: [PATCH] add systemd service file
Date: Wed, 17 Dec 2014 21:02:31 +0000
Message-ID: <a3cf487d816d486f49d324c921edb1a3@mail.higgsboson.tk>
References: <alpine.LSU.2.11.1412172155030.32713@nerf08.vanv.qr>
 <20141217205407.06558f65@turingmachine>
 <20141217214032.569fbfac@turingmachine>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8BIT
Cc: netfilter-devel@vger.kernel.org
To: "Jan Engelhardt" <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.higgsboson.tk ([148.251.132.243]:35002 "EHLO
	mail.higgsboson.tk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078AbaLQVCe convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Dec 2014 16:02:34 -0500
In-Reply-To: <alpine.LSU.2.11.1412172155030.32713@nerf08.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> But it means there will be a time where only half of the ruleset is
> loaded.

Good point, so i will replace it with a pipe into nft.
