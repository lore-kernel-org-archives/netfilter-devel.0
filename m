From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: LIST_DELETE bug tracked
Date: Wed, 31 Mar 2004 17:39:33 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1080747573.1650.136.camel@nienna.balabit>
References: <Pine.LNX.4.44.0403311709220.21410-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: zhi wang <pangy2004@yahoo.com>,
	Netfilter Develop <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0403311709220.21410-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


  Hi,

On Wed, 2004-03-31 at 17:10, Henrik Nordstrom wrote:
> On Wed, 31 Mar 2004, zhi wang wrote:
> 
> > In a post by KOVACS Krisztian,
> > http://lists.netfilter.org/pipermail/netfilter-devel/2004-March/014584.html,
> > he declared that the LIST_DELETE bug can be reliably
> > reproduced, which is first reported by Jonathan
> > Cooper. The bug is really  responsive :). I reproduced
> > it by executing the following commands at my host
> > 10.0.0.2:
> > 1. iptables -t nat -A PREROUTING -s 10.0.0.0/24 -p tcp
> > --dport 80 -j REDIRECT --to-port 8080
> > 2. nc -l -p 8080
> > 3. nc -n 10.0.0.2 80
> 
> Yes, this will trigger the bug.
> 
> Patch is found in the archives. Alternatively you can recompile your
> kernel with local-nat support enabled which will also cure the problem.

  Furthermore, David S. Miller has already pushed that patch to 2.4 and
2.6 as well. BTW, the potential problems regarding in_range() and
find_appropriate_src() are still open and undiscussed.

-- 
 Regards,
   Krisztian KOVACS
