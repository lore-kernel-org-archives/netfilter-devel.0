From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: PATCH: "invalid SYNIN=" - a patch and a question
Date: Wed, 17 Oct 2007 22:08:39 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710172207070.8216@bizon.gios.gov.pl>
References: <Pine.LNX.4.64.0709261414200.676@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710031420130.5307@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710102054120.13087@blackhole.kfki.hu>
 <Pine.LNX.4.64.0710112238010.29814@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710120026240.14889@blackhole.kfki.hu>
 <Pine.LNX.4.64.0710121139240.10132@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710121611580.15832@blackhole.kfki.hu>
 <Pine.LNX.4.64.0710122002020.10132@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710171935320.26023@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-2070221482-1192651719=:8216"
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:42001 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758063AbXJQUIp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Oct 2007 16:08:45 -0400
In-Reply-To: <Pine.LNX.4.64.0710171935320.26023@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-2070221482-1192651719=:8216
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Wed, 17 Oct 2007, Jozsef Kadlecsik wrote:

> On Fri, 12 Oct 2007, Krzysztof Oledzki wrote:
>
>>> Could you send me a pcap file captured with '-s 0'? Then I could replay=
 it
>>> and see what happens.
>>
>> Attached.
>
> Thank you, that was really useful. So instead of the patch I sent last
> time about active close, please apply the patch below: setting the
> last_dir parameter was missing from the previous one.
>
> Signed-off-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>

Thank you very much.

Tested-by: Krzysztof Piotr Oledzki <ole@ans.pl>

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-2070221482-1192651719=:8216--
