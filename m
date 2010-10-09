From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: [patch] arptables: some patches from debian
Date: Sat, 09 Oct 2010 21:17:57 +0200
Message-ID: <4CB0BFE5.7070201@pandora.be>
References: <1284558534.22085.164.camel@tablet> <1286630249.3611.514.camel@tablet>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: ebtables-devel@lists.sourceforge.net,
	Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: Peter Volkov <pva@gentoo.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from brigitte.telenet-ops.be ([195.130.137.66]:47481 "EHLO
	brigitte.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757059Ab0JITXD (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 9 Oct 2010 15:23:03 -0400
In-Reply-To: <1286630249.3611.514.camel@tablet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello Peter,

Patch 2 and 3 are committed.
For the '*' part of patch 1 I'd rather remove the -v usage in 
arptables-restore. This will require fixing the reason why -v is used in 
the first place. I wasn't aware this is due to a bug: the -i and -o 
interfaces aren't printed unless -v is specified. I'll look into this.

cheers,
Bart

On 09-10-10 15:17, Peter Volkov wrote:
> Hi again. What is the best way to contact arptables developers? My
> previous patch was left without attention, should I resend it? In
> attachment there are three fixes from debian:
>
> 1. arptables_save patch makes arp_tables don't resolve host names and
> don't convert '*' interface names to any. Remove '*' interface names.
> 2. manpage patch removes old version from man page
> 3. is a patch from Jeroen van Wolffelaar to make arptables --proto-type
> also accept hexadecimal inputs (ethernet protocol numbers are often
> specfied in hex, not decimal), using standard strtol() behaviour (hex
> iff starts with 0x).
>
> Please, apply.
>    


-- 
Bart De Schuymer
www.artinalgorithms.be

