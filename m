From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: sparc64 match module - bug id 94
Date: Fri, 7 May 2004 08:20:20 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0405070816560.9465-100000@filer.marasystems.com>
References: <Pine.LNX.4.33.0405061729170.1102-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: KOVACS Krisztian <hidden@balabit.hu>, dan radom <netfilter@radom.org>,
   netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.33.0405061729170.1102-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thu, 6 May 2004, Jozsef Kadlecsik wrote:

> Just a thought: in 'pool' there was a similar problem and it was solved in
> 'set' by keeping the kernel info structures in an array. Then instead of
> the pointer like above, the user part stored the index of the
> corresponding structure in the array.

Fully possible, but will break binary compatibility.

Better for now to simply have a suitable #ifdef _KERNEL_ to redefine 
*master in userspace on SPARC64 as "int64_t". The only question which has 
not been fully identified is how userspace can determine this is SPARC64 
with a 32-bit userspace, but actually it just needs to determine it is 
SPARC64..

Regards
Henrik
