From: "David S. Miller" <davem@redhat.com>
Subject: [Fwd: Question with printk warnings in ip_conntrack with 2.4.20.]
Date: 29 Nov 2002 17:12:43 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1038618763.22065.1.camel@rth.ninka.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-6ZSvKfI+EAmr8tnzssBx"
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


--=-6ZSvKfI+EAmr8tnzssBx
Content-Type: text/plain
Content-Transfer-Encoding: 7bit


Just forwarding a bug report...


--=-6ZSvKfI+EAmr8tnzssBx
Content-Disposition: inline
Content-Description: Forwarded message - Question with printk warnings in
	ip_conntrack with 2.4.20.
Content-Type: message/rfc822

Return-Path: <linux-kernel-owner+davem=40rth.ninka.net@vger.kernel.org>
Received: from vger.kernel.org (vger.kernel.org [209.116.70.75]) by
	rth.ninka.net (8.12.5/8.12.5) with ESMTP id gATDvR1O020966 for
	<davem@rth.ninka.net>; Fri, 29 Nov 2002 05:57:27 -0800
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand id
	<S267038AbSK2NYW>; Fri, 29 Nov 2002 08:24:22 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id
	<S267039AbSK2NYW>; Fri, 29 Nov 2002 08:24:22 -0500
Received: from lucidpixels.com ([66.45.37.187]:386 "HELO lucidpixels.com")
	by vger.kernel.org with SMTP id <S267038AbSK2NYV>; Fri, 29 Nov 2002
	08:24:21 -0500
Received: (qmail 337 invoked from network); 29 Nov 2002 08:31:43 -0000
Received: from unknown (HELO lucidpixels.com) (192.168.168.12) by 0 with
	SMTP; 29 Nov 2002 08:31:43 -0000
Message-ID: <3DE76C3F.5010601@lucidpixels.com>
Date: Fri, 29 Nov 2002 08:31:43 -0500
From: jpiszcz <jpiszcz@lucidpixels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.0.1)
	Gecko/20020823 Netscape/7.0
X-Accept-Language: en-us, en
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: Question with printk warnings in ip_conntrack with 2.4.20.
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-kernel@vger.kernel.org

Nov 29 03:29:26 lucidpixels kernel: ip_conntrack: max number of expected 
connections 1 of ftp reached for 192.168.xxx.xxx->129.128.5.191, reusing
Nov 29 03:29:30 lucidpixels kernel: ip_conntrack: max number of expected 
connections 1 of ftp reached for 192.168.xxx.xxx->129.132.7.170, reusing
Nov 29 03:29:36 lucidpixels kernel: ip_conntrack: max number of expected 
connections 1 of ftp reached for 192.168.xxx.xxx->195.113.31.123, reusing

These fill up my logs (kern.info) which I use for logging iptables 
blocked packets.
Is there anyway to turn this feature off dynamically or should one just 
comment out line #970 in 
/usr/src/linux/net/ipv4/netfilter/ip_conntrack_core.c ?

Please cc me as I am not subscribed to the list, thanks.



-
To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Please read the FAQ at  http://www.tux.org/lkml/

--=-6ZSvKfI+EAmr8tnzssBx--
