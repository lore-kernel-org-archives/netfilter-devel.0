From: Patrick McHardy <kaber@trash.net>
Subject: Re: PATCH: "invalid SYNIN=" - a patch and a question
Date: Thu, 18 Oct 2007 10:43:00 +0200
Message-ID: <47171C94.5030607@trash.net>
References: <Pine.LNX.4.64.0709261414200.676@bizon.gios.gov.pl> <Pine.LNX.4.64.0710031420130.5307@bizon.gios.gov.pl> <Pine.LNX.4.64.0710102054120.13087@blackhole.kfki.hu> <Pine.LNX.4.64.0710112238010.29814@bizon.gios.gov.pl> <Pine.LNX.4.64.0710120026240.14889@blackhole.kfki.hu> <Pine.LNX.4.64.0710121139240.10132@bizon.gios.gov.pl> <Pine.LNX.4.64.0710121611580.15832@blackhole.kfki.hu> <Pine.LNX.4.64.0710122002020.10132@bizon.gios.gov.pl> <Pine.LNX.4.64.0710171935320.26023@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Krzysztof Oledzki <ole@ans.pl>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:63978 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbXJRIn3 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Oct 2007 04:43:29 -0400
In-Reply-To: <Pine.LNX.4.64.0710171935320.26023@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Jozsef Kadlecsik wrote:
> On Fri, 12 Oct 2007, Krzysztof Oledzki wrote:
> 
>>> Could you send me a pcap file captured with '-s 0'? Then I could replay it
>>> and see what happens.
>> Attached.
> 
> Thank you, that was really useful. So instead of the patch I sent last 
> time about active close, please apply the patch below: setting the 
> last_dir parameter was missing from the previous one.
> 
> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>


Applied, thanks Jozsef. I'll push the combined patch to -stable.

