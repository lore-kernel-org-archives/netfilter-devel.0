From: =?ISO-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>
Subject: Re: Every other char with LOG netfilter output (bug?)
Date: Thu, 30 Oct 2008 03:50:22 -0200
Message-ID: <49094b22.0f87460a.09d2.55b6@mx.google.com>
References: <rlujt5-k63.ln1@tux.abusar.org.br>
	<49074E81.6010207@trash.net>
	<49075276.2686460a.0b00.ffff9f09@mx.google.com>
	<4907564D.5090103@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from el-out-1112.google.com ([209.85.162.179]:44616 "EHLO
	el-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752076AbYJ3Fu3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Oct 2008 01:50:29 -0400
Received: by el-out-1112.google.com with SMTP id z25so180383ele.1
        for <netfilter-devel@vger.kernel.org>; Wed, 29 Oct 2008 22:50:28 -0700 (PDT)
In-Reply-To: <4907564D.5090103@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 28 Oct 2008 19:13:33 +0100
Patrick McHardy <kaber@trash.net> wrote:

> I'm not familiar with ftrace, but you could manually instrument it
> (net/ipv4/netfilter/ipt_LOG.c). I'd try nfnetlink_log first though.

	Hi Patrick, I installed ulogd2 with all necessary stuff. The
normal log is working (with the default ulogd.conf), but how can I
configure it to log the full packets? If you can provide me a sample
configuration, I'll appreciate!

	Thank you!


-- 
