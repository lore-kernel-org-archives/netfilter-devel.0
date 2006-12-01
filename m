From: David Miller <davem@davemloft.net>
Subject: Re: libipt_multiport: getsockopt failed strangely: Invalid argument
Date: Fri, 01 Dec 2006 15:24:06 -0800 (PST)
Message-ID: <20061201.152406.32722891.davem@davemloft.net>
References: <87irgvomfx.fsf@scoobidee.mini-dweeb.org>
	<45705747.9090806@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: arnaud@andesi.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <45705747.9090806@trash.net>
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

From: Patrick McHardy <kaber@trash.net>
Date: Fri, 01 Dec 2006 17:24:39 +0100

> I *think* this should be fixed in 2.6.19. The 32 bit compat code
> didn't implement the SO_GET_REVISION_MATCH/TARGET options and
> returned an error.

Agreed.

Once I have the fix I'll push it around to the -stable
branches for you Patrick.
