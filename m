From: jamal <hadi@cyberus.ca>
Subject: Re: [RFC] ct_sync 0.15 (corrected)
Date: 23 Sep 2004 22:42:19 -0400
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <1095993739.1044.9.camel@jzny.localdomain>
References: <1092407190.2402.120.camel@nienna.balabit>
Reply-To: hadi@cyberus.ca
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Netfilter-failover list <netfilter-failover@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: KOVACS Krisztian <hidden@balabit.hu>
In-Reply-To: <1092407190.2402.120.camel@nienna.balabit>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi Krisztian,

I just glanced over your code (30 sec scan) and your state machine
doesnt allow for active/active (i.e two masters).
I havent actually run it - can you confirm this is impossible? 
if ct_sync was blind i.e it just did what it was told "become master" or
"become slave" regardless of who else is master, then it would be more
usable - leave policy to whatever tells it to switch.

cheers,
jamal
