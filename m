From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xt_TCPMSS loading issue
Date: Wed, 31 Oct 2007 13:36:09 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0710311333470.28807@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0710301853110.31325@fbirervta.pbzchgretzou.qr>
 <472867AE.5020702@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:35062 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753631AbXJaMgL (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 31 Oct 2007 08:36:11 -0400
In-Reply-To: <472867AE.5020702@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Oct 31 2007 12:31, Patrick McHardy wrote:
>> If I manually `modprobe xt_TCPMSS`, iptables succeeds. Any idea?
>
> Works fine for me. Does "modprobe ipt_TCPMSS" work?
>
No, it does not, that is odd.

13:33 ichi:../misc/suser-jengelh # modprobe ipt_TCPMSS
WARNING: module 'xt_TCPMSS' is unsupported
FATAL: Module ipt_TCPMSS not found.

Ok, time to spank Novell... thanks :)
