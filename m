From: Philip Craig <philipc@snapgear.com>
Subject: ASN.1 parsing for H.323
Date: Mon, 16 Jun 2003 19:02:42 +1000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EED87B2.90809@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
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

Hi,

I've seen a few messages in the list archives about the current
H.323 being a brute force approach, and that a better implementation
would be to do ASN.1 parsing.

Is ASN.1 parsing in the kernel still the desired approach?  I saw
some messages from Sampsa Ranta in 2001 where he concluded that it
was not suited for in the kernel and that it would be better in
user space.  I think his primary reason was the need to parse the
stream, rather than individual packets.

Has anyone else done any work on this yet?

If this is a worthwhile endeavour I may start some work on it.

-- 
Philip Craig - philipc@snapgear.com - http://www.SnapGear.com
SnapGear - Custom Embedded Solutions and Security Appliances
