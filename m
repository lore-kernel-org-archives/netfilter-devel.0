From: "Richard" <richard@o-matrix.org>
Subject: RE: target for modifying conntrack timeout value
Date: Sun, 5 Dec 2004 21:43:33 -1000
Message-ID: <EINSTEINXKCnzNwRC6H000068e2@einstein.systemmetrics.com>
References: <20041201085448.GE4605@oknodo.bof.de>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "'Patrick Schaaf'" <bof@bof.de>
In-Reply-To: <20041201085448.GE4605@oknodo.bof.de>
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

> That should indeed work by calling ip_ct_refresh (ip_ct_refresh_acct
> in 2.6, it seems) in e.g. filter, matching --dport 5060. Just make
> sure you do it in front of any '-m state --state ESTABLISHED -j ACCEPT'
> rules.
> 
> Go ahead, write such a target.
> 

I finished the code and testing. It is based on the stable versions of
iptables and pom. I'd like to have it included in cvs. Should I post the
patch based on stable or cvs?

Btw, the cvs server seems down now. I followed the instruction in
http://www.netfilter.org/downloads.html#cvs.

Thanks,
Richard
