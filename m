From: "Jing Min Zhao" <zhaojingmin@hotmail.com>
Subject: New H.323 conntrack & NAT helper module
Date: Wed, 22 Feb 2006 00:56:45 -0500
Message-ID: <BAY109-DAV3F52AAA9FA589FA356BFAB3FD0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset="iso-8859-1";
	reply-type=original
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

Hi, all,

I've written a new H.323 conntrack & NAT helper module for Netfilter.

I have five years experience in H.323 development and many years in Linux
development, so I know many people out there need Linux firewall to support
H.323 as IP phones are becoming more and more popular. I also know Jozsef
Kadlecsik and Max Kellermann have written such Netfilter modules, but they
don't support RAS, Fast-Start and H.245 tunnelling. However, these features
are essential for most modern H.323 devices. Many carriers even don't
support slow-start at all.

This is a almost full featured H.323 module. Since it is based on H.225
version 4, H.235 version 2 and H.245 version 7, it should support most of
the H.323 products in the market. I've spent a lot of time on this module
and my friends helped me test it a lot too. Now I believe it is ready to go
into kernel tree. I'm wondering if anybody can tell me what I should do to
adding it to Netfilter.

Anybody interested in this can download the patch for kernel 2.6.15 in
http://sourceforge.net/project/showfiles.php?group_id=158936. The document
is at http://nath323.sourceforge.net.

Thanks a lot!

Jing Min Zhao
