From: "Damiano Bolzoni" <damiano.bolzoni@tin.it>
Subject: Problem with sk_buff
Date: Fri, 7 Jun 2002 21:05:19 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <000501c20e56$44f88830$c9907450@CHICCA>
Reply-To: "Damiano Bolzoni" <damiano.bolzoni@tin.it>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: <netfilter-devel@lists.samba.org>
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi people,
I wrote a kernel module that uses netfilter. I'm interested on incoming IP
packets that carry a TCP segment with SYN flag active. What I want to do is
to know which socket has been created in order to handle that connection and
I want to close it. sk_buff holds two pointer: struct sock* and struct
socket* but they point to NULL.
At this time I can test if the TCP segment has the SYN flag set but I can't
close the socket...
Anyone can help me?

Thanx a lot

Damiano
damiano.bolzoni@tin.it
