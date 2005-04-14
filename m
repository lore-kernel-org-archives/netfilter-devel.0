From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: About matching (also was: Multiple Targets)
Date: Thu, 14 Apr 2005 03:16:48 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0504140315010.16405@filer.marasystems.com>
References: <20050413152307.0312.LARK@linux.net.cn> <425CEFE3.2010200@rtij.nl>
	<20050413182822.0317.LARK@linux.net.cn> <425CFFE0.1000803@rtij.nl>
	<20050413112518.GB22865@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org, Martijn Lievaart <m@rtij.nl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick Schaaf <bof@bof.de>
In-Reply-To: <20050413112518.GB22865@oknodo.bof.de>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, 13 Apr 2005, Patrick Schaaf wrote:

> BTW, anybody ever thought about giving -j RETURN an --up N option?

IIRC there was some talk about this when the --goto thing was discussed 
some many months (year?) ago, but I do not remember what the final 
conclusions was.

Personally I think it would be good, but I think there was some opposion 
(Harald?) from it being very confusing when the chain is called from more 
than one place..

Regards
Henrik
