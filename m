From: zhi wang <pangy2004@yahoo.com>
Subject: Re: Table-based branching
Date: Mon, 5 Apr 2004 17:01:01 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040406000101.89616.qmail@web41702.mail.yahoo.com>
References: <200404051508.15935.pg@futureware.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Develop <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: pg@futureware.at
In-Reply-To: <200404051508.15935.pg@futureware.at>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> My idea now is to have different rule tables for allowed and disallowed IP 
> addresses, and special kernel module that branches into either rule table.
> That module contains a large Bit-Array in kernel memory to store for every IP
> 
I think you can make the "module" a match. This match contains a bit map for
every allowed IP. Then add two rules, one says, "if this match succeeds, jump
to allowed IP rule table". The other rule says, "jump to disallowed IP rule
table". 

__________________________________
Do you Yahoo!?
Yahoo! Small Business $15K Web Design Giveaway 
http://promotions.yahoo.com/design_giveaway/
