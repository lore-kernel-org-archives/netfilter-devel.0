From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [ANNOUNCE] call for testing of patch-o-matic-ng
Date: Sun, 29 Feb 2004 11:25:06 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402291121270.25361-100000@filer.marasystems.com>
References: <20040229101116.GA10012@pcw.home.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
   Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
   Netfilter Mailinglist <netfilter@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Willy TARREAU <willy@w.ods.org>
In-Reply-To: <20040229101116.GA10012@pcw.home.local>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 29 Feb 2004, Willy TARREAU wrote:

>   - first, I didn't find how to specify where my iptables sources is
>     installed, so I had to enter it by hand each time I restarted it.
>     I did not find any env variable in the perl code, and I must say
>     that my understanding of perl is, hmmm.. very limited.

There is a --path= option which can specify the path to both iptables and 
the kernl.

>   - ROUTE and TRACE told me :
>     "unable to find ladd slot in src /usr/src/linux-2.4.25-pomng/./net/ipv6/Makefile"
>     I think they wanted to add a line in the Makefile but didn't find
>     the right place to do so. BTW, is there a way to install a patch
>     only for ipv4 or for ipv6 like before ?

Please try with the large patch of .ladd files I posted on netfilter-devel 
yesterday.

>   - I observed usual conflicts :
>     present 'CONNMARK' conflicts with to-be-installed 'connbytes'
>     present 'raw' conflicts with to-be-installed 'conntrack-seqfile'
>     present 'CONNMARK' conflicts with to-be-installed 'conntrack_arefcount'

Yes.

>   - and finally, trying to apply conntrack_locking litterally killed my
>     box in out of memory within a few tens of seconds (I could not even
>     run ps) :
>       Out of Memory: Killed process 9841 (runme).
>       Out of Memory: Killed process 9970 (ps).
>       Out of Memory: Killed process 159 (bash).
>       Out of Memory: Killed process 158 (bash).
> 
>     Since conntrack_locking needs conntrack_arefcount which could not
>     be applied, I wonder if there's some problem resolving dependancies.

Not unlikely.

Applying "extra" blindly is not recommended. There is reasons to why a 
patch is in "extra", and many of these extensions conflict with each 
other.

If you want patches from extra you better name the patches you want 
explicily, after applying the base set.

Regards
Henrik
