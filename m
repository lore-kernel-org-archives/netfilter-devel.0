From: Vijaya Chandra Vupputuri <vijay@tachyontech.net>
Subject: Query abt updation of byte/pkt counters with multiple processors
Date: Sat, 21 Feb 2004 18:30:49 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1077368009.20114.11.camel@vijay>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi all,

A cursory glance at the ip_tables source shows that a separate copy of
the set of rules is made for every cpu.
Does this include the byte and packet counters as well?
If yes, how is the updation of the counters done upon receival of pkts,
so that we have the same value in all the sets?

Regards,
Vijaya Chandra Vupputuri,
Tachyon Technologies.
