From: Patrick McHardy <kaber@trash.net>
Subject: Re: ctnetlink questions
Date: Tue, 21 Oct 2003 18:47:06 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F95630A.3090507@trash.net>
References: <Pine.LNX.4.44.0310200244580.17141-100000@filer.marasystems.com> <3F934FFD.7090700@trash.net> <20031020071545.GA21521@sunbeam.de.gnumonks.org> <3F9426C1.6070908@trash.net> <20031020183954.GC20288@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Henrik Nordstrom <hno@marasystems.com>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20031020183954.GC20288@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte wrote:

>Mh, well let's go for the 64bit, as there seems to be no other choice.
>But we should start working on the variable-sized conntracks within
>short time afterwards.
>

Ok there's another problem, for fast lookups by id (we don't want to
search the entire hash) we need to encode the hash chain of a tuple 
in the id. We basically have two choices now for the remaining bits:

a) keep using a global counter which reduces namespace to
   2^(64-lg(hashsize))

b) use a per-bucket counter which keeps 64 bit namespace and eliminates
   potential contention on the counter but requires as much memory as the
   hash buckets themselves.

The problem is guessing how big the hash might get. With a hash of 2^20
buckets and 1 million connections/s the ids wrap after 0.5 years with
possibility a. Even if the connection rate may be unrealistic high I
assume a hash size of 2^20 and bigger is realistic now or might be soon,
so the chance of seeing reused ids is real. Possibility b is of course
not acceptable due to memory usage.

My proposed solution is to reserve 16bit for the chain id and to
compensate for the remaining used bits by keeping
2^max(number_of_bits-16, 0) counters. This always gives us 48bit for
the id (if hash distribution is good), with the numbers above that is 
~9 years without a wraparound while keeping 16 counters. For a hash
size <= 2^16 we still only have one counter, but if we really
experience contention we now can easily increase it.

Does that sound ok ? Feel free to shut me up by giving some more
realistic numbers ;)

Best regards,
Patrick
