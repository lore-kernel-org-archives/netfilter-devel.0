From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: how to reinject the packet to the net
Date: Tue, 25 Nov 2003 10:58:54 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311251054340.29093-100000@filer.marasystems.com>
References: <E1AOS1t-0003iC-Kg@vishnu.netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: "netfilter-devel@lists.netfilter.org" <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Fangweiwei <fangweiwei@tom.com>
In-Reply-To: <E1AOS1t-0003iC-Kg@vishnu.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 25 Nov 2003, Fangweiwei wrote:

> I want to use the libipq to capture the packets and then reinject it to
> the net.but I cann't find the function to do it? can you help me?

When you are done with the packet you call ipq_set_verdict(). Details are
found in the documentation. libipq is very well documented with man pages
for every function used and a good overview describing
how it all fits together when writing a libipq application, including a 
silly sample application.

Regards
Henrik
