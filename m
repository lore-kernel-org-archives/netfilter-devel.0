From: Patrick Schaaf <bof@bof.de>
Subject: Re: timeout storms make the box unresponsive
Date: Sun, 27 Jul 2003 12:34:22 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030727103422.GA23621@oknodo.bof.de>
References: <20030725202113.GK10897@naboo> <Pine.LNX.4.33.0307270027460.7327-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.33.0307270027460.7327-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Jozsef,

> 03_locking.patch	per bucket locking patch with a couple of
> 			optimizations

some questions, during first pass reading over the patch;

1) regarding the 'ifdef CONFIG_IP_NF_NAT_NEEDED' gymnastics, reading
   hash_conntrack(), am I correct that this is the "non-NAT symmetry"
   optimization I proposed a long time ago, i.e. if both direction's
   tuples are mirrors of each other, hash/chain them only once?
   If yes, I feel that warrants breaking out into a separate patch.

2) assuming I am correct wrt the goal in 1), I object to the seperate
   "sorting" of IP and port in hash_conntrack(). Although it is unlikely,
   consider a situation where between two specific IP addresses,
   two independant connections run from (IPA,portA)<->(IPB,portB)
   and (IPA,portB)<->(IPB,portA). The code in your patch would
   throw both into the same hash chain, without need. Better:

   	if (IPa < IPb) {
		/* fine, do nothing */
	} else if (IPa > IPb) {
		swap IPs _and_ ports
	} else /* IPa == IPb */ if (portA > port B) {
		swap ports (IPs are identical, swap is noop)
	}

3) there is much activity related to managing expectations and
   helper stuff. Is that directly related to the conntrack locking
   changes themselves?  If not, I would also advocate breaking those
   into a separate patch. I never looked closely into the expectation
   stuff, so it is nothing but confusing (to me) to see it in this patch.

In any case, thanks for your work. Feel free to ignore my pleas, if you
and others are content with the aggregated changes.

best regards
  Patrick
