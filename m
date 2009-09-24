From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xt_stealth as separate patch against xtables-addons-1.17
Date: Thu, 24 Sep 2009 15:11:49 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0909241503360.29849@obet.zrqbmnf.qr>
References: <alpine.LNX.2.00.0909011937060.7713@cedric.unob.cz> <alpine.LSU.2.00.0909240211160.31517@obet.zrqbmnf.qr> <alpine.LNX.2.00.0909241450270.8925@cedric.unob.cz>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>, spender@grsecurity.net,
	Balazs Scheidler <bazsi@balabit.hu>
To: Jan Rafaj <jr+netfilter-devel@cedric.unob.cz>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:58053 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751253AbZIXNLr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 24 Sep 2009 09:11:47 -0400
In-Reply-To: <alpine.LNX.2.00.0909241450270.8925@cedric.unob.cz>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2009-09-24 14:58, Jan Rafaj wrote:
>> I looked at xt_stealth and it looks like
>> -A INPUT -j sktest; -A sktest -m socket -j RETURN; -A sktest -j DROP
>> can do just the same. Please tell me if I am wrong anywhere.
>> That would mean there is no need for xt_stealth.
>
> Yeah, thanks for suggestion.
> On 2.6.29.6 with iptables 1.4.4, tried [that].
> Unfortunately, adding the last rule failed with message:
>
>  ip_tables: socket match: bad hook_mask 0x2/0x1

Ah, xt_socket is only for PREROUTING at the moment. I wonder,
(cc'ing Balazs) whether there would be any adverse effect
(or not doing anything at all) if it were also made available
in INPUT. The difference would not be that much; you could
test for the socket in PREROUTING/mangle and set a mark;
test the mark in filter and DROP or let through. Anyway,
for great simplicity, I am proposing


parent 94a8d5caba74211ec76dac80fc6e2d5c391530df (v2.6.31-8358-g94a8d5c)
commit d075810e672c11ef7287f36f0366e9f44c0b46e2
Author: Jan Engelhardt <jengelh@medozas.de>
Date:   Thu Sep 24 15:09:19 2009 +0200

netfilter: xt_socket: make module available for INPUT chain

Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
---
 net/netfilter/xt_socket.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/xt_socket.c b/net/netfilter/xt_socket.c
index ebf00ad..3965778 100644
--- a/net/netfilter/xt_socket.c
+++ b/net/netfilter/xt_socket.c
@@ -192,7 +192,8 @@ static struct xt_match socket_mt_reg[] __read_mostly = {
 		.revision	= 0,
 		.family		= NFPROTO_IPV4,
 		.match		= socket_mt_v0,
-		.hooks		= 1 << NF_INET_PRE_ROUTING,
+		.hooks		= (1 << NF_INET_PRE_ROUTING) |
+				  (1 << NF_INET_LOCAL_IN),
 		.me		= THIS_MODULE,
 	},
 	{
@@ -201,7 +202,8 @@ static struct xt_match socket_mt_reg[] __read_mostly = {
 		.family		= NFPROTO_IPV4,
 		.match		= socket_mt_v1,
 		.matchsize	= sizeof(struct xt_socket_mtinfo1),
-		.hooks		= 1 << NF_INET_PRE_ROUTING,
+		.hooks		= (1 << NF_INET_PRE_ROUTING) |
+				  (1 << NF_INET_LOCAL_IN),
 		.me		= THIS_MODULE,
 	},
 };
-- 
# Created with git-export-patch

> Btw, the manpage for 'socket' match should clearly specify that
> an 'open socket' means socket in either listening or established state.
> I was first puzzled by what 'open socket' really means...

Now that you mention it, I guess it's "any socket" :-/
On the upside, more feature flags for xt_socket! :)
