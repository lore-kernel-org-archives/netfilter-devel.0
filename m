From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: prohibiting iptables to insert a rule twice
Date: Thu, 6 May 2004 13:21:28 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0405061320210.30218-100000@filer.marasystems.com>
References: <4099FB89.3000604@aiqa.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Ozgur AKAN <akan@aiqa.com>
In-Reply-To: <4099FB89.3000604@aiqa.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 6 May 2004, Ozgur AKAN wrote:

> I am working on a patch for iptables.c to prohibit inserting the same 
> rule twice. Inserting same rule twice does not cause any problems but 
> also is not meaningful.

This is only true for terminal rules.

non-terminal rules can be quite meaningful to have more than once in some 
situaions.

Regards
Henrik
