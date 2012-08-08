From: Arif Hossain <aftnix@gmail.com>
Subject: Re: CRYPT target patch for newer kernel ?
Date: Wed, 08 Aug 2012 21:41:58 +0600
Message-ID: <1344440518.4763.42.camel@localhost>
References: <1344428741.4763.21.camel@localhost>
	 <alpine.LNX.2.01.1208081535440.857@frira.zrqbmnf.qr>
	 <1344433984.4763.28.camel@localhost>
	 <alpine.LNX.2.01.1208081613060.1203@frira.zrqbmnf.qr>
	 <1344435326.4763.36.camel@localhost>
	 <alpine.LNX.2.01.1208081733550.2908@frira.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
	nefilter@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50599 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932773Ab2HHPwt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Aug 2012 11:52:49 -0400
In-Reply-To: <alpine.LNX.2.01.1208081733550.2908@frira.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 2012-08-08 at 17:34 +0200, Jan Engelhardt wrote:
<snip>
> If it is not linux, it's pretty much irrelevant for this discussion 
> group.

How so :)

the client is not linux does not mean the the server (for which i'm
developing) is not linux :)


client(simple encryption)------------------>(server equipped with
ENCRYPT extension which will do decryption for client to server path and
encryption for server to client path) ----> encryption agnostic local
process

I'm developing for server, which runs on linux, so i don't see how its
irrelevant here:)
-- 
Cheers

aft
aftnix@gmail.com

