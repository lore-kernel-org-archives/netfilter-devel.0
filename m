From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: link layer hooks
Date: Fri, 09 Jul 2004 10:14:10 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1089360850.2358.1.camel@nienna.balabit>
References: <003901c464fd$af8ec790$f73824a0@laptop80>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-2
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Huadong Liu <hliu@cs.utk.edu>
In-Reply-To: <003901c464fd$af8ec790$f73824a0@laptop80>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


  Hi,

2004-07-08, cs keltezéssel 17:10-kor Huadong Liu ezt írta:
> Hi All,
>  
> From the netfilter documentation I know that hooks are inserted
> in the Ipv4, IPv6 and DecNET stack. Is there any link layer hook
> supported by netfilter? I need to process the link layer frames
> before they go up the stack, e.g. ip_rcv(). Is netfilter_bridge
> for this purpose?

  Take a look at the layer2-hooks patchlet in POM-ng, I think that may
be what you're looking for.

-- 
 Regards,
   Krisztian KOVACS
