From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] xt_recent: Fix false hit_count match
Date: Mon, 22 Mar 2010 18:31:19 +0100
Message-ID: <4BA7A967.9060308@trash.net>
References: <20100219174904.1F62CF8C3F@sepang.rtg.net> <201003191604.45719.thomas.jarosch@intra2net.com> <4BA39B3D.4070509@trash.net> <201003191719.54550.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060303070806090105010900"
Cc: netfilter-devel@vger.kernel.org
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:39781 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212Ab0CVRbU (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 22 Mar 2010 13:31:20 -0400
In-Reply-To: <201003191719.54550.thomas.jarosch@intra2net.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060303070806090105010900
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Thomas Jarosch wrote:
> On Friday, 19. March 2010 16:41:49 you wrote:
>   
>>> Maybe this is related to the xt_recent
>>> proc interface creating the entry
>>> (with a zero hit count)?
>>>       
>> Mhh, looking at that patch again, I think it should actually do:
>>
>> if (!info->hit_count || ++hits >= info->hit_count)
>>     ...
>>
>> since a hit_count of 0 implies that the user just wants to check for the
>> presence of the entry. Thomas, could you give that a try?
>>     
>
> The new code works. Isn't that almost the same as reverting
> the original patch? info->hit_count == 0 will match again.
>
> So we could just go back to
>
> "if (++hits >= info->hit_count)"
>
> Or am I missing something?
>
> Clearly your new version is more readable about the intent.

Thomas, before I send this upstream with a Tested-by tag in your name,
could you please confirm that this is the change you've actually tested?

Thanks.



--------------060303070806090105010900
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

commit ef1691504c83ba3eb636c0cfd3ed33f7a6d0b4ee
Author: Patrick McHardy <kaber@trash.net>
Date:   Mon Mar 22 18:25:20 2010 +0100

    netfilter: xt_recent: fix regression in rules using a zero hit_count
    
    Commit 8ccb92ad (netfilter: xt_recent: fix false match) fixed supposedly
    false matches in rules using a zero hit_count. As it turns out there is
    nothing false about these matches and people are actually using entries
    with a hit_count of zero to make rules dependant on addresses inserted
    manually through /proc.
    
    Since this slipped past the eyes of three reviewers, instead of
    reverting the commit in question, this patch explicitly checks
    for a hit_count of zero to make the intentions more clear.
    
    Reported-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
    Tested-by: Thomas Jarosch <thomas.jarosch@intra2net.com>
    Cc: stable@kernel.org
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/netfilter/xt_recent.c b/net/netfilter/xt_recent.c
index 7073dbb..971d172 100644
--- a/net/netfilter/xt_recent.c
+++ b/net/netfilter/xt_recent.c
@@ -267,7 +267,7 @@ recent_mt(const struct sk_buff *skb, const struct xt_match_param *par)
 		for (i = 0; i < e->nstamps; i++) {
 			if (info->seconds && time_after(time, e->stamps[i]))
 				continue;
-			if (info->hit_count && ++hits >= info->hit_count) {
+			if (!info->hit_count || ++hits >= info->hit_count) {
 				ret = !ret;
 				break;
 			}

--------------060303070806090105010900--
