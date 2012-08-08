From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: CRYPT target patch for newer kernel ?
Date: Wed, 8 Aug 2012 18:06:06 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1208081758420.2908@frira.zrqbmnf.qr>
References: <1344428741.4763.21.camel@localhost>  <alpine.LNX.2.01.1208081535440.857@frira.zrqbmnf.qr>  <1344433984.4763.28.camel@localhost>  <alpine.LNX.2.01.1208081613060.1203@frira.zrqbmnf.qr>  <1344435326.4763.36.camel@localhost>
 <alpine.LNX.2.01.1208081733550.2908@frira.zrqbmnf.qr> <1344440518.4763.42.camel@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>,
	nefilter@vger.kernel.org
To: Arif Hossain <aftnix@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from seven.medozas.de ([5.9.24.206]:52066 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758763Ab2HHQGI (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Aug 2012 12:06:08 -0400
In-Reply-To: <1344440518.4763.42.camel@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wednesday 2012-08-08 17:41, Arif Hossain wrote:
>
>client(simple encryption)------------------>(server equipped with
>ENCRYPT extension which will do decryption for client to server path and
>encryption for server to client path) ----> encryption agnostic local
>process

If your client cannot handle a workload like TLS, it is likely also too 
weak for any other, reasonable, implementation.
