From: udo <udovdh@yahoo.com>
Subject: more about martians
Date: Tue, 20 Apr 2004 10:05:44 -0700 (PDT)
Sender: netfilter-admin@lists.netfilter.org
Message-ID: <20040420170544.87914.qmail@web40702.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-admin@lists.netfilter.org>
To: netfilter@lists.netfilter.org
Errors-To: netfilter-admin@lists.netfilter.org
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

As a follow up on my post about portforwarding to
127.0.0.1 and the 'martian destination 127.0.0.1'
message I can tell I found the probable cause in
/usr/src/linux/net/ipv4/route.c.
A patch here could filter out the martian messages if
a packet is related to sshd (in my case).

Does anyone know if such a patch/solution exist
already?
Maybe there's a better way?

Please post.

Kind regards,
Udo


	
		
__________________________________
Do you Yahoo!?
Yahoo! Photos: High-quality 4x6 digital prints for 25¢
http://photos.yahoo.com/ph/print_splash
