From: pfy <david@ife.ee.ethz.ch>
Subject: timeouts in ip_conntrack_proto_tcp
Date: Sat, 14 Sep 2002 21:21:32 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020914192132.GA4850@firestorm.zhadum.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

hi
I'have noticed some strange entrys staying in conntrack
even when the are closed. The problem is that they don't get
removed from the conntrack list if there is no correct tcp reset
of the connection. That can happen if one participant of the
connection gets disconnected. My question is why is the timeout
for established connections 5 days ? And isn't there the
possibility to use that to flood the connection tracking system ?
I mean if you connect to a host correct an then drop everything,
the conntrack entry will last 5 days ....

sorry for my poor english and sorry if i'm writing bullshit ....
i was just wondering .....

pfy
-- 
-----------------------------------------------
+++ath0  --- Don't quote me --- +++ath0
Bofh excuse 335/424
The cause of the problem is:
the xy axis in the trackball is coordinated with the summer soltice
-----------------------------------------------
