From: "Ury N. Stankevich" <urykhy@gmail.com>
Subject: iplimit issues
Date: Sat, 20 Nov 2004 16:28:13 +0300
Message-ID: <20041120162813.322af73a@elf>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

hi list

i have question about iplimit module. as i understand it storing all sessions.. but conntrack also do that.

i think we can use conntrack capabilities to store sessions and extent ipt_state.c to take in account number of sessions.
but i see one problem:
current hash_conntrack implementation use src.u.all field..
so to count all connection from ip addressess range we need walk over all ip_conntrack_hash .. this can be quite long i think..

have anyone experiments with this approach ?
maybe we can simply change hash_conntrack to use only src_ip:dst_ip:protocol as hash key ?

-- 
