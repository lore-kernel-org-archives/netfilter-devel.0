From: Michael Wang <yun.wang@profitbricks.com>
Subject: Re: nfnetlink warnings
Date: Mon, 23 Nov 2015 11:36:34 +0100
Message-ID: <5652EC32.4020902@profitbricks.com>
References: <20151123093607.GA5134@pd.tnic>
 <5652E12E.3070500@profitbricks.com> <20151123095455.GB5134@pd.tnic>
 <5652E862.7000605@profitbricks.com> <20151123103212.GD5134@pd.tnic>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	lkml <linux-kernel@vger.kernel.org>
To: Borislav Petkov <bp@alien8.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151123103212.GD5134@pd.tnic>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org



On 11/23/2015 11:32 AM, Borislav Petkov wrote:
> On Mon, Nov 23, 2015 at 11:20:18AM +0100, Michael Wang wrote:
>> Who want to do that would take responsibility to make an else branch at
>> that time, but reserve the branch at this moment sounds unnecessary, and
>> not that pretty frankly speaking.
> 
> Actually, I was looking for the better idea which doesn't uglify the
> code. And here it is:
> 
> https://lkml.kernel.org/r/5585663.OcpAQiytKY@wuerfel

Looks even better :-)

Regards,
Michael Wang

> 
> :-)
> 
