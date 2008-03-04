From: Massimiliano Hofer <max@nucleus.it>
Subject: Re: [PATCH 17/24] Remove support for compilation of conditional extensions
Date: Tue, 4 Mar 2008 23:29:26 +0100
Message-ID: <200803042329.27395.max@nucleus.it>
References: <Pine.LNX.4.64.0803040519150.7660@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0803041706280.7660@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from host94-205-static.22-80-b.business.telecomitalia.it ([80.22.205.94]:38566
	"EHLO waobagger.intranet.nucleus.it" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759239AbYCDWiz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Mar 2008 17:38:55 -0500
In-Reply-To: <Pine.LNX.4.64.0803041706280.7660@fbirervta.pbzchgretzou.qr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tuesday 4 March 2008, Jan Engelhardt wrote:

> This has previously come up on the mailing list; I henceforth decided to
> nuke it.
>
> Jozsef, Massimiliano: Feel free to either (a) get xt_condition and
> xt_ipset into the kernel, then can readd to xtables or (b) get
> xt_condition and xt_ipset into xtables-addons.

OK. I know I've fallen behind with my work lately. I can produce a set of 
patches against the current net-2.6 git by next week (give or take a few 
days).

As discussed with Patrick, I'll need some API adjustments. If you can accept 
them and xt_condition, I'll be happy to comply and support it afterwards.

-- 
Bye,
   Massimiliano Hofer
        Nucleus
