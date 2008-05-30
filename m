From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: [ANNOUNCE] Release of iptables 1.4.1-rc2
Date: Fri, 30 May 2008 09:33:53 +0200
Message-ID: <200805300933.53869.thomas.jarosch@intra2net.com>
References: <483AB493.6010503@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rs02.intra2net.com ([81.169.173.116]:45382 "EHLO
	rs02.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853AbYE3HyJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 May 2008 03:54:09 -0400
In-Reply-To: <483AB493.6010503@trash.net>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Patrick,

On Monday, 26. May 2008 15:01:07 you wrote:
> The netfilter coreteam proudly presents:
>
>      iptables version 1.4.1-rc2

I just compiled the new version and noticed a minor
error message during the build of the manpages:

  GEN      matches4.man
grep: invalid option -- o
Usage: grep [OPTION]... PATTERN [FILE]...
Try `grep --help' for more information.

Looks like my grep version is too old. Should ./configure detect that
or is it even possible to transform the grep call into something else?

Cheers,
Thomas
