From: "David S. Miller" <davem@davemloft.net>
Subject: Re: [NETFILTER 00/09]: Netfilter update
Date: Mon, 20 Mar 2006 23:42:55 -0800 (PST)
Message-ID: <20060320.234255.32496441.davem@davemloft.net>
References: <20060321015549.11977.45799.sendpatchset@localhost.localdomain>
	<441F6280.3020201@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <441F6280.3020201@trash.net>
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
Date: Tue, 21 Mar 2006 03:18:40 +0100

> Dave, I'm sorry for the annoyance, but please drop the entire patchset
> except for the H.323 helper. Something is messing up ip6tables on
> one of my systems and the only thing I'm sure of is that its not the
> H.323 helper :)
> 
> I'll resubmit the remaining patches once I know whats going on.

Ok, but please kill trailing whitespace in patches, GIT even warns
about this now and you can check and fix it up before applying a patch
by using:

	git apply --check --whitespace=error-all

So, for example, on this H323 patch we get:

+ git apply --check --whitespace=error-all diff
Adds trailing whitespace.
diff:73:	 
Adds trailing whitespace.
diff:146: *  
Adds trailing whitespace.
diff:156: *	 
Adds trailing whitespace.
diff:171: * 	 
Adds trailing whitespace.
diff:5747: *	 
fatal: 5 lines add trailing whitespaces.

I fixed it up by hand this time, but I may stop doing so in
the future and push it back to you instead :-)

Thanks!
