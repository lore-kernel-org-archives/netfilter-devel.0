From: Svein Olav Bjerkeset <svein.olav@bjerkeset.com>
Subject: Patch for geoip to make it work with Linux kernel 2.6.22.x
Date: Tue, 10 Jul 2007 17:44:13 +0200
Message-ID: <006801c7c309$2b8532a0$010210ac@BJERKESET.COM>
References: <twig.1177771162.67234@bugmachine.ca>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=iso-8859-1;
	reply-type=original
Content-Transfer-Encoding: 7BIT
Cc: netfilter-devel@lists.netfilter.org
To: jix@bugmachine.ca
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

Hi,

After upgrading to kernel 2.6.22, I found that the geoip patchlet did not 
compile.
I have made a patch that works on my system with kernel 2.6.22.

The patch is against geoip match as of Dec 6th 2006 from 
http://people.netfilter.org/peejix/patchlets/
I made a patch for kernel 2.6.21 as well, but it has not been applied to the 
official geoip patchlet, and is therefor included in this patch.

You can download the patch by using the following URL:
http://bjerkeset.com/patches/geoip-match-2.6.22.patch.gz

Regards
Svein Olav Bjerkeset, 
