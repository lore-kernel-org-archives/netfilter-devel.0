From: "Anthony G. Basile" <blueness@gentoo.org>
Subject: Re: [PATCH] netfilter: export sanitized nf_nat.h to INSTALL_HDR_PATH
Date: Tue, 11 Oct 2011 17:34:47 -0400
Message-ID: <4E94B677.4020400@gentoo.org>
References: <1317491489-23812-1-git-send-email-basile@opensource.dyc.edu> <4E8753C6.1020304@opensource.dyc.edu> <alpine.LNX.2.01.1110021451540.12367@frira.zrqbmnf.qr> <4E88609E.2030404@opensource.dyc.edu> <20111011014026.GA30418@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Anthony G. Basile" <basile@opensource.dyc.edu>,
	Jan Engelhardt <jengelh@medozas.de>, davem@davemloft.net,
	kaber@trash.net, gurligebis@gentoo.org, base-system@gentoo.org,
	kernel@gentoo.org, toolchain@gentoo.org, mchehab@redhat.com,
	hverkuil@xs4all.nl, laurent.pinchart@ideasonboard.com,
	arnd@arndb.de, eparis@redhat.com, netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp.gentoo.org ([140.211.166.183]:39711 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751256Ab1JKVev (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Oct 2011 17:34:51 -0400
In-Reply-To: <20111011014026.GA30418@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 10/10/2011 09:40 PM, Pablo Neira Ayuso wrote:
> On Sun, Oct 02, 2011 at 09:01:18AM -0400, Anthony G. Basile wrote:
>> On 10/02/2011 08:53 AM, Jan Engelhardt wrote:
>>> On Saturday 2011-10-01 19:54, Anthony G. Basile wrote:
>>>
>>>> As an appendix to this patch, let me add a couple of points:
>>>>
>>>> 1) In the union,
>>>>
>>>>> +union nf_conntrack_man_proto {
>>>>> +	__be16 all;
>>>>> +	__be16 port;
>>>>> +	__be16 icmp_idnt;
>>>>> +	__be16 gre_key;
>>>>> +};
>>>> I named the one member icmp_idnt to avoid a name collision with "#define
>>>> icmp_id ..." in <netinet/ip_icmp.h>.  This causes problems in both
>>>> iptables and miniupnpd.
>>> Wow that's a horrible thing to do of ip_icmp.h. Such #defines should die 
>>> because their scope is way too broad.
>> I know.  I hate it too, and it was not easy to catch.  But how else do
>> we get around it?  We could do an undef, but that's just as ugly.
> I found some time to take over this patch. I have compiled tested it,
> it's based on yours.
>
> I'll review it tomorrow in the morning again before pushing into into
> the temporary nf-next tree (until we can move again to kernel.org):
>
> http://1984.lsi.us.es/git/?p=net-next/.git;a=shortlog;h=refs/heads/nf-next
>
> P.S: Yes, we're back to the ugly definition of nf_conntrack_man_proto,
> I think it's the nicest solution given the problem that you spotted
> with icmp_id and it keeps the patch small.

Your patch is even better because you include
linux/netfilter_ipv4/nf_nat.h in net/netfilter/nf_nat.h and
nf_conntrack_tuple.h avoiding duplicate code.

Thanks for taking this on :)

-- 
Anthony G. Basile, Ph.D.
Gentoo Linux Developer [Hardened]
E-Mail    : blueness@gentoo.org
GnuPG FP  : 8040 5A4D 8709 21B1 1A88  33CE 979C AF40 D045 5535
GnuPG ID  : D0455535

