From: don-netf@isis.cs3-inc.com (Don Cohen)
Subject: Re: conntrack hash function comparison
Date: Fri, 31 Jan 2003 16:41:28 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <15931.6072.971476.262073@isis.cs3-inc.com>
References: <15916.59019.853598.788888@isis.cs3-inc.com>
	<Pine.LNX.4.33.0301211136020.19820-100000@blackhole.kfki.hu>
	<15917.31840.767508.76359@isis.cs3-inc.com>
	<20030131114145.GS9073@naboo.cybercafe42>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
   netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <20030131114145.GS9073@naboo.cybercafe42>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald Welte writes:
 > not that I totally disagree with rehashing being a good idea... but in
 > the case you add this 'small piece of code', you also introduce a new
 > vulnerability: If somebody can provoke the firewall to rehash all the
 > time ;(
The counter argument is that if they can do that then they have a way
of causing lots of connections to go into the same bucket, and allowing
that to happen is (at least in the extreme case) much worse than
rehashing.  Obviously it's also bad to rehash too eagerly.
I think the only question is where to put the threshold.

It's reasonable to make that threshold read/writable via /proc.
