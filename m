From: Mr Dash Four <mr.dash.four@googlemail.com>
Subject: Re: [PATCH] Add SELinux context support to AUDIT target
Date: Thu, 26 May 2011 18:03:49 +0100
Message-ID: <4DDE87F5.9050606@googlemail.com>
References: <4DD5BF5A.2030108@googlemail.com> <4DDE848F.1070508@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42926 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751533Ab1EZRDz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 26 May 2011 13:03:55 -0400
Received: by wya21 with SMTP id 21so673981wya.19
        for <netfilter-devel@vger.kernel.org>; Thu, 26 May 2011 10:03:54 -0700 (PDT)
In-Reply-To: <4DDE848F.1070508@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


> I think this new information should be added at the end of the string.
>   
In other words:

type=NETFILTER_PKT msg=audit(1305852240.082:31012): action=0 hook=3 
len=52 inif=? outif=eth0 saddr=10.1.1.7 daddr=10.1.2.1 ipid=16312 
proto=6 sport=56150 dport=22 subj=system_u:object_r:sshd_packet_t:s0

As I am currently discussing this very issue (adding SELinux context to 
AUDIT) on the audit mail list, it was pointed out that "subj" should 
actually be "obj" as this is an object (i.e. a packet) on which this is 
applied, so that would ultimately mean:

type=NETFILTER_PKT msg=audit(1305852240.082:31012): action=0 hook=3 
len=52 inif=? outif=eth0 saddr=10.1.1.7 daddr=10.1.2.1 ipid=16312 
proto=6 sport=56150 dport=22 obj=system_u:object_r:sshd_packet_t:s0

I also need to check as I think the order is also important, otherwise 
ausearch/aureport may skip this due to "misconfiguration".
