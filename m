From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH 4/7] netfilter: fix wrong byte order in nf_ct_seqadj_set
 internal information
Date: Fri, 22 Nov 2013 21:16:50 +0400
Message-ID: <528F9182.7020205@cogentembedded.com>
References: <1385024728-4057-1-git-send-email-pablo@netfilter.org> <1385024728-4057-5-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: davem@davemloft.net, netdev@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f178.google.com ([209.85.217.178]:52428 "EHLO
	mail-lb0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755881Ab3KVRRE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Nov 2013 12:17:04 -0500
Received: by mail-lb0-f178.google.com with SMTP id c11so1169465lbj.23
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Nov 2013 09:17:03 -0800 (PST)
In-Reply-To: <1385024728-4057-5-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello.

On 21-11-2013 13:05, Pablo Neira Ayuso wrote:

> From: Phil Oester <kernel@linuxace.com>

> In commit 41d73ec053d2, sequence number adjustments were moved to a

    Please also specify that commit's summary line in parens.

> separate file. Unfortunately, the sequence numbers that are stored
> in the nf_ct_seqadj structure are expressed in host byte order. The
> necessary ntohl call was removed when the call to adjust_tcp_sequence
> was collapsed into nf_ct_seqadj_set. This broke the FTP NAT helper.
> Fix it by adding back the byte order conversions.

> Reported-by: Dawid Stawiarski <dawid.stawiarski@netart.pl>
> Signed-off-by: Phil Oester <kernel@linuxace.com>
> Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

WBR, Sergei

