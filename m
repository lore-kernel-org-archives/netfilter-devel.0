From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: ebtables-restore 2.0.10-4 IPv6 rule loading bug
Date: Mon, 01 Jul 2013 16:39:55 +0200
Message-ID: <3663222.MEMvUxKbKp@storm>
References: <51CE1A3F.5070608@uolinc.com> <047B2411FCFD384496E507B08A91DD485F65431B@A4-SALOMAO7.uolcorp.intranet> <1501849513.20130701043324@terra.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-15"
Content-Transfer-Encoding: 7Bit
Cc: netfilter-devel@vger.kernel.org
To: TDT Homepage <tdthp@terra.com.br>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from re04.intra2net.com ([82.165.46.26]:48536 "EHLO
	re04.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754196Ab3GAOkG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Jul 2013 10:40:06 -0400
In-Reply-To: <1501849513.20130701043324@terra.com.br>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Luis,

On Monday, 1. July 2013 04:33:24 Luis Fernando wrote:
> As you can see (bold), however, in the restored version there's trash in
> the source IPv6 address and mask. I'd put my money on a zeroing problem,
> but I couldn't find it so far.

"valgrind" might be a good way to identify the use of uninitialized memory,
at least for the userspace part.

Thomas

