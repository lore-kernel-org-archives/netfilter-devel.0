From: vdb128 <vdb128@stargate.kotnet.org>
Subject: [RFE] DNAT extension source routing
Date: Thu, 17 Apr 2003 17:00:49 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200304171500.h3HF0nIl020352@stargate.kotnet.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

-> [RFE] DNAT extension source routing
Dear all,

I was wondering if it is possible to combine DNAT and source routing (ip rule).
In practice, a statement like 

 iptables -t nat -A OUTPUT -o $KETH -s $KIPADDR -d $KULBLOCK -p tcp --dport 25 \
   -j DNAT --to-destination $KULFWD --use-source $KIPADDR

would be very handy.  For now, I REDIRECT to a tproxy(8) listen port and use
the bind($KIPADDR) connect($KULFWD) sequence for the outgoing connection.

-------

The logic for this setup is as follows.  The host $KULFWD is reachable via
two interfaces, but 

  $KULFWD via $KGATEWAY dev $KETH   forwards anything  (kotnet)
  $KULFWD via $UGATEWAY dev $UETH   only forward selected domains (upc)

So if I DNAT to it, it must be via $KETH.  This is done via source routing
ip rule ls:

0:      from all lookup local 
11000:  from 10.67.56.0/22 lookup kotnet 
11005:  from 195.162.202.40/29 lookup upc 
32766:  from all lookup main 
32767:  from all lookup default 
