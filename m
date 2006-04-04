From: Stephen Jones <hivemynd@hivemynd.net>
Subject: Re: Patch-o-matic cleanup
Date: Tue, 04 Apr 2006 01:26:16 -0500
Message-ID: <44321188.30902@hivemynd.net>
References: <443165AA.4030509@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <443165AA.4030509@trash.net>
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

Patrick McHardy wrote:
> Following (quite late) the decision taken at the netfilter workshop to
> clean up the pomng repository by removing old patches and moving some
> patches out of the netfilter repository, I've started by removing the
> obsolete ipsec* patches and the policy match. Both have been merged
> and were pretty outdated.
> 
> If noone can name good reasons against it, I will also remove the
> following patches in a few days:
> 

< snip >

> - pptp-conntrack-nat: in mainline now, patches are missing critical
>   fixes
Hi Patrick,

Is pptp-conntrack-nat functionality going to be included in the 2.4.x 
mainline also?  Otherwise, the patches still appear to be necessary for 
2.4.x kernels.  Thanks for all of your hard work!

SJ

> - unclean: bad idea
> 
> 
> 
