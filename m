From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: nf_conntrack.acct has no effect
Date: Tue, 17 Mar 2009 16:41:35 +0100 (CET)
Message-ID: <alpine.LSU.2.00.0903171639270.7260@fbirervta.pbzchgretzou.qr>
References: <alpine.LSU.2.00.0903161749530.16494@fbirervta.pbzchgretzou.qr> <49BE84D4.7050804@trash.net> <20090317082425.GA25491@mail.eitzenberger.org> <alpine.LNX.1.10.0903171409550.17354@bizon.gios.gov.pl> <alpine.LSU.2.00.0903171425520.30677@fbirervta.pbzchgretzou.qr>
 <alpine.LSU.2.00.0903171535210.3657@fbirervta.pbzchgretzou.qr> <49BFB69C.6030004@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Krzysztof Oledzki <ole@ans.pl>,
	Holger Eitzenberger <holger@eitzenberger.org>,
	pablo@netfilter.org,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:36544 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753717AbZCQPlj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 17 Mar 2009 11:41:39 -0400
In-Reply-To: <49BFB69C.6030004@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2009-03-17 15:41, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> xt_conntrack for example has a nicer effect: once you add a rule that
>> contains it, it will load nf_conntrack_ipv{4,6}, which in turn causes
>> Netfilter to start tracking in the first place.
>>
>> So along the lines, xt_connbytes could pin a module (or perhaps
>> something more light-weight) to ultimately signify
>> "forced-activation"/"deactivation-impossible", much like you cannot
>> remove nf_conntrack while an xt_conntrack-using rule is in place.
>
> It doesn't have to be forced IMO, but yes, the automatic enabling
> should be similar to what xt_conntrack does.
>
>> Then only one thing remains. As for nf_conntrack, once it is loaded,
>> it picks up already-running connections (and loses them as soon
>> as you rmmod it). This is not the case with accounting as far as I
>> have observed yesterday - only new connections get to have (or
>> not to have) an acct structure; existing ones are not modified
>> or picked up like conntrack does.
>
> Thats not possible using ct_extend.
>
I see. It is probably best then to document this behavior in iptables.
To that end, here are two patches, pullable from

	git://dev.medozas.de/iptables master

Jan Engelhardt (2):
      libxt_connbytes: minor manpage adustments
      libxt_connbytes: document nf_ct_acct behavior

Updating 38725a4..71bc61f
Fast forward
 extensions/libxt_connbytes.man |   16 +++++++++++-----
 1 files changed, 11 insertions(+), 5 deletions(-)

# combined-diff 38725a4..71bc61f
diff --git a/extensions/libxt_connbytes.man b/extensions/libxt_connbytes.man
index fc8c141..e475cae 100644
--- a/extensions/libxt_connbytes.man
+++ b/extensions/libxt_connbytes.man
@@ -1,14 +1,20 @@
 Match by how many bytes or packets a connection (or one of the two
 flows constituting the connection) has transferred so far, or by
 average bytes per packet.
-
-The counters are 64bit and are thus not expected to overflow ;)
-
+.PP
+The counters are 64-bit and are thus not expected to overflow ;)
+.PP
 The primary use is to detect long-lived downloads and mark them to be
 scheduled using a lower priority band in traffic control.
-
+.PP
 The transferred bytes per connection can also be viewed through
-/proc/net/ip_conntrack and accessed via ctnetlink
+`conntrack -L` and accessed via ctnetlink.
+.PP
+NOTE that for connections which have no accounting information, the match will
+always return false. The "net.netfilter.nf_conntrack_acct" sysctl flag controls
+whether \fBnew\fP connections will be byte/packet counted. Existing connection
+flows will not be gaining/losing a/the accounting structure when be sysctl flag
+is flipped.
 .TP
 [\fB!\fP] \fB\-\-connbytes\fP \fIfrom\fP[\fB:\fP\fIto\fP]
 match packets from a connection whose packets/bytes/average packet
