From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: connlimit error?
Date: Sun, 10 Apr 2005 23:10:33 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0504102303070.16575@filer.marasystems.com>
References: <1112710072.30219.3.camel@sas>
	<Pine.LNX.4.61.0504051612120.19152@filer.marasystems.com>
	<20050410205544.GX9155@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20050410205544.GX9155@sunbeam.de.gnumonks.org>
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

On Sun, 10 Apr 2005, Harald Welte wrote:

>> If I am not mistaken that = should be a ==
>
> No, actually not.  two lines above "struct ip_conntrack *ct = NULL".
>
> The whole purpose of this segment is to check for 'found' and if there
> is one, resolve 'ct' based on found and do some further checks.  I've
> added the missing parenthesis in svn now.
>
> [yes, bad programming style, but I didn't want to change more than
> absolutely required between 2.6.10 and 2.6.11 versions]

Indeed bad style, not even counting the missing parantesis:

   The variable ct is overloaded both as a block local and a function 
argument. This is what fooled me into thinking the intention was to 
compare with the ct given as argument..

   In addition the block level ct is declared mid-block (not at the 
beginning of a block) which will cause compile errors with GCC 2.95.X and 
RedHat GCC 2.96-xxx and makes it even harder to see that it is 
overloaded when eyeballing the code.

Regards
Henrik
