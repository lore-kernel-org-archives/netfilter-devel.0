From: Upma Gandhi <upma@networkprograms.com>
Subject: Packets dropped !!
Date: Tue, 11 Mar 2003 11:20:44 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E6D7934.9060004@networkprograms.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello All,
          I am using 2.4.18 with newnat  and bridge patch.
When I ping from this linux box to someother m/c in LAN ( this is just 
one case)
         For each ping packet, "ip_conntrack_count" increments to one as 
each ping is a NEW ENTRY for init_conntrack.
Though sometimes "ip_conntrack_count"  is getting decremented in 
function "destroy_conntrack" but still after sometimes 
"ip_conntrack_count"  reaches to "8120" on my system,  and after that 
"early_drop" is called which resulted in ping failure. Is this a bug ? 
Shall there be a statement in "death_by_timeout"  which should also 
decrement ip_conntrack_count ? I think there is something lacking in 
"death_by_timeout"  function . Waiting for help.


Thanks and Regards
Upma
