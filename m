From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: oops in replace_in_hashes
Date: 25 Jul 2003 20:22:44 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1059157364.21504.23.camel@henrik.marasystems.com>
References: <20030725085731.GA5776@balabit.hu>
	 <Pine.LNX.4.52.0307251104001.5333@tux.rsn.bth.se>
	 <20030725135020.GA6433@balabit.hu>  <20030725173555.GA7458@balabit.hu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Martin Josefsson <gandalf@wlug.westbo.se>,
   netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Balazs Scheidler <bazsi@balabit.hu>
In-Reply-To: <20030725173555.GA7458@balabit.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

fre 2003-07-25 klockan 19.35 skrev Balazs Scheidler:

> One little addition, which might prove to be important, is that the bogus
> next pointer which is tried to be dereferenced contains the IP address of the
> last SNAT mapping that was being made. The manips array of the ip_nat_info
> structure is only a couple of bytes away, hm... 

And addressed as an array IIRC...

this kind of overwrite pretty much rules out reuse-after-free, unless
caused by array reference going wrong due to zeroed index data.

A quick grep of the source for ip_nat_info manipulations does not give
any obvious lead to such corruption on reuse-after-free.. all accesses
seem to be "fine" to my eyes even if assuming a reuse-after-free
condition.

Assuming this is a reuse after free overwrite by bogus array index
thereby hitting an unexpected element in the structure you should be
able to find the source of this by identifying all array type positions
where the IP address may have been legally written into the
ip_conntrack. Check if the overwriten location is reachable via the
array. Then look for assignments of this member and you have a likely
victim.

Regards
Henrik
(who is back to netfilter hacking after a long period of other tasks)

-- 
Henrik Nordstrom <hno@marasystems.com>
MARA Systems AB
