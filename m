From: Friedrich Lobenstock <fl@fl.priv.at>
Subject: Re: question regarding iptables tuning (was Re: iptables denial of
 services)
Date: Sat, 17 Apr 2004 23:13:27 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40819DF7.4090509@fl.priv.at>
References: <Pine.LNX.4.44.0404171843020.22016-100000@filer.marasystems.com>	 <408167F2.9060501@fl.priv.at> <408180C7.6080302@eurodev.net>	 <40818C75.8010609@fl.priv.at>  <4081911D.1070307@fl.priv.at>	 <1082234028.13261.375.camel@tux.rsn.bth.se>  <4081967F.8040005@fl.priv.at> <1082235494.13261.385.camel@tux.rsn.bth.se>
Reply-To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <1082235494.13261.385.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Martin Josefsson wrote on 17.04.2004 22:58 MET:
> On Sat, 2004-04-17 at 22:41, Friedrich Lobenstock wrote:
> 
> 
>>>The new hashfunction (jenkins) doesn't need that (2.4 and 2.6 has it).
>>>It's very happy with 2^n sizes, in fact it's happy with all sizes :)
>>
>>Since which official kernel 2.4 release do we have the new hash? If it is 
>>just 2.4.24 or up then you should still need to mention this fact about the 
>>prime number. See the one guy posting about kernel 2.4.20.
> 
> I don't remember since which kernel. Tell the person who wrote that
> document to update it.

I just got this link from Pablo and I am not a netfilter developer, so 
someone with higher professiency in the netfilter area might want to do that.

> Please don't mention kernel 2.4.20, conntrack is horribly broken in
> 2.4.20 unless patched...

I am not using it but I just wanted to show you that you can not expect 
that the versions without the improved hash are not deployed anymore.

-- 
MfG / Regards
Friedrich Lobenstock
