From: Boris Hajduk <bhajduk@zboubi.com>
Subject: GeoIP tool and POM match extension
Date: Fri, 18 Jun 2004 17:27:11 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1087572431.40d309cfa5d7b@dilara.zboubi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
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



Hi,

I have developped a userland/netlink tool which accepts or drops the matching
packet according to it's country of origin, determined by GeoIP.

This tool is documented here :
http://www.zboubi.com/gpl/iptables-geoip.html

Do you think this tool is better as it is now, or is the idea good enough to
create a new PatchOMatic GeoIP match ?

--
Boris Hajduk
http://www.zboubi.com/
