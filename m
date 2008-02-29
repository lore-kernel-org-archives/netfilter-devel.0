From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Fix define value of SCTP chunk type.
Date: Fri, 29 Feb 2008 13:41:05 +0100
Message-ID: <47C7FD61.4070304@trash.net>
References: <47C7D827.6030603@miraclelinux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Naohiro Ooiwa <nooiwa@miraclelinux.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:19538 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757885AbYB2Ml0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Feb 2008 07:41:26 -0500
Received: from edge03 ([192.168.13.238]) by viefep17-int.chello.at
          (InterMail vM.7.08.02.00 201-2186-121-20061213) with ESMTP
          id <20080229124122.ZXRD27032.viefep17-int.chello.at@edge03>
          for <netfilter-devel@vger.kernel.org>;
          Fri, 29 Feb 2008 13:41:22 +0100
In-Reply-To: <47C7D827.6030603@miraclelinux.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Naohiro Ooiwa wrote:
> This is a trivial fix.
> There are wrong chunk_type values in sctp table.
> The chunk_type of ASCONF and ASCNF_ACK must be 193 and 128, respectively.

Applied, thanks.
