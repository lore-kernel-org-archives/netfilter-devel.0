From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: conntrack segfault
Date: Thu, 02 Jul 2009 18:30:38 +0200
Message-ID: <4A4CE0AE.9030901@netfilter.org>
References: <h1q05h$o8h$1@ger.gmane.org> <h1q3tu$2vi$1@ger.gmane.org> <4A40F777.7010505@netfilter.org> <4A4108D6.901@birkenwald.de> <4A4159BE.7040807@birkenwald.de> <20090624105915.GA8675@schleppi.birkenwald.de> <alpine.LNX.1.10.0906241315240.2240@bizon.gios.gov.pl> <alpine.LSU.2.00.0906241353160.16864@fbirervta.pbzchgretzou.qr> <4A42226A.4040502@birkenwald.de> <4A426932.1030607@netfilter.org> <20090624221845.GA16585@pest>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Krzysztof Oledzki <ole@ans.pl>, netfilter-devel@vger.kernel.org
To: Bernhard Schmidt <berni@birkenwald.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39877 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751027AbZGBQaq (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jul 2009 12:30:46 -0400
In-Reply-To: <20090624221845.GA16585@pest>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Sorry for the late reply.

Bernhard Schmidt wrote:
> vex amd64->IR: unhandled instruction bytes: 0x6 0xDF 0xA1 0xBF 0x8 0x0
> ==24699== Invalid read of size 1
> ==24699==    at 0x7FEFFD3E4: ???
> ==24699==    by 0x7FEFFD3EB: ???
> ==24699==    by 0x7FEFFD3F3: ???
> ==24699==  Address 0x0 is not stack'd, malloc'd or (recently) free'd
> ==24699== 
> ==24699== Process terminating with default action of signal 11 (SIGSEGV)
> ==24699==  Access not within mapped region at address 0x0
> ==24699==    at 0x7FEFFD3E4: ???
> ==24699==    by 0x7FEFFD3EB: ???
> ==24699==    by 0x7FEFFD3F3: ???
> ==24699== 
> ==24699== ERROR SUMMARY: 1 errors from 1 contexts (suppressed: 2 from 1)
> Segmentation fault
> 
> Does this help any more?

I still don't have a clear clue on what's wrong with this.
