From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] Add SELinux context support to AUDIT target
Date: Thu, 26 May 2011 19:44:52 +0200
Message-ID: <4DDE9194.4030303@netfilter.org>
References: <4DD5BF5A.2030108@googlemail.com> <4DDE848F.1070508@netfilter.org> <4DDE87F5.9050606@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47809 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754011Ab1EZRpH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 May 2011 13:45:07 -0400
In-Reply-To: <4DDE87F5.9050606@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 26/05/11 19:03, Mr Dash Four wrote:
>> I think this new information should be added at the end of the string.
>>   
> In other words:
> 
> type=NETFILTER_PKT msg=audit(1305852240.082:31012): action=0 hook=3
> len=52 inif=? outif=eth0 saddr=10.1.1.7 daddr=10.1.2.1 ipid=16312
> proto=6 sport=56150 dport=22 subj=system_u:object_r:sshd_packet_t:s0
> 
> As I am currently discussing this very issue (adding SELinux context to
> AUDIT) on the audit mail list, it was pointed out that "subj" should
> actually be "obj" as this is an object (i.e. a packet) on which this is
> applied, so that would ultimately mean:
> 
> type=NETFILTER_PKT msg=audit(1305852240.082:31012): action=0 hook=3
> len=52 inif=? outif=eth0 saddr=10.1.1.7 daddr=10.1.2.1 ipid=16312
> proto=6 sport=56150 dport=22 obj=system_u:object_r:sshd_packet_t:s0

OK, that's fine.

> I also need to check as I think the order is also important, otherwise
> ausearch/aureport may skip this due to "misconfiguration".

I was spotting this because we don't want to break any existing FOSS
application that parses the output. Adding things at the end seems to me
like the better way to avoid this?

So, please, make sure that we don't break anything.
