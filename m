From: "Eble, Dan" <DanE@aiinet.com>
Subject: RE: problems with MAC filtering of fragmented packets
Date: Thu, 3 Oct 2002 08:06:51 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <638AA0336D7ED411928700D0B7B0D75B03053CB1@aimail.aiinet.com>
Mime-Version: 1.0
Content-Type: text/plain
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "'Robert K. Johnson'" <johnson60@llnl.gov>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Robert K Johnson wrote,

> I created a user chain that I jump to immediately from both the
> INPUT and FORWARD chains.  This user chain performs a RETURN jump
> for matches with known MAC's and DROPs all others.  I created

I am doing the same thing, except using only PREROUTING, i.e.

    iptables -t mangle -A PREROUTING -i eth0 -j acl-mac-eth0

> I can see that fragmented packets are not passing the MAC check
> when they should.

I have not tested fragmented packets in my system since reading the recent
reports.  If you have time to test using PREROUTING, would you mind letting
me know how it turns out?  Thanks.

-- 
Dan Eble <dane@aiinet.com>           _____  .
Applied Innovation Inc.             |  _  |/|
Dublin, OH  43017-3271              | |_| | |
614-923-1185 or 800-247-9482 x2051  |__/|_|_|
