From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [patch] ipset 2.3.0 segfault on '-U :all: {:all:|:default:}
Date: Fri, 30 May 2008 09:18:40 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0805300917070.10875@blackhole.kfki.hu>
References: <483F111A.40700@shorewall.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Tom Eastep <teastep@shorewall.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:46717 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754347AbYE3HSl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 30 May 2008 03:18:41 -0400
In-Reply-To: <483F111A.40700@shorewall.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 29 May 2008, Tom Eastep wrote:

> Segfault occurs at line 1641 as a result of dereferencing a null pointer while
> testing the set type for iptreemap.
> 
> Patch attached.

Thank you the report and the patch: I'll apply it as soon as the svn->git 
migration of ipset source is ready.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
