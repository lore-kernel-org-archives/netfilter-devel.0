From: Patrick McHardy <kaber@trash.net>
Subject: Re: Kernel Oops in 2.4.33.3 GRE Conntrack Code
Date: Thu, 14 Dec 2006 07:27:13 +0100
Message-ID: <4580EEC1.9050309@trash.net>
References: <457FE5AC.3080902@variosecure.net> <45808D42.70507@trash.net>
	<4580E5C3.80409@variosecure.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Tim Burress <tim@variosecure.net>
In-Reply-To: <4580E5C3.80409@variosecure.net>
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

Tim Burress wrote:
> Hello,
> 
> Patrick McHardy wrote:
> 
>>The PPtP-helper for 2.4 is missing lots of bugfixes, I wouldn't
>>recommend using it. But anyway, which version are you using and
>>where did you get it from?
> 
> 
> It turns out we're using a version of pptp-conntrack-nat from POM
> 20050704. The versions numbers seem to be specific to the individual files:
> 
> 	ip_conntrack_pptp.		v1.9
> 	ip_conntrack_proto_gre.c	v1.2
> 	ip_nat_pptp.c			v1.5
> 	ip_nat_proto_gre.c		v1.2
> 
> Undoubtedly a little behind the times, but unfortunately we are stuck
> using 2.4 right now.

I can't find that version anymore, if you send me the files I can
have a quick look if its something obvious ..
