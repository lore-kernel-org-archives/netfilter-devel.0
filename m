From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Creating rules without the /sbin/iptables command?
Date: Fri, 19 Mar 2004 23:41:10 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0403192339160.13628-100000@filer.marasystems.com>
References: <405B7136.9040807@nk.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developers List <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Victor Julien <victor@nk.nl>
In-Reply-To: <405B7136.9040807@nk.nl>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 19 Mar 2004, Victor Julien wrote:

> So the best option would be to create an accounting chain (e.g ACCOUNT). 
> If i, for example, want to recreate the rules in the INPUT chain it 
> should work like this:
> 
> Create a file for iptables-restore input:
> 
> *filter
> :INPUT DROP
This line is redundant. You only need policy lines if you want to change 
the policy.

> # flush this chain
> -F INPUT
> # now recreate the rules
> -A INPUT -p tcp -s 192.168.0.1 --dport 80 -j ACCEPT
> ...more rules...
> COMMIT
> 
> Now i would have to call 'iptables-restore --noflush'. This will clear 
> the entire INPUT chain, but will leave all other (including my ACCOUNT 
> chain) chains untouched.

Correct.

But dont forget to insert a jump to the ACCOUNT chain where needed..

*filter
-F INPUT
-A INPUT -j ACCOUNT
-A INTPUT -p tcp .... -j ACCEPT
....
COMMIT

Regards
Henrik
