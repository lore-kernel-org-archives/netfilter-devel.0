From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: netfilter time patch (feature request)/ optimization against
 big rulesets.
Date: Wed, 10 Mar 2004 15:42:56 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403101540160.3805-100000@filer.marasystems.com>
References: <200403101241.48559.kaups@linux.ee>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: kaups <kaups@linux.ee>
In-Reply-To: <200403101241.48559.kaups@linux.ee>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Wed, 10 Mar 2004, kaups wrote:

> For example if the connection arrives/begins at Mon 17:59, that means the 
> entry in ip_conntrack will expire automatically at 18:00.

This would not be possible as the ip_conntrack has a lot of information 
about the session you want to keep. You would need a more fine granual 
optimization match than "-m state --state ESTABLISHED" for skipping the 
ruleset.

As you indicated using CONNMARK is one alternative, by encoding the 
different condition boundaries (or an approximation thereof) into the 
connection. Other similar approaches would also work fine.

Regards
Henrik
