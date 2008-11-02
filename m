From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: Issues building iptables-1.4.2 w/ linux 2.6.25 (and IMQ)
Date: Sun, 2 Nov 2008 22:12:23 +0100 (CET)
Message-ID: <alpine.LNX.1.10.0811022204140.25491@fbirervta.pbzchgretzou.qr>
References: <490E111C.9060006@redfish-solutions.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Philip Prindeville <philipp_subx@redfish-solutions.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:44707 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753851AbYKBVMZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 2 Nov 2008 16:12:25 -0500
In-Reply-To: <490E111C.9060006@redfish-solutions.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Sunday 2008-11-02 21:44, Philip Prindeville wrote:

> Subject: Issues building iptables-1.4.2 w/ linux 2.6.25 (and IMQ)
>
> I'm trying to build iptables 1.3.8

Version mismatch.

> Is this a known issue?  Is there a patch for this?

Yes. (Can't remember.)

> I tried bumping to 1.4.2, but that dies with a different issue:
>
> libipt_IMQ.c: In function 'help':
> libipt_IMQ.c:18: error: 'IPTABLES_VERSION' undeclared (first use in this
> function)

IMQ is not packaged in an original iptables tarball, hence this falls 
under the IMQ maintainer's care. What you see here is what happens when 
you try to use an old patch with a new version.
