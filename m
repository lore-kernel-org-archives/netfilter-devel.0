From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: iptables version defines
Date: Fri, 30 May 2008 12:06:45 +0200
Message-ID: <200805301206.45428.thomas.jarosch@intra2net.com>
References: <200805301016.03130.thomas.jarosch@intra2net.com> <Pine.LNX.4.64.0805301140430.14733@bizon.gios.gov.pl> <Pine.LNX.4.64.0805301155550.16963@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from rs02.intra2net.com ([81.169.173.116]:55334 "EHLO
	rs02.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751386AbYE3KGw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 May 2008 06:06:52 -0400
In-Reply-To: <Pine.LNX.4.64.0805301155550.16963@bizon.gios.gov.pl>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Krzysztof,

On Friday, 30. May 2008 11:56:28 you wrote:
> > #ifdef _XTABLES_H
> > init(struct xt_entry_target *t)
> > #else
> > init(struct ipt_entry_target *t, unsigned int *nfcache)
> > #endif
>
> Plese check the attached patch.

Thanks for the patch! I've developed something similar yesterday, though not 
as elegant as your version. This will solve the issue for iptables < 1.4.0.

The differences between 1.4.0 and the upcoming 1.4.1 are still an issue as 
some function names changed. The version defines could be of help here.

Thomas
