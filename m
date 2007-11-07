From: Peter Warasin <peter@endian.com>
Subject: Re: [PATCH 0/3] iptables-edit: tool to apply iptables rules to iptables-save'ed
 statefiles
Date: Wed, 07 Nov 2007 13:24:57 +0100
Message-ID: <4731AE99.8080105@endian.com>
References: <472E6039.7060801@endian.com> <Pine.LNX.4.64.0711071148530.1982@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------020303020009000308090608"
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from solaria.endian.it ([80.190.199.145]:54053 "EHLO
	solaria.endian.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757133AbXKGMZQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Nov 2007 07:25:16 -0500
In-Reply-To: <Pine.LNX.4.64.0711071148530.1982@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------020303020009000308090608
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Jan

Jan Engelhardt wrote:
> On Nov 5 2007 01:13, Peter Warasin wrote:
>> Most firewall scripts (for example fwbuilder, shorewall, firehole,
>> etc..) work always this way:
> fwbuilder uses (can use) iptables-save.

I see, cool! I missed that one the last time i tried.
Think i should give it another try.

At the other hand it's a compiler, which rebuilds from scratch, isn't it?.
Another advantage (can also be a disadvantage) is that iptables-edit
don't rebuild the entire firewall ruleset from scratch, so one can have
it's manually added iptables rules which then do not disappear after
next iptables-restore.

Furthermore option handling will be done by iptables extensions itself
and it's not necessary anymore to separately implement it within the
compiler. Could be an advantage.

peter
-- 
:: e n d i a n
:: open source - open minds

:: peter warasin
:: http://www.endian.com   :: peter@endian.com

--------------020303020009000308090608
Content-Type: text/x-vcard; charset=utf-8;
 name="peter.vcf"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="peter.vcf"

begin:vcard
fn:Peter Warasin
n:;Peter Warasin
org:Endian GmbH/Srl
adr:;;Pillhof 47;Frangart/Frangarto;BZ;I-39010;Italien/Italia
email;internet:peter@endian.com
tel;work:+39 0471 631763
tel;fax:+39 0471 631764
x-mozilla-html:FALSE
url:http://www.endian.com
version:2.1
end:vcard


--------------020303020009000308090608--
