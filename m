From: ChungLiang <david@cobra.ee.ntu.edu.tw>
Subject: L2TP protocol source port number changed
Date: Thu, 22 May 2003 13:04:39 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3ECC5A67.5000803@cobra.ee.ntu.edu.tw>
Mime-Version: 1.0
Content-Type: text/plain; charset=Big5
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

Hello,

	I have tried L2TP protocol under netfiler and it seems the second
connection's source port will be changed to 1024 from 1071.

	But I remember seeing some build having both connection having the
source port staying at 1071. Does anybody have any comment on this
issue? What should be done at the compile time to let multiple
connection use the same outgoing port? Thanks a lot.

	Best regards,
	ChungLiang
