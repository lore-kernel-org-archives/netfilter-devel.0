From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: ipt_ACCOUNT 1.11 warning fix
Date: Thu, 27 Sep 2007 14:16:35 +0200
Message-ID: <200709271416.35696.thomas.jarosch@intra2net.com>
References: <Pine.LNX.4.64.0709271144100.30621@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@computergmbh.de>
To: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from re01.intra2net.com ([82.165.28.202]:2686 "EHLO
	re01.intra2net.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765AbXI0MpY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Sep 2007 08:45:24 -0400
In-Reply-To: <Pine.LNX.4.64.0709271144100.30621@fbirervta.pbzchgretzou.qr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hello Jan,

On Thursday, 27. September 2007, you wrote:
> sizeof() produces a 'size_t', which is a little bit larger than %u on
> 64-bit. Fix it, the right way using %zu.

Applied, thanks. Will be in the next release.

Thomas
