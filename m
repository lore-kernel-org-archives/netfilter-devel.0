From: Chris Wilson <chris@netservers.co.uk>
Subject: Re: [RFC] CONNMARK getsockopt/setsockopt functionality
Date: Fri, 28 May 2004 11:43:43 +0100 (BST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.58.0405281141020.27895@chris.camcom.co.uk>
References: <1085125075.1782.36.camel@nienna.balabit>
 <Pine.LNX.4.58.0405241212230.27895@chris.camcom.co.uk>
 <1085398351.1848.30.camel@nienna.balabit>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: KOVACS Krisztian <hidden@balabit.hu>
In-Reply-To: <1085398351.1848.30.camel@nienna.balabit>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Krisztian,

>   Thanks for the fix. Your patch is obviously correct, somehow I
> succeeded in messing up the patch :)
> 
>   I hope it's otherwise correct.

I'm afraid I think I found another problem, although it may not be the 
fault of your patch. After applying it, I cannot load the ip_conntrack 
module anymore (and therefore not iptable_nat, which depends on it). 

ip_conntrack generates the following error on startup:

	Unable to register netfilter socket option

Perhaps someone else is using socket option 81? How would I find out?

Cheers, Chris.
-- 
_  __ __     _
 / __/ / ,__(_)_  | Chris Wilson -- UNIX Firewall Lead Developer |
/ (_  ,\/ _/ /_ \ | NetServers.co.uk http://www.netservers.co.uk |
\__/_/_/_//_/___/ | 21 Signet Court, Cambridge, UK. 01223 576516 |
