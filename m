From: Patrick McHardy <kaber@trash.net>
Subject: Re: Kernel Oops in 2.4.33.3 GRE Conntrack Code
Date: Thu, 14 Dec 2006 00:31:14 +0100
Message-ID: <45808D42.70507@trash.net>
References: <457FE5AC.3080902@variosecure.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Tim Burress <tim@variosecure.net>
In-Reply-To: <457FE5AC.3080902@variosecure.net>
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
> Just thought I would report this in case others have seen similar
> behavior or have any helpful ideas. The oops occurs very rarely on a
> uniprocessor machine configured as a router. Lots of PPTP traffic is
> flowing through, which apparently engages the GRE protocol code in
> conntrack.

The PPtP-helper for 2.4 is missing lots of bugfixes, I wouldn't
recommend using it. But anyway, which version are you using and
where did you get it from?
