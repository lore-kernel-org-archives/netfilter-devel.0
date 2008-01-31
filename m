From: Ingo Molnar <mingo@elte.hu>
Subject: Re: [build bug] ip_queue.c:(.init.text+0x322c): undefined
	reference to `net_ipv4_ctl_path'
Date: Thu, 31 Jan 2008 16:00:09 +0100
Message-ID: <20080131150008.GA9386@elte.hu>
References: <20080130164554.GA2800@elte.hu> <47A0BAB5.3080207@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org,
	"David S. Miller" <davem@davemloft.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx3.mail.elte.hu ([157.181.1.138]:34140 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755805AbYAaPA0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 31 Jan 2008 10:00:26 -0500
Content-Disposition: inline
In-Reply-To: <47A0BAB5.3080207@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


* Patrick McHardy <kaber@trash.net> wrote:

>> config attached.
>
> Thanks, the reason is CONFIG_SYSCTL=n. I've queued this patch (might 
> not apply to Linus' tree due to local changes) to fix the build error 
> and a runtime error with CONFIG_PROC_FS=n.

it applied fine here and it resolved the build problem. Thanks,

	Ingo
