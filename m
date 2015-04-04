From: Alexander Holler <holler@ahsoftware.de>
Subject: Re: [PATCH] parser: add kludges for "param-problem" and "redirect"
Date: Sat, 04 Apr 2015 12:50:57 +0200
Message-ID: <551FC211.6000907@ahsoftware.de>
References: <551BEF7F.3050908@ahsoftware.de> <1428083429-7042-1-git-send-email-holler@ahsoftware.de> <551ED696.4070001@ahsoftware.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Eric Leblond <eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from h1446028.stratoserver.net ([85.214.92.142]:49349 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977AbbDDKvG (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 4 Apr 2015 06:51:06 -0400
Received: from wandq.ahsoftware (p4FC37AA6.dip0.t-ipconnect.de [79.195.122.166])
	(using TLSv1 with cipher ADH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mail.ahsoftware.de (Postfix) with ESMTPSA id 109372C9C1C4
	for <netfilter-devel@vger.kernel.org>; Sat,  4 Apr 2015 12:51:03 +0200 (CEST)
In-Reply-To: <551ED696.4070001@ahsoftware.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 03.04.2015 um 20:06 schrieb Alexander Holler:
> Am 03.04.2015 um 19:50 schrieb Alexander Holler:
>> Context sensitive handling of "param-problem" and "redirect" is necessary
>> to allow usage of them as token or as string for icmp types.
>>
>> Without this patch, e.g. the following fails:
>>
>> nft add rule filter input icmp type redirect accept
>> nft add rule filter input icmpv6 type param-problem accept
>>
>> Signed-off-by: Alexander Holler <holler@ahsoftware.de>
>> ---
>
> Just in case of, I have not tested this extensively.
>
> So please be careful with that patch and review it.
>
> E.g. I'm not sure if I might have forgotten to set icmp_flag = 0 in
> another desctructor than those two I've added it too because I haven't
> tested rules which are using "redirect" or param-problem as token and
> not just as string to describe an icmp type as in the above two statements.

Also I'm soliloquizing, here is an update.

Having had a second look at the parser, I think I indeed have forgotten 
a desctructor and this one should be changed too:

-%destructor { stmt_free($$); } reject_stmt reject_stmt_alloc
+%destructor { stmt_free($$); icmp_flag = 0; }  reject_stmt 
reject_stmt_alloc

I've now also written a small test-script which revealed an error in my 
kludges:

-- test-kludges.nft --
#!/sbin/nft -f

# small script to test the kludges (context sensitivity) for
# for "redirect" and "param-problem".

flush ruleset

table filter {
         chain input {
                 type filter hook input priority 0;
                 icmp type redirect accept
                 tcp dport 22223 reject with icmp type host-prohibited
         }
}
table ip6 filter {
         chain input {
                 type filter hook input priority 0;
                 icmpv6 type param-problem accept
                 tcp dport 22224 reject with icmpv6 type admin-prohibited
                 # THIS NOW FAILS:
                 #icmpv6 param-problem 2 drop
         }
}
table nat {
         chain prerouting {
                 type nat hook prerouting priority 0;
                 tcp dport 22222 redirect to 22
         }
         chain postrouting {
                 type nat hook postrouting priority 0;
         }
}
-- test-kludges.nft --


I'll already have an idea how to fix that and will post a second version 
of the patch when I've found the time to change and test it.


Regards,

Alexander Holler
