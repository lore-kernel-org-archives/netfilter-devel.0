From: "Andrew Hall" <temp02@bluereef.com.au>
Subject: state of play for TCP-window-tracking patch
Date: Fri, 14 Nov 2003 18:29:31 +1100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <013901c3aa81$0b2d5810$2601010a@bluereef.local>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Can someone please inform me of the current status of the
tcp-window-tracking patch, particularly in reference to it's compatibility
or eligibility for inclusion into the 2.6 stream? I have tried to do a
direct port from the last 2.4 version but quite a bit has seemed to have
changed in the skbuff function definitions for 2.6. I'd be interested in
helping to port it if this was the intention as the stock 2.6.0-test 9
implementation of the TCP state stuff seems to be the old 2.4 stuff. BTW
does anyone have any documentation as to what the fundamental changes have
been to the net components of 2.6 over 2.4?

Thanks,

Andrew Hall.
