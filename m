From: Patrick McHardy <kaber@trash.net>
Subject: Re: u32 patch
Date: Tue, 08 Aug 2006 11:28:41 +0200
Message-ID: <44D85949.3050804@trash.net>
References: <20060802212232.GA29168@packetconsulting.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Piotr Chytla <pch@packetconsulting.pl>
In-Reply-To: <20060802212232.GA29168@packetconsulting.pl>
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

Piotr Chytla wrote:
> Here are some small patch for u32 match, to work on 2.6.17 kernels . 
> Matchsize in ipt_match  struct was missing. 

Thanks, applied.
