From: William Stearns <wstearns@pobox.com>
Subject: Re: Suggestion: Marker option in iptable, netfilter chains
Date: Mon, 10 Nov 2003 13:54:53 -0500 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311101350530.32650-100000@sparrow>
References: <200311090446.21825.kreuzritter2000@gmx.de>
Reply-To: William Stearns <wstearns@pobox.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: ML-netfilter-devel <netfilter-devel@lists.netfilter.org>,
   William Stearns <wstearns@pobox.com>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: kreuzritter2000@gmx.de
In-Reply-To: <200311090446.21825.kreuzritter2000@gmx.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Good day, Oliver,

On Sun, 9 Nov 2003 kreuzritter2000@gmx.de wrote:

> Hello,
> 
> I have a suggestion about a new feature.
>  ( i don't know if such thing allready exists so i assume it does not exist)
[snip]
> This firewall example is very easy to understand, but
> sometimes your firewall is very complex and the rules chain is very long with 
> branches to other chains etc..
> In such a situtaion it would be great to have a thing like a "marker"
> in the rule chain when using "iptables -L".
> This marker would help you to find the exact position in your firewall script,
> in other words the place where the marker was set.
> Such a feature would be very handy for debugging the firewall.
> 
> To show what i meant we assume we have a marker option
> in iptables which could be used in our firewall script.
> Let's say this option can be used with a -S option:
> -S = Set Marker
> 
> Now let's take a look at the same script but with a marker option:
> ------------------
> #!/bin/sh
> iptables -P INPUT DROP
> iptables -A INPUT -i eth0 -p tcp --dport 80 -j ACCEPT
> iptables -A INPUT -i eth0 -p tcp --dport 21 -j ACCEPT
> iptables -A INPUT -i eth0 -p tcp --dport 29 -j REJECT
> iptables -S Marker-1
> iptables -A INPUT -i eth0 -p tcp --dport 50 -j ACCEPT
> iptables -A INPUT -i eth0 -p tcp --dport 130 -j ACCEPT
> iptables -S Marker-2
> iptables -A INPUT -i eth0 -p tcp --dport 804 -j ACCEPT
> iptables -A INPUT -i eth0 -p tcp --dport 21456 -j DROP
> iptables -S Marker-3
> iptables -A INPUT -i eth0 -p tcp --dport 2955 -j ACCEPT
> -----------------

	How about:

iptables -i eth99 -s 127.99.99.99 -d 127.200.200.200 -j LOG --log-prefix "Marker-1 "

	You can reuse that rule as many time as you'd like, verbatim, just 
change the log string each time.

[snip]
> It should be clear that such a feature would be realy helpfull for debugging 
> the firewall script, especially when it is a very long firewall with a lot of 
> ramifications.
> 
> Now my question is, would such a feature in iptables/netfilter be possible?

	It already is.

> Please send me a copy of your answers to me because i am not on the 
> mailinglist.

	Please sign up for the mailing list.  ;-)
	Cheers,
	- Bill

---------------------------------------------------------------------------
	"Hackers do not feel that leisure time is automatically any more
meaningful than work time. The desirability of both depends on how they
are realized.  From the point of a view of a meaningful life, the entire
work/leisure duality must be abandoned.  As long as we are living our
work or our leisure, we are not even truly living.  Meaning cannot be
found in work or leisure but has to arise out of the nature of the
activity itself.  Out of passion.  Social value.  Creativity."
        -- Andrew Leonard <aleonard@salon.com>
        http://salon.com/tech/col/leon/2001/02/05/hacker_ethic/index2.html
--------------------------------------------------------------------------
William Stearns (wstearns@pobox.com).  Mason, Buildkernel, freedups, p0f,
rsync-backup, ssh-keyinstall, dns-check, more at:   http://www.stearns.org
Linux articles at:                         http://www.opensourcedigest.com
--------------------------------------------------------------------------
