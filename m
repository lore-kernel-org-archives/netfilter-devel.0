From: Patrick McHardy <kaber@trash.net>
Subject: Re: kernel oops with NAT in 2.6.16.13 kernel
Date: Tue, 10 Oct 2006 07:04:50 +0200
Message-ID: <452B29F2.70105@trash.net>
References: <00fb01c6e91d$08bf3570$4c01a8c0@elitecore26>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Nishit Shah <nishit@elitecore.com>
In-Reply-To: <00fb01c6e91d$08bf3570$4c01a8c0@elitecore26>
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

Nishit Shah wrote:
> Hi,
>         During my load testing on kernel 2.6.16.13 i got following kernel
> oops. It occures when I enable SNAT or MASQUERADE for all outgoing traffic,
> with ACCEPT load testing works fine for me.

How exactly did you perform this testing? Did you loaded and unloaded
modules, or just loaded them? How many entries does the connection
tracking table have at the time?
