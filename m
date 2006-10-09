From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Add TCPCONG target to patch-o-matic
Date: Mon, 09 Oct 2006 17:12:10 +0200
Message-ID: <452A66CA.70603@trash.net>
References: <45235EDC.4080709@aarnet.edu.au> <4524118B.4020903@netfilter.org>
	<4524BBB2.2000109@aarnet.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Glen Turner <glen.turner@aarnet.edu.au>
In-Reply-To: <4524BBB2.2000109@aarnet.edu.au>
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

Glen Turner wrote:
> 
> Hi folks,
> 
> I have created a kernel module and iptables shared library
> to allow netfilter to set the TCP congestion control
> algorithm.
> 
> This has three major uses: selecting differing algorithms
> for wired and non-wired interfaces; selecting differing
> algorithms for close and far hosts; and selecting differing
> algorithms for comparison testing.
> 
> Thanks to the hint from Pablo Neira Ayuso I have put this
> into the patch-o-matic format.  This has been tested against
> iptables-1.3.6 and linux-2.6.18.
> 
> A SVN diff against patch-o-matic follows, which I'm hoping
> Thunderbird doesn't mangle. Since I'm not familiar with SVN
> please let me know if this isn't the desired patch format.
> 
> I would hope that this facility can become a standard part of
> the kernel and iptables.  Please let me know what I need to
> do to follow that path.

I don't think iptables is the right place to do this. It should
be controllable through routing IMO (which can already control
some aspects of congestion control).
