From: "John P. Looney" <valen@tuatha.org>
Subject: taking related connections to the limit
Date: Thu, 4 Mar 2004 12:04:02 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040304120402.GH14383@magicbluesmoke.net>
Reply-To: valen@tuatha.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

 Hi, I was wondering if netfilter can do the following:

 If a packet has dest ip X, dport 110, do a DNAT --to IP Y, record the SRC IP
 If a subsequent packet comes into dest IP X, from that SRC IP, --dport 25 from the same IP, DNAT --to IP Y also.

 This is to do some work with POP-before-smtp, if you wondered why such a
demented thing would be needed. 

John
