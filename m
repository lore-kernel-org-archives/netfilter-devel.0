From: Peter Warasin <peter@endian.com>
Subject: Re: [PATCH 1/3] iptables-edit: iptables-edit: adds --table to iptables-restore
Date: Wed, 07 Nov 2007 14:44:47 +0100
Message-ID: <4731C14F.50607@endian.com>
References: <472E6041.7090601@endian.com> <Pine.LNX.4.64.0711071150390.1982@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------060906000501090001030708"
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from solaria.endian.it ([80.190.199.145]:54150 "EHLO
	solaria.endian.it" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758419AbXKGNo5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Nov 2007 08:44:57 -0500
In-Reply-To: <Pine.LNX.4.64.0711071150390.1982@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

This is a multi-part message in MIME format.
--------------060906000501090001030708
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

Hi Jan

Jan Engelhardt wrote:
> Well, please send patches inline so I can reply to something.

Ok,..  I think i eventually have to upgrade my thunderbird, since i have
no option for sending inline attachments :-O


> |adds --table to iptables-restore which allows to restore only the
> |supplied table

This patch is already applied. Should i fix your suggestions or leave it
as it is?



> |-	while ((c = getopt_long(argc, argv, "bcvthnM:", options, NULL)) != -1) {
> |+	while ((c = getopt_long(argc, argv, "bcvthnM:T:", options, NULL)) != -1) {
> 
> Use -t instead, that would go in line with the -t from iptables.

-t is already --test, therefore i used -T
I suggest changing --test to --dry-run (-d), so -t will turn free for
--table, what do you think?

peter

-- 
:: e n d i a n
:: open source - open minds

:: peter warasin
:: http://www.endian.com   :: peter@endian.com

--------------060906000501090001030708
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


--------------060906000501090001030708--
