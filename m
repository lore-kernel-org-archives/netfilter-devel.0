From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ebtables match inverted in 2.6.28? (Was: Re: ebtables
 match inverted in 2.6.28?)
Date: Mon, 12 Jan 2009 08:54:12 +0100
Message-ID: <496AF724.8060203@trash.net>
References: <84ee33570812311400m5492af64n45c645a13fe91c2c@mail.gmail.com> <1230779772.29793.31.camel@localhost> <496AD1C6.9080906@trash.net> <alpine.LSU.2.00.0901120835390.21692@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080704050400060605010308"
Cc: matthltc@us.ibm.com, Matt Cross <matt.cross@gmail.com>,
	LKML <linux-kernel@vger.kernel.org>,
	netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58069 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376AbZALHyO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 12 Jan 2009 02:54:14 -0500
In-Reply-To: <alpine.LSU.2.00.0901120835390.21692@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080704050400060605010308
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Jan Engelhardt wrote:
>>> On Wed, 2008-12-31 at 17:00 -0500, Matt Cross wrote:
>>>> I think the work to move ebtables to use xtables broke ebtables.
>>>> Specifically, in commit 8cc784eec6676b58e7f60419c88179aaa97bf71c the
>>>> return value of the match functions was inverted so that they return 1
>>>> (true) on matches instead of EBT_MATCH (0), and vice versa (look in
>>>> ebt_ip.c).  The logic in ebtables.c (ebt_do_table() and
>>>> EBT_MATCH_ITERATE()) expect match functions to return 0 for matches.
>>>>
>> Jan, could you have a look at this please?
> 
> That seemds indeed so.
> Patch is both for 2.6.29-running and 2.6.28.
> 
> netfilter: ebtables: fix inversion in match code

Applied, thanks. When fixing regressions please state the commit
ID and subject of the patch introducing the breakage and also who
reported it.

Like this.


--------------080704050400060605010308
Content-Type: text/x-patch;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

commit c6b52c688ecf03adb82724299b97701528821ca5
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Mon Jan 12 08:52:08 2009 +0100

    netfilter: ebtables: fix inversion in match code
    
    Commit 8cc784ee (netfilter: change return types of match functions
    for ebtables extensions) broke ebtables matches by inverting the
    sense of match/nomatch.
    
    Reported-by: Matt Cross <matthltc@us.ibm.com>
    Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
    Signed-off-by: Patrick McHardy <kaber@trash.net>

diff --git a/net/bridge/netfilter/ebtables.c b/net/bridge/netfilter/ebtables.c
index 8a8743d..820252a 100644
--- a/net/bridge/netfilter/ebtables.c
+++ b/net/bridge/netfilter/ebtables.c
@@ -79,7 +79,7 @@ static inline int ebt_do_match (struct ebt_entry_match *m,
 {
 	par->match     = m->u.match;
 	par->matchinfo = m->data;
-	return m->u.match->match(skb, par);
+	return m->u.match->match(skb, par) ? EBT_MATCH : EBT_NOMATCH;
 }
 
 static inline int ebt_dev_check(char *entry, const struct net_device *device)

--------------080704050400060605010308--
