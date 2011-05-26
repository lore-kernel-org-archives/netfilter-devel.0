From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] Add SELinux context support to AUDIT target
Date: Thu, 26 May 2011 18:49:19 +0200
Message-ID: <4DDE848F.1070508@netfilter.org>
References: <4DD5BF5A.2030108@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43322 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932308Ab1EZQt1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 May 2011 12:49:27 -0400
In-Reply-To: <4DD5BF5A.2030108@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 20/05/11 03:09, Mr Dash Four wrote:
> Add SELinux context support for AUDIT target. Typical (raw auditd) output after applying this patch would be:
> 
> type=NETFILTER_PKT msg=audit(1305852240.082:31012): action=0 hook=3 len=52 inif=? outif=eth0 subj=system_u:object_r:sshd_packet_t:s0 saddr=10.1.1.7 daddr=10.1.2.1 ipid=16312 proto=6 sport=56150 dport=22

I think this new information should be added at the end of the string.
