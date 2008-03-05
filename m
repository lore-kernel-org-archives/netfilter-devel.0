From: Filippo Zangheri <filippo.zangheri@yahoo.it>
Subject: Re: xtables-1.5.2 not working
Date: Wed, 05 Mar 2008 22:19:38 +0100
Message-ID: <47CF0E6A.8000703@yahoo.it>
References: <47CE69D9.7090308@yahoo.it> <Pine.LNX.4.64.0803051521080.7660@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
To: netfilter-devel <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from n9.bullet.re3.yahoo.com ([68.142.237.94]:33660 "HELO
	n9.bullet.re3.yahoo.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751522AbYCEVdm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Mar 2008 16:33:42 -0500
In-Reply-To: <Pine.LNX.4.64.0803051521080.7660@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt ha scritto:
> Thanks for the report!
> I fixed this in 3474f7db.. (master); find_match was incorrectly called
> when we tried to load libxt_standard (a target actually).

Ack. Thank you!


-- 
Filippo Zangheri

GPG key ID: 0xE1D879FA
Key fingerprint: 816B CE57 D43C 0A47 EF35 3378 EA5F A72A E1D8 79FA
Key server: pgp.mit.edu

-----BEGIN GEEK CODE BLOCK-----
Version: 3.12
GE d- s+:- a-- C++ UL+++ P+ L+++ E-- W+ N* o-- K- w--- O-- M--
V- PS++ PE+ Y+ PGP++ t 5-- X++ R* tv b+ DI-- D---- G-- e++ h--
r++ z*
------END GEEK CODE BLOCK------

