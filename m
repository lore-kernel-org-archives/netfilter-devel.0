From: "Michael Varga" <mike.varga@cavium.com>
Subject: ip_rcv() crashes kernel with netfilter hook
Date: Wed, 26 Jan 2005 15:37:46 -0800
Message-ID: <0cde01c50400$0f01e260$a610a8c0@niche>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>,
	<netfilter@lists.netfilter.org>
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

Hello:

I have set up a NF_IP_PRE_ROUTING hook to capture packets.

Specifically I am using netfilter for an IPSec implimentation I have=20
written.

When I recieve an increased amount of icmp echos, decapsulate
them from IPSec and pass them on by calling ip_rcv() the kernel crashes.

It only crashes when the icmp echos are addressed locally.

Has anyone ever experienced this? Suggestions on how to fix?

Mike
