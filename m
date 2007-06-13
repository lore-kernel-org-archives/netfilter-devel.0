From: Torsten Luettgert <t.luettgert@pressestimmen.de>
Subject: ipset: would it be hard to add /32 pseudo-nets to nethash?
Date: Wed, 13 Jun 2007 22:19:36 +0200
Message-ID: <1181765976.3720.14.camel@murdegern.cbxnet.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hello,

I'm using ipset in some script-generated setup of mine. It's really
cool. Now, I found that the "nethash" type really expects networks,
i.e. /31 up to /1 networks.
I'd love to have support for single addresses (/32 "networks") in there,
too.

Is this a bad idea?

If not so, would it be hard to extend ipset to facilitate this?
(Actually, I tried just changing the 31 in ipset_nethash.c's
  string_to_number(tmp, 1, 31, &cidr)
to 32, but that didn't work out). 

Regards,
Torsten
