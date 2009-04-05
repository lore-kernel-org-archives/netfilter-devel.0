From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [patch] iptables-1.4.3.1: unabled to restore ! -s 192.168.1.0/24
 match
Date: Sun, 05 Apr 2009 12:23:19 +0200
Message-ID: <49D88697.6010609@netfilter.org>
References: <49C8DB3B.909@netfilter.org> <1238838634.31963.578.camel@localhost> <alpine.LSU.2.00.0904041334001.13174@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Peter Volkov <pva@gentoo.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:49966 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751385AbZDEKXc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 5 Apr 2009 06:23:32 -0400
In-Reply-To: <alpine.LSU.2.00.0904041334001.13174@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> On Saturday 2009-04-04 11:50, Peter Volkov wrote:
> 
>> Hi. We've received bug report about broken ! -s 192.168.1.0/24 match:
>> http://bugs.gentoo.org/264089
> 
> I combined your two patches, added the missing ip6 parts and used
> the default iptables spacing idioms.
> 
> Pablo: This is available through the 'plus' branch at 
> git://dev.medozas.de/iptables.

There's something in this pull that was not discussed at all:

commit a094eb0f2a57592b6f3cf42fdbb9d49fead2d57c
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Fri Apr 3 22:37:49 2009 +0200

    build: add configure option to disable ipv4 iptables

    This patch complements the previous one.

    Signed-off-by: Jan Engelhardt <jengelh@medozas.de>

I read the bugzilla log entry about the person who was requesting this.
This is fine but please, send more detailed reports on the changeset
that are in your tree.

Applied. Thanks Peter and Jan for the fixes.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
