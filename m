From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH] Re: hashsize available through /proc was RAM and conntrack
 performance: first draft of the document is online
Date: Thu, 27 Nov 2003 11:13:34 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311271113020.21649-100000@filer.marasystems.com>
References: <Pine.LNX.4.44.0311271102000.21649-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Herve Eychenne <rv@wallfire.org>
In-Reply-To: <Pine.LNX.4.44.0311271102000.21649-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 27 Nov 2003, Henrik Nordstrom wrote:

> You also need to make the sysctl read-only.. you can not change the 
> ip_conntrack hash size while conntrack is running. If you do there will be 
> serious hazard.

Looking again I see that you did take care of this. Sorry.

Regards
Henrik
