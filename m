From: Svein Olav Bjerkeset <svein.olav@bjerkeset.com>
Subject: Patch for geoip to make it work with kernel 2.6.17
Date: Sat, 08 Jul 2006 13:30:38 +0200
Message-ID: <002901c6a281$f00e55b0$010210ac@BJERKESET.COM>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=iso-8859-1;
	reply-type=original
Content-Transfer-Encoding: 7BIT
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

Hi,

After upgrading my kernel to 2.6.17, I had some problems getting geoip to 
work.
I had a look at the geoip and kernel source, and came up with a patch that 
made
geoip work on my system.

The patch is against geoip patchlet as of May 6th 2006
(from http://people.netfilter.org/peejix/patchlets) and can be found here:

http://bjerkeset.com/patches/geoip-match-2.6.17.patch

In particular the patch has been tested with kernel 2.6.17.4

By the way, there seems to be a problem with mynodes.net where pom tries to 
find the geoip patchlet.

Best regards
Svein Olav Bjerkeset 
