From: =?utf-8?q?K=C3=B6vesdi_Gy=C3=B6rgy?= <kgy@teledigit.hu>
Subject: Re: 2.6.28(.1) and netlink: scheduling while atomic
Date: Wed, 21 Jan 2009 11:25:46 +0100
Message-ID: <200901211125.46866.kgy@teledigit.hu>
References: <200901211029.01619.kgy@teledigit.hu> <4976F0EB.8050806@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fxip-0059e.externet.hu ([88.209.247.158]:35204 "EHLO
	teledigit.hu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1762016AbZAUK14 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 21 Jan 2009 05:27:56 -0500
Received: from kgy-wifi.deverto.office ([195.70.47.5]:48359)
	by teledigit.hu with [XMail 1.25 ESMTP Server]
	id <S667> for <netfilter-devel@vger.kernel.org> from <kgy@teledigit.hu>;
	Wed, 21 Jan 2009 11:27:48 +0100
In-Reply-To: <4976F0EB.8050806@trash.net>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> Thanks for the report. Does this patch fix it?
Thanks, it works!

Regards
K. Gy.
