From: zhi wang <pangy2004@yahoo.com>
Subject: Re: current pom-ng's nfnetlink doesn't apply cleanly to kernel 2.4.22
Date: Mon, 19 Apr 2004 07:22:18 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040419142219.6631.qmail@web41713.mail.yahoo.com>
References: <Pine.LNX.4.44.0404181817380.6618-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Develop <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0404181817380.6618-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> Ok. So it is the ctstat patch you have problems with, not nfnetlink..
It is exactly this ctstat odd. The info file of nfnetlink says:
    Repository: extra
    Depends: !netfilter-docbook
    Depends: !ctstat
which means, if I was right, nfnetlink conflicts with ctstat, but it seems that
./runme apply the ctstat as a dependence :(

---
Regards
wang,zhi



	
		
__________________________________
Do you Yahoo!?
Yahoo! Photos: High-quality 4x6 digital prints for 25¢
http://photos.yahoo.com/ph/print_splash
