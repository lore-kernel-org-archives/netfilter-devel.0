From: WANG Cong <xiyou.wangcong@gmail.com>
Subject: Re: [Patch] fix one typo
Date: Fri, 22 Aug 2008 18:23:30 +0100
Message-ID: <20080822172330.GA28634@hack.voiplan.pt>
References: <20080822163240.GH3053@hack.voiplan.pt> <alpine.LNX.1.10.0808221258560.10702@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.170]:42796 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751801AbYHVRZQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 22 Aug 2008 13:25:16 -0400
Received: by ug-out-1314.google.com with SMTP id c2so188246ugf.37
        for <netfilter-devel@vger.kernel.org>; Fri, 22 Aug 2008 10:25:14 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <alpine.LNX.1.10.0808221258560.10702@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 22, 2008 at 12:59:30PM -0400, Jan Engelhardt wrote:
>
>On Friday 2008-08-22 12:32, WANG Cong wrote:
>>
>>Fix a typo in a man page.
>>
>>Signed-off-by: WANG Cong <wangcong@zeuux.org>
>>
>>---
>>diff --git a/extensions/libxt_tcp.man b/extensions/libxt_tcp.man
>>index b087fc9..4b7b2d1 100644
>>--- a/extensions/libxt_tcp.man
>>+++ b/extensions/libxt_tcp.man
>>@@ -7,7 +7,7 @@ name or a port number. An inclusive range can also be specified,
>> using the format \fIport\fP\fB:\fP\fIport\fP.
>> If the first port is omitted, "0" is assumed; if the last is omitted,
>> "65535" is assumed.
>>-If the second port greater then the first they will be swapped.
>>+If the second port greater than the first they will be swapped.
>
>Hehe... there's more than just that, an "is" and a comma!
>
>  If the second port is greater than the first, they will be swapped.

Right, thanks. :-)

New patch is below:

---
diff --git a/extensions/libxt_tcp.man b/extensions/libxt_tcp.man
index b087fc9..7806834 100644
--- a/extensions/libxt_tcp.man
+++ b/extensions/libxt_tcp.man
@@ -7,7 +7,7 @@ name or a port number. An inclusive range can also be specified,
 using the format \fIport\fP\fB:\fP\fIport\fP.
 If the first port is omitted, "0" is assumed; if the last is omitted,
 "65535" is assumed.
-If the second port greater then the first they will be swapped.
+If the second port is greater than the first, they will be swapped.
 The flag
 .B --sport
 is a convenient alias for this option.


