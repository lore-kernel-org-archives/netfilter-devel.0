From: Borislav Petkov <bp@alien8.de>
Subject: Re: nfnetlink warnings
Date: Mon, 23 Nov 2015 11:32:12 +0100
Message-ID: <20151123103212.GD5134@pd.tnic>
References: <20151123093607.GA5134@pd.tnic>
 <5652E12E.3070500@profitbricks.com>
 <20151123095455.GB5134@pd.tnic>
 <5652E862.7000605@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	netfilter-devel@vger.kernel.org,
	lkml <linux-kernel@vger.kernel.org>
To: Michael Wang <yun.wang@profitbricks.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5652E862.7000605@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, Nov 23, 2015 at 11:20:18AM +0100, Michael Wang wrote:
> Who want to do that would take responsibility to make an else branch at
> that time, but reserve the branch at this moment sounds unnecessary, and
> not that pretty frankly speaking.

Actually, I was looking for the better idea which doesn't uglify the
code. And here it is:

https://lkml.kernel.org/r/5585663.OcpAQiytKY@wuerfel

:-)

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
