From: Willy Tarreau <willy@w.ods.org>
Subject: Re: RAM and conntrack performance: first draft of the document is online
Date: Fri, 28 Nov 2003 12:00:50 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031128110050.GA1004@alpha.home.local>
References: <20031126034231.GA1044@eychenne.org> <Pine.LNX.4.44.0311260512440.6942-100000@filer.marasystems.com> <20031127045620.GA2740@eychenne.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Henrik Nordstrom <hno@marasystems.com>,
   "Laurence J. Lane" <ljlane@debian.org>,
   Harald Welte <laforge@netfilter.org>,
   Netfilter Development <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Herve Eychenne <rv@wallfire.org>
Content-Disposition: inline
In-Reply-To: <20031127045620.GA2740@eychenne.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, Nov 27, 2003 at 05:56:20AM +0100, Herve Eychenne wrote:
 
> Context: I have a Debian testing (sarge) with kernel-image-2.4.22-1-686
> package and 512MB of RAM.  I should then logically get ip_conntrack
> module initialized with 4096 buckets (size of the netfilter conntrack hash
> table, that should be computed automatically by netfilter code according
> to the amount of RAM), but I can read 4091 in syslog message.
> 4091 is better (prime number), but I cannot understand why I get this value
> instead of 4096, as nothing particular is done for the moment in
> netfilter code to ensure that the computed value will be a prime number.

Perhaps you have a small portion of this RAM dedicated to a video RAM so
that the amount of system ram is slightly lower than 512 MB (eg: 510 MB).
Then, dividing this would give you something which is not a power of 2.

Cheers,
Willy
