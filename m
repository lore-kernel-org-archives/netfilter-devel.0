From: Jonas Berlin <jberlin@niksula.hut.fi>
Subject: Re: owner-socketlookup patch
Date: Tue, 15 Feb 2005 15:04:36 +0200
Message-ID: <4211F364.5040504@niksula.hut.fi>
References: <5b698f5a050214094614170435@mail.gmail.com>	<20050214222352.GA3829@sunbeam.de.gnumonks.org>
	<5b698f5a050215015175a4bfec@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: norman@rasmussen.org,  netfilter-devel@lists.netfilter.org
In-Reply-To: <5b698f5a050215015175a4bfec@mail.gmail.com>
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

Norman Rasmussen wrote:

>re: https://svn.netfilter.org/netfilter/trunk/patch-o-matic-ng/owner-socketlookup/linux-2.6.patch
>
>It looks some new changes to 2.6.10 ('New socket lookup architecture.'
>by David) have broken the owner-socketlookup patch (by Patrick).  Any
>chance someone feels like tweaking it to work?
>  
>
Sure, I'll get on it right away.

I don't know what version it started breaking from (2.6.10 or less), but 
the fix is easy.

-- 
- xkr47
