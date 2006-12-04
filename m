From: Svein Olav Bjerkeset <netfilter@bjerkeset.com>
Subject: GeoIP match and kernel 2.6.19
Date: Mon, 04 Dec 2006 17:24:16 +0100
Message-ID: <003d01c717c0$a4d60e80$010210ac@BJERKESET.COM>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=iso-8859-1;
	reply-type=original
Content-Transfer-Encoding: 7BIT
Cc: jix@bugmachine.ca
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

After upgrading to kernel 2.6.19, I found that GeoIP match was once again 
broken. Since it seems the GeoIP match patchlet is not activly maintained 
anymore, I had a look at the source and compiled a patch that made it work 
on my system. The patch is against the latest official release (May 6th 
2006) at http://people.netfilter.org/peejix/patchlets/geoip.tar.gz and can 
be found here:

    http://bjerkeset.com/patches/geoip-match-2.6.19.patch.gz

An older patch for kernels 2.6.17.x and 2.6.18.x can be found here:

    http://bjerkeset.com/patches/geoip-match-2.6.17.patch.gz

The patches work for me on a Fedora Core 6 x86_64 with a custom built 
kernel, but I will make no promise that it works on your system - use at 
your own risk.

Best regards,
Svein Olav Bjerkeset
