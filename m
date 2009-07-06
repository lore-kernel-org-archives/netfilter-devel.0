From: Patrick McHardy <kaber@trash.net>
Subject: Re: libnl: Unmatched NL_ACT_DEL and NL_ACT_CHANGE
Date: Mon, 06 Jul 2009 13:29:40 +0200
Message-ID: <4A51E024.8090402@trash.net>
References: <200907051144.51967.volker@openbios.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------050004080104090109080603"
Cc: netfilter-devel@vger.kernel.org
To: Volker Poplawski <volker@openbios.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58791 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751995AbZGFL3l (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jul 2009 07:29:41 -0400
In-Reply-To: <200907051144.51967.volker@openbios.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------050004080104090109080603
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit

Volker Poplawski wrote:
> Hi all.
> 
> Could s.o. please  have a look at my (short) code at
> http://pastie.org/534637
> 
> (maybe compile it with g++ -Wall test.c -o test -I ... -L ... -lnl -lnl-genl -
> lnl-nf -lnl-route)
> 
> What the code does is to listen to changes in the ct-table using libnl. It 
> keeps score of reported ctId in a lookup table.
> 
> Problem is: I'm getting a lot of NL_ACT_CHANGE & NL_ACT_DEL without having 
> seen a matching NL_ACT_NEW. (Also there seems to be no initial cache fill)
> 
> kernel 2.6.27 (opensuse 11.1), libnl 2.0 (git master)

I think I know whats happening - the ct objects don't define the
attribute(s) distinguishing different entries, so cache_include()
doesn't recognize them as new.

Does this patch make any difference?

--------------050004080104090109080603
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/lib/netfilter/ct_obj.c b/lib/netfilter/ct_obj.c
index ae14c0d..48a7abe 100644
--- a/lib/netfilter/ct_obj.c
+++ b/lib/netfilter/ct_obj.c
@@ -779,6 +779,7 @@ struct nl_object_ops ct_obj_ops = {
 	    [NL_DUMP_STATS]	= ct_dump_stats,
 	},
 	.oo_compare		= ct_compare,
+	.oo_id_attrs		= CT_ATTR_ID,
 	.oo_attrs2str		= ct_attrs2str,
 };
 

--------------050004080104090109080603--
