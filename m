From: Vijay Gullapalli <vjgullapalli@yahoo.com>
Subject: Can IP MF and DF flags be set simulataneously
Date: Fri, 20 Sep 2002 16:55:13 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20020920235513.30242.qmail@web11901.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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

I came across this list when searching for TCP SYN
Proxy links on google. And I have a very basic
question about IP fragment flags DF (don't fragment)
and MF (more fragment) usage. If this is not the right
forum, please excuse me.

While monitoring NFS/UDP traffic between two Linux
machines, I noticed that when Path MTU is turned on,
the IP header has both the DF and MF bits set at the
time. Is it legal to have have both flags set at the
same time? Isn't it enough to have just the DF bit set
to do Path MTU discovery?

Having both on at the same time goes against these
flags usage described in Internet Protocol RFC 791.
Are there any other RFCs which supercede RFC 791 and
describe how/why these flags should be allowed to be
set at the same time.

Thank you,
Vijay Gullapalli

__________________________________________________
Do you Yahoo!?
New DSL Internet Access from SBC & Yahoo!
http://sbc.yahoo.com
