From: Peter Warasin <peter@endian.com>
Subject: physdev-out
Date: Fri, 08 Feb 2008 19:26:33 +0100
Message-ID: <47AC9ED9.8020506@endian.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080405030100000903050103"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from solaria.endian.it ([80.190.199.145]:36256 "EHLO
	solaria.endian.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935312AbYBHS0v (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 8 Feb 2008 13:26:51 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by solaria.endian.it (Postfix) with ESMTP id 95B7A598334
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Feb 2008 19:26:42 +0100 (CET)
Received: from solaria.endian.it ([127.0.0.1])
	by localhost (solaria.endian.it [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id 2h6t7E0740OB for <netfilter-devel@vger.kernel.org>;
	Fri,  8 Feb 2008 19:26:41 +0100 (CET)
Received: from [10.7.254.1] (host115-14-static.23-87-b.business.telecomitalia.it [87.23.14.115])
	by solaria.endian.it (Postfix) with ESMTP id A231259821F
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Feb 2008 19:26:41 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by efw-frangart.endian.office (Postfix) with ESMTP id 66137277094
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Feb 2008 19:26:49 +0100 (CET)
Received: from [10.7.121.249] (unknown [10.7.121.249])
	by efw-frangart.endian.office (Postfix) with ESMTP id 953B9277093
	for <netfilter-devel@vger.kernel.org>; Fri,  8 Feb 2008 19:26:35 +0100 (CET)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------080405030100000903050103
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi guys

I run into the same problem like some other people (Like Philip and Greg
as far as google tells me) here on the list.
I try to warm-up the discussion, since I think currently it's no good
solution.

Since --physdev-out does not work anymore for connections coming from
outside the bridge, it's not possible anymore to *simply* create some
sort of filter rules.

I understand that you can solve the problem by creating rules by ip
addresses
instead of physdev-out devices and then allow by ebtables only that ip
addresses on that devices of which you know they are behind.

Or, you mark and then filter with ebtables by the nfmark.
That's the solution I chose, since I do not always know which ip pools I
have behind that interface. It would be ways easier to simply filter
by physdev-out.

But, this nfmark story turned out to be really a complex, complicated
nightmare, where you end debugging your rules with a pocket calculator.
Needless to say that it is error-prone at its best. And some cases you
even can't map with.

The necessity to filter physdev-out interfaces happens mostly if you need
bridged vpn endpoints, like Philip had.
You bridge together a vpn endpoint with a local bridge, due to protocols
where this is necessary, and at the same time you want to restrict the
traffic
coming from another device (which is not within the bridge) which needs
to go
into the vpn.

I understand that this change was necessary and it's saner now and that
it solved other problems. But I think that old functionality is somehow
saner to use. The possible solutions I am aware of IMHO are just
workarounds,
which sooner or later bring people in trouble.

Now I am not that familiar with that code and it takes me surely a while to
understand if there could be a sane solution.
So I would like to ask if you guys know of a better solution or can help
me going in the right direction.

thanks

peter

-- 
:: e n d i a n
:: open source - open minds

:: peter warasin
:: http://www.endian.com   :: peter@endian.com

--------------080405030100000903050103
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


--------------080405030100000903050103--
