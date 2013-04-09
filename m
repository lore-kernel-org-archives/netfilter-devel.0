From: Mart Frauenlob <mart.frauenlob@chello.at>
Subject: Re: [PATCH] libipt6_mh.man: Correct command to display named mh types
Date: Tue, 09 Apr 2013 11:40:58 +0200
Message-ID: <5163E22A.50509@chello.at>
References: <5163BFD9.7060804@chello.at> <20130409084129.GA25238@macbook.localnet>
Reply-To: mart.frauenlob@chello.at
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060302020206000604030601"
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fep13.mx.upcmail.net ([62.179.121.33]:34167 "EHLO
	fep13.mx.upcmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935229Ab3DIJls (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 9 Apr 2013 05:41:48 -0400
In-Reply-To: <20130409084129.GA25238@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------060302020206000604030601
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

On 09.04.2013 10:41, Patrick McHardy wrote:
> On Tue, Apr 09, 2013 at 09:14:33AM +0200, Mart Frauenlob wrote:
>> ip6tables -p ipv6-mh -h
>>
>> does not display the named mh types as the man page says.
>> ip6tables -m mh -h does.
>
> ip6tables -p mh also does. So please update the manpage to correct
> the protocol.
>

done

--------------060302020206000604030601
Content-Type: text/plain; charset=windows-1252;
 name="libip6t_mh-Correct-command-to-list-named-mh-types-in-man.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename*0="libip6t_mh-Correct-command-to-list-named-mh-types-in-man.pat";
 filename*1="ch"

>From 39f5a982e40201faa97810d200cbc2d9d848996e Mon Sep 17 00:00:00 2001
From: Mart Frauenlob <mart.frauenlob@chello.at>
Date: Tue, 9 Apr 2013 11:38:47 +0200
Subject: [PATCH] libip6t_mh: Correct command to list named mh types in manpage.

---
 extensions/libip6t_mh.man |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/extensions/libip6t_mh.man b/extensions/libip6t_mh.man
index 4559e78..8ec08c6 100644
--- a/extensions/libip6t_mh.man
+++ b/extensions/libip6t_mh.man
@@ -8,5 +8,5 @@ a numeric MH
 .IR type
 or one of the MH type names shown by the command
 .nf
- ip6tables \-p ipv6\-mh \-h
+ ip6tables \-p mh \-h
 .fi
-- 
1.7.2.5


--------------060302020206000604030601--
